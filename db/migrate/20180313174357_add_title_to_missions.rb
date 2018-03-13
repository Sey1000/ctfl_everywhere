class AddTitleToMissions < ActiveRecord::Migration[5.1]
  def change
    add_column :missions, :title, :string
  end
end
