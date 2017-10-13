class StatResult < ActiveRecord::Base
  belongs_to :service
  belongs_to :stat_type
end