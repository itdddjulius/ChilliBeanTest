class AddTitleToAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :assets, :title, :string
  end
end
