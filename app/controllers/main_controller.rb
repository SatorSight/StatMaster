# frozen_string_literal: true

class MainController < ApplicationController

  def index

    table = {}

    header_row = %w(ID Service Date Value)

    table['header_row'] = header_row

    stat_types = StatType.all

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

  end

  def renew_data

    service_id = params[:service_id]
    stat_type_id = params[:stat_type_id]
    date_from = params[:date_from]
    date_to = params[:date_to]

    if service_id.blank? or stat_type_id.blank?
      response = {'status':'error', 'data':{}}
      render :json => response and return
    end

    stat_results = StatResult.where(service: service_id, stat_type: stat_type_id)

    stat_results = stat_results.where('updated_at > ?', DateTime.parse(date_from).strftime("%Y-%m-%d")) if date_from.present?
    stat_results = stat_results.where('updated_at < ?', DateTime.parse(date_to).strftime("%Y-%m-%d")) if date_to.present?

    stat_results = stat_results.order updated_at: :desc

    raw_params = {}
    raw_params['service_id'] = service_id
    raw_params['stat_type_id'] = stat_type_id
    raw_params['date_from'] = date_from
    raw_params['date_to'] = date_to

    data = {}
    data['params'] = raw_params
    data['table_rows'] = StatResult::to_rows(stat_results)

    response = {'status':'ok', 'data':data}

    render :json => response

  end
end