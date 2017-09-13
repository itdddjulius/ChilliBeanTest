class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :filename
      t.integer :filesize, limit: 8
      t.string :file_id
      t.integer :file_type, default: 0
      t.references :library, index: true

      t.timestamps
    end
  end
end
