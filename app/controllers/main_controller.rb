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


    initial_rows = []
    stat_results.each do |res|
      element = {}

      element['id'] = res.id
      element['service'] = res.service.title
      element['date'] = res.updated_at.strftime("%Y-%m-%d")
      element['value'] = res.value

      initial_rows.push element
    end

    table['rows'] = initial_rows

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

    # @header_row = header_row
    # @rows = rows

    # @hello_world_props = { name: "StatMaster" }
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

    table_rows = []

    stat_results.each do |res|
      row = {}

      row['id'] = res.id
      row['service'] = res.service.title
      row['date'] = res.updated_at.strftime("%Y-%m-%d")
      row['value'] = res.value

      table_rows.push row
    end

    raw_params = {}
    raw_params['service_id'] = service_id
    raw_params['stat_type_id'] = stat_type_id
    raw_params['date_from'] = date_from
    raw_params['date_to'] = date_to

    data = {}
    data['params'] = raw_params
    data['table_rows'] = table_rows

    response = {'status':'ok', 'data':data}

    render :json => response

  end
end