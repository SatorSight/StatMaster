module SUtils

  # @return [Array]
  # @param [Array] dates
  def self.dates_to_intervals(dates)
    throw new ArgumentError unless dates.is_a? Array

    date_hashes_array = []

    first_interval = {}
    first_interval[:date_from] = self.prev_day dates.first
    first_interval[:date_to] = dates.first

    date_hashes_array.push first_interval

    dates.each_with_index do |date, index|
      unless dates[index + 1].nil?
        interval = {}
        interval[:date_from] = date
        interval[:date_to] = dates[index + 1]
        date_hashes_array.push interval
      end
    end

    date_hashes_array
  end

  def self.prev_day(date)
    date.to_date.prev_day.strftime("%Y-%m-%d")
  end
end