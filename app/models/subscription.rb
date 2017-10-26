class Subscription < ActiveRecord::Base
  self.table_name = 'subscription'
  has_and_belongs_to_many :users,
                          join_table: 'user_subscription',
                          association_foreign_key: 'user_id',
                          foreign_key: 'sub_id'
end