# frozen_string_literal: true

class MainController < ApplicationController

  include Results
  def index

    table = {}

    stat_types = StatType.all.where stat_source_type_id: 1

    selected_stat_type = StatType.first
    service = Service.first

    stat_results = StatResult.where(service: service, stat_type: selected_stat_type).order(updated_at: :desc)

    table['rows'] = StatResult::to_rows(stat_results)

    service_labels = []
    table['rows'].each do |row|
      hash = row.dup
      hash.delete "date"

      hash.each do |key, val|
        if key.include? 'value'
          service_id = key.dup.sub! 'value_', ''
          title = Service.find(service_id).title
          service_labels.push title unless service_labels.include? title
        end
      end
    end

    header_row = ['Date']
    service_labels.each {|label| header_row.push label}

    all_services = Service.all
    all_services_array = []
    all_services.each do |s|
      element = {}

      element['id'] = s.id
      element['label'] = s.title
      all_services_array.push element
    end

    # header_row = %w(ID Service Date Value)
    table['header_row'] = header_row

    grouped_types = []
    %w(day week month year).each do |l|
      element = {}

      element['id'] = l
      element['label'] = l
      grouped_types.push element
    end

    @props = {}
    @props['stat_types'] = stat_types
    @props['all_services'] = all_services_array
    @props['grouped_types'] = grouped_types
    @props['table'] = table
    @props['metrics'] = Metrika::Routes.metrics
  end

  def renew_data

    stat_results = get_results params

    if stat_results.nil?
      response = {'status': 'error', 'data': {}}
    else
      data = {}

      if params[:grouped].blank?
        data['table_rows'] = StatResult::to_rows(stat_results)
      else
        data['table_rows'] = stat_results
      end

      response = {'status': 'ok', 'data': data}
    end

    render :json => response

  end

  def csv_data
    stat_results = get_results params

    rows = StatResult::to_rows stat_results
    csv = StatResult::to_csv rows

    respond_to do |format|
      format.csv { send_data csv }
    end
  end

  def commits_data
    require 'bitbucket_rest_api'

    Hashie.logger = Logger.new(nil)

    bitbucket_username = 'docomodigital'
    bitbucket_password = 'dn5CNacz8TT9aqZZ8gAd'

    bitbucket = BitBucket.new :basic_auth => "#{bitbucket_username}:#{bitbucket_password}"

    response = bitbucket.get_request("/repositories/#{bitbucket_username}/kioskplus/commits/")

    hashes_array = []
    hashes_array.push response.to_hash['values']

    next_page = response['next']
    next_page.slice! 'https://bitbucket.org/api/2.0'

    2.times do
      new_page = bitbucket.get_request(next_page)

      hashes_array.push new_page.to_hash['values']

      next_page = new_page['next']
      next_page.slice! 'https://bitbucket.org/api/2.0'
    end

    hashes_array.flatten!

    commits_array = []
    hashes_array.each do |commit|
      c = {
          'author'.freeze => commit['author']['raw'],
          'date'.freeze => commit['date'],
          'message'.freeze => commit['message']
      }
      commits_array.push c if commit_message_ok? c['message']
    end

    commits_array = remove_duplicate_commits commits_array

    commits_array_grouped_by_date = {}
    commits_array.each do |commit|
      date = commit['date'].to_date.strftime("%Y-%m-%d")

      commits_array_grouped_by_date[date] = [] unless commits_array_grouped_by_date[date].present?
      commits_array_grouped_by_date[date].push commit
    end

    commits_stacked = {}
    commits_array_grouped_by_date.each do |key, c_array|

      tooltip = String.new
      c_array.each do |commit|
        tooltip << commit['message']
      end

      commits_stacked[key] = tooltip
    end

    response = {'status':'ok', 'data':commits_stacked}
    render :json => response
  end

  def get_results(params)
    stat_results = []

    service_ids = params[:service_id]
    service_ids = service_ids.split ','
    stat_type_id = params[:stat_type_id]
    date_from = params[:date_from]
    date_to = params[:date_to]

    return nil if service_ids.blank? or stat_type_id.blank?

    stat_type = StatType.find stat_type_id
    source_type = stat_type.stat_source_type

    if source_type.code == 'stored'

      # old version

      # stat_results = StatResult.where(service: service_ids, stat_type: stat_type_id)
      #
      # stat_results = stat_results.where('updated_at > ?', DateTime.parse(date_from).strftime("%Y-%m-%d")) if date_from.present?
      # stat_results = stat_results.where('updated_at < ?', DateTime.parse(date_to).strftime("%Y-%m-%d")) if date_to.present?
      #
      # stat_results = stat_results.order created_at: :desc


      # Beware of black magic here!
      #todo rewrite asap
      if %w(day week month year).include? params[:grouped]
        exploded_service_ids = service_ids.join ','
        grouped_query = "SELECT id, sum(value), created_at, updated_at, service_id, stat_type_id
        FROM stat_results
        WHERE service_id in (#{exploded_service_ids}) AND stat_type_id = #{stat_type_id}
        GROUP BY service_id, #{params[:grouped]}(created_at)
        ORDER BY created_at DESC
        ;"

        results = ActiveRecord::Base.connection.execute(grouped_query)

        stat_results = []
        results.each do |res|
          hash = {}

          hash['date'] = res.third.strftime("%Y-%m-%d")
          hash['value_'+res.fifth.to_s] = res.second
          hash['service_id'] = res.fifth.to_s

          stat_results.push hash
        end
      else
        throw ArgumentError
      end

    else
      stat_params = {}
      stat_params['service_id'] = service_id
      stat_params['date_from'] = date_from
      stat_params['date_to'] = date_to

      klass = stat_type.stat_class

      handler = Results.const_get(klass).new
      handler.set_params stat_params

      stat_results = handler.get_results
    end

    StatResult::group_by_date stat_results
  end

  def metrika_get_data(metric, dates_array, services)

    token = 'AQAAAAAJroNSAASSMsJ5FtIsfEGZmZgr-3zM-sY'
    client = Metrika::Client.new('3e65055f4bb7474591bec61db2851665', '53d68c7ba4c541eeaae9ad0f4e094d9d')
    client.restore_token token
    client.set_metric metric

    # generate date intervals array for metrics requests
    dates_array.sort_by! {|d| y, m, d=d.split '-'; [y, m, d]}

    date_hashes_array = SUtils::dates_to_intervals dates_array

    data = []
    services.each do |service|
      client.set_counter_id service.yandex_counter
      date_hashes_array.each do |dates|

        client.set_date_from dates[:date_from]
        client.set_date_to dates[:date_to]

        response = client.stat_get

        hash = {service.id => parse_response(response)}

        data.push hash
      end
    end

    client.group_data data
  end

  def metrics_data
    dates = JSON.parse params[:dates]
    metric = params[:metrics]
    services_ids = params[:service_ids].split ','
    services = Service.where(id: services_ids)

    metric_symbol = metric.to_sym
    metric_code = Metrika::Routes.metrics[metric_symbol]

    data = metrika_get_data metric_code, dates, services

    response = {'status': 'ok', 'data': data}
    render :json => response
  end

  def parse_response(response)
    resp = {}
    resp[:value] = response['data'].first['metrics'].first
    resp[:date] = response['query']['date2']

    resp
  end

  def commit_message_ok?(message)
    true if message.include? '#PRD'
  end

  def remove_duplicate_commits(commits_array)
    commit_messages = []
    # commits_array.each {|c| commit_messages.push c['message'] unless commit_messages.include? c['message']}
    commits_array.delete_if do |commit|
      if commit_messages.include? commit['message']
        true
      else
        commit_messages.push commit['message']
        false
      end
    end
    commits_array
  end
end