class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :action
      t.integer :user_id
      t.string :user_email
      t.integer :activity_object_id
      t.string :object_text
      t.string :object_url
      t.integer :secondary_object_id
      t.string :secondary_object_url
      t.string :secondary_object_class
      t.string :secondary_object_method
      t.string :secondary_object_text
      t.string :type
      t.integer :library_id
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
