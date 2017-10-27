class AddYandexCounterIdToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :yandex_counter, :string
  end
end
