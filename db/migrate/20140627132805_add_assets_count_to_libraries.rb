class AddAssetsCountToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :assets_count, :integer, default: 0
  end
end
