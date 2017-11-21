class StatResult < ActiveRecord::Base
  belongs_to :service
  belongs_to :stat_type

  def self.to_rows(stat_results)
    rows = []
    stat_results.each do |res|
      element = {}

      element['date'] = res.updated_at.strftime("%Y-%m-%d")
      element['value_' << res.service.id.to_s] = res.value
      element['service_id'] = res.service.id.to_s

      rows.push element
    end

    self.group_by_date rows
  end

  def self.to_csv(stat_results)
    require 'csv'

    attributes = []
    stat_results.each do |res|
      res.each do |key, val|
        attributes.push key unless attributes.include? key
      end
    end

    CSV.generate(headers: true) do |csv|
      csv << attributes

      stat_results.each do |stat|
        csv << attributes.map{ |attr| stat[attr] }
      end
    end
  end

  private

  def self.group_by_date(rows)

    all_dates = {}
    rows.each do |row|
      value_key = 'value_' << row['service_id']

      if all_dates.key? row['date']
        all_dates[row['date']][value_key] = row[value_key] unless all_dates[row['date']].key? value_key
      else
        all_dates[row['date']] = {
            'date'.freeze => row['date'],
            value_key => row[value_key]
        }
      end
    end

    all_dates.values
  end

end