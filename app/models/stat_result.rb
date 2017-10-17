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

end