class AddCreatorToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :creator_id, :integer
  end
end
