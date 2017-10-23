class StatResult < ActiveRecord::Base
  belongs_to :service
  belongs_to :stat_type

  def self.to_rows(stat_results)
    rows = []
    stat_results.each do |res|
      element = {}

      element['id'] = res.id
      element['service'] = res.service.title
      element['date'] = res.updated_at.strftime("%Y-%m-%d")
      element['value'] = res.value

      rows.push element
    end
    rows
  end

  def self.to_csv(stat_results)
    require 'csv'

    attributes = %w{id service date value}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      stat_results.each do |stat|
        csv << attributes.map{ |attr| stat[attr] }
      end
    end
  end

end