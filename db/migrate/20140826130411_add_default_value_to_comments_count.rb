class AddDefaultValueToCommentsCount < ActiveRecord::Migration
  def change
    change_column :assets, :comments_count, :integer, :default => 0
  end
end
