class AddDeletedAtToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :deleted_at, :Time
  end
end
