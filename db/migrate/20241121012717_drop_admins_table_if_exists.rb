class DropAdminsTableIfExists < ActiveRecord::Migration[6.1]
  def up
    # Check if the table exists before trying to drop it
    drop_table :admins if table_exists?(:admins)
  end

  def down
    # Optionally, recreate the table if rolling back
    create_table :admins do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.datetime :remember_created_at
      t.timestamps
    end
  end
end
