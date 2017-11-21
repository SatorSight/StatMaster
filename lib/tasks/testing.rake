desc 'Testing functional parts'
task :testing => :environment do
  Rails.logger.level = Logger::DEBUG

  data = [{1 => {:value => 1892.0, :date => "2017-09-27"}},
          {1 => {:value => 1016.0, :date => "2017-10-11"}},
          {1 => {:value => 876.0, :date => "2017-10-12"}},
          {1 => {:value => 759.0, :date => "2017-10-13"}},
          {1 => {:value => 785.0, :date => "2017-10-14"}},
          {1 => {:value => 824.0, :date => "2017-10-15"}},
          {1 => {:value => 791.0, :date => "2017-10-16"}},
          {1 => {:value => 763.0, :date => "2017-10-17"}},
          {1 => {:value => 927.0, :date => "2017-10-18"}},
          {1 => {:value => 1059.0, :date => "2017-10-19"}},
          {1 => {:value => 1559.0, :date => "2017-10-20"}},
          {1 => {:value => 2342.0, :date => "2017-10-21"}},
          {1 => {:value => 2536.0, :date => "2017-10-22"}},
          {1 => {:value => 2743.0, :date => "2017-10-23"}},
          {1 => {:value => 3064.0, :date => "2017-10-24"}},
          {1 => {:value => 4314.0, :date => "2017-10-25"}},
          {1 => {:value => 4147.0, :date => "2017-10-26"}},
          {1 => {:value => 5366.0, :date => "2017-10-27"}},
          {1 => {:value => 7426.0, :date => "2017-10-28"}},
          {1 => {:value => 5972.0, :date => "2017-10-29"}},
          {1 => {:value => 4252.0, :date => "2017-10-30"}},
          {1 => {:value => 2244.0, :date => "2017-10-31"}},
          {1 => {:value => 902.0, :date => "2017-11-01"}},
          {1 => {:value => 843.0, :date => "2017-11-02"}},
          {1 => {:value => 1153.0, :date => "2017-11-03"}},
          {1 => {:value => 1370.0, :date => "2017-11-04"}},
          {1 => {:value => 1253.0, :date => "2017-11-05"}},
          {1 => {:value => 927.0, :date => "2017-11-06"}},
          {1 => {:value => 641.0, :date => "2017-11-07"}},
          {1 => {:value => 607.0, :date => "2017-11-08"}},
          {1 => {:value => 674.0, :date => "2017-11-09"}},
          {1 => {:value => 642.0, :date => "2017-11-10"}},
          {1 => {:value => 625.0, :date => "2017-11-11"}},
          {1 => {:value => 645.0, :date => "2017-11-12"}},
          {1 => {:value => 677.0, :date => "2017-11-13"}},
          {1 => {:value => 1037.0, :date => "2017-11-15"}},
          {1 => {:value => 555.0, :date => "2017-11-16"}},
          {2 => {:value => 229.0, :date => "2017-09-27"}},
          {2 => {:value => 352.0, :date => "2017-10-11"}},
          {2 => {:value => 287.0, :date => "2017-10-12"}},
          {2 => {:value => 80.0, :date => "2017-10-13"}},
          {2 => {:value => 54.0, :date => "2017-10-14"}},
          {2 => {:value => 59.0, :date => "2017-10-15"}},
          {2 => {:value => 141.0, :date => "2017-10-16"}},
          {2 => {:value => 161.0, :date => "2017-10-17"}},
          {2 => {:value => 85.0, :date => "2017-10-18"}},
          {2 => {:value => 80.0, :date => "2017-10-19"}},
          {2 => {:value => 82.0, :date => "2017-10-20"}},
          {2 => {:value => 57.0, :date => "2017-10-21"}},
          {2 => {:value => 79.0, :date => "2017-10-22"}},
          {2 => {:value => 74.0, :date => "2017-10-23"}},
          {2 => {:value => 70.0, :date => "2017-10-24"}},
          {2 => {:value => 100.0, :date => "2017-10-25"}},
          {2 => {:value => 123.0, :date => "2017-10-26"}},
          {2 => {:value => 113.0, :date => "2017-10-27"}},
          {2 => {:value => 107.0, :date => "2017-10-28"}},
          {2 => {:value => 99.0, :date => "2017-10-29"}},
          {2 => {:value => 89.0, :date => "2017-10-30"}},
          {2 => {:value => 101.0, :date => "2017-10-31"}},
          {2 => {:value => 107.0, :date => "2017-11-01"}},
          {2 => {:value => 101.0, :date => "2017-11-02"}},
          {2 => {:value => 121.0, :date => "2017-11-03"}},
          {2 => {:value => 128.0, :date => "2017-11-04"}},
          {2 => {:value => 114.0, :date => "2017-11-05"}},
          {2 => {:value => 89.0, :date => "2017-11-06"}},
          {2 => {:value => 53.0, :date => "2017-11-07"}},
          {2 => {:value => 72.0, :date => "2017-11-08"}},
          {2 => {:value => 66.0, :date => "2017-11-09"}},
          {2 => {:value => 35.0, :date => "2017-11-10"}},
          {2 => {:value => 59.0, :date => "2017-11-11"}},
          {2 => {:value => 67.0, :date => "2017-11-12"}},
          {2 => {:value => 56.0, :date => "2017-11-13"}},
          {2 => {:value => 144.0, :date => "2017-11-15"}},
          {2 => {:value => 33.0, :date => "2017-11-16"}}]


  [
      "2017-11-16" => {
          'value_1' => 33.0,
          'value_2' => 33.0,
      },
      "2017-11-17" => {
          'value_1' => 33.0,
          'value_2' => 33.0,
      },
  ]

  all_dates = {}
  grouped_data = []

  data.each do |hash|
    service_id = hash.keys[0]
    value_key = 'value_' << service_id.to_s
    date = hash[service_id][:date]
    value = hash[service_id][:value]
    new_hash = {value_key => hash[service_id][:value]}

    if all_dates.key? date
      all_dates[date][value_key] = value unless all_dates[date].key? value_key
    else
      all_dates[date] = new_hash
    end
  end

  all_dates.each do |key, val|
    element = {'date'.freeze => key}
    val.keys.each {|val_key| element[val_key] = val[val_key]}
    grouped_data.push element
  end

  ordered = grouped_data.sort_by {|k| k['date']}

  pp ordered
  exit
  pp 'done'
end




















