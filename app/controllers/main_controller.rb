# frozen_string_literal: true

class MainController < ApplicationController

  include Results
  def index

    table = {}

    header_row = %w(ID Service Date Value)

    table['header_row'] = header_row

    stat_types = StatType.all.where stat_source_type_id: 1

    selected_stat_type = StatType.first
    service = Service.first

    stat_results = StatResult.where(service: service, stat_type: selected_stat_type).order(updated_at: :desc)

    table['rows'] = StatResult::to_rows(stat_results)

    all_services = Service.all
    all_services_array = []
    all_services.each do |s|
      element = {}

      element['id'] = s.id
      element['label'] = s.title
      all_services_array.push element
    end

    @props = {}
    @props['stat_types'] = stat_types
    @props['all_services'] = all_services_array
    @props['table'] = table
    @props['metrics'] = Metrika::Routes.metrics
    # @props['dates'] = dates

  end

  def renew_data

    stat_results = get_results params

    # raw_params = {}
    # raw_params['service_id'] = service_id
    # raw_params['stat_type_id'] = stat_type_id
    # raw_params['date_from'] = date_from
    # raw_params['date_to'] = date_to

    data = {}
    # data['params'] = raw_params
    data['table_rows'] = StatResult::to_rows(stat_results)

    response = {'status':'ok', 'data':data}

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
          'author' => commit['author']['raw'],
          'date' => commit['date'],
          'message' => commit['message']
      }
      commits_array.push c
    end

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

    service_id = params[:service_id]
    stat_type_id = params[:stat_type_id]
    date_from = params[:date_from]
    date_to = params[:date_to]

    if service_id.blank? or stat_type_id.blank?
      response = {'status':'error', 'data':{}}
      render :json => response and return
    end

    stat_type = StatType.find stat_type_id
    source_type = stat_type.stat_source_type

    if source_type.code == 'stored'

      stat_results = StatResult.where(service: service_id, stat_type: stat_type_id)

      stat_results = stat_results.where('updated_at > ?', DateTime.parse(date_from).strftime("%Y-%m-%d")) if date_from.present?
      stat_results = stat_results.where('updated_at < ?', DateTime.parse(date_to).strftime("%Y-%m-%d")) if date_to.present?

      stat_results = stat_results.order updated_at: :desc
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

    stat_results
  end

  def metrika_get_data(metric, dates_array, counter)

    token = 'AQAAAAAJroNSAASSMsJ5FtIsfEGZmZgr-3zM-sY'
    client = Metrika::Client.new('3e65055f4bb7474591bec61db2851665', '53d68c7ba4c541eeaae9ad0f4e094d9d')
    client.restore_token token

    client.set_counter_id counter
    client.set_metric metric

    data = []

    dates_array.sort_by! {|d| y, m, d=d.split '-'; [y, m, d]}

    date_hashes_array = []
    dates_array.each_with_index do |date, index|
      interval = {}
      unless dates_array[index + 1].nil?
        if index == 0
          interval[:date_from] = '2015-01-01'
          interval[:date_to] = date
        else
          interval[:date_from] = date
          interval[:date_to] = dates_array[index + 1]
        end
        date_hashes_array.push interval
      end
    end

    date_hashes_array.each do |dates|

      client.set_date_from dates[:date_from]
      client.set_date_to dates[:date_to]

      response = client.stat_get

      data.push parse_response response
    end

    data
  end

  def metrics_data
    dates = JSON.parse params[:dates]
    metric = params[:metrics]
    service = Service.find params[:service_id]
    counter = service.yandex_counter

    metric_symbol = metric.to_sym
    metric_code = Metrika::Routes.metrics[metric_symbol]

    data = metrika_get_data metric_code, dates, counter

    response = {'status': 'ok', 'data': data}
    render :json => response
  end

  def parse_response(response)
    resp = {}
    resp[:value] = response['data'].first['metrics'].first
    resp[:date] = response['query']['date2']

    resp
  end

end