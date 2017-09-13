class AddCommentCounterCacheToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :comments_count, :integer
  end
end
