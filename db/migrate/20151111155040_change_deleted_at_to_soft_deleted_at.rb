class ChangeDeletedAtToSoftDeletedAt < ActiveRecord::Migration
  def change
    rename_column :assets, :deleted_at, :soft_deleted_at
  end
end
