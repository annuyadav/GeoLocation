# CreateTestSchema creates the tables used in test_helper.rb

superclass = ActiveRecord::Migration

superclass = ActiveRecord::Migration[5.0] if superclass.respond_to?(:[])

class CreateTestSchema < superclass
  def self.up
    create_table :locations do |t|
      t.column :ip_address, :string, null: false
      t.column :country_code, :string, null: false
      t.column :country, :string, null: false
      t.column :city, :string, null: false
      t.column :latitude, :decimal, :precision => 16, :scale => 6
      t.column :longitude, :decimal, :precision => 16, :scale => 6
      t.column :mystery_value, :integer
    end
  end
end