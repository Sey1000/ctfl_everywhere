class AddFieldsToMissions < ActiveRecord::Migration[5.1]
  def change
    add_column :missions, :contentful_id, :string
    add_index :missions, :contentful_id

    add_column :missions, :revision, :integer, default: 0

    add_column :missions, :longitude, :string
    add_column :missions, :latitude, :string

    add_column :missions, :due, :datetime
  end
end
