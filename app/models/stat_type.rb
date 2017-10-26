class StatType < ActiveRecord::Base
  has_and_belongs_to_many :services
  belongs_to :stat_source_type
end