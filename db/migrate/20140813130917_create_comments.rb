class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.references :asset, index: true
      t.references :author, index: true

      t.timestamps
    end
  end
end
