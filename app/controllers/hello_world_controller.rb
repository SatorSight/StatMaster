# frozen_string_literal: true

class HelloWorldController < ApplicationController
  layout "hello_world"

  def index

    header_row = %w(One Two Three)

    rows = []

    3.times do |time|
      row = [1 + time, 2, 3]
      rows.push row
    end

    @table = {}

    @table['header_row'] = header_row
    @table['rows'] = rows

    # @header_row = header_row
    # @rows = rows

    @hello_world_props = { name: "StatMaster" }
  end
end
