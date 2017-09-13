class AddAuditDetailsToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :ip, :string
    add_column :activities, :browser, :string
  end
end
