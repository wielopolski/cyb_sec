class AddOtpColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_random_number, :integer
    add_column :users, :otp_verified, :boolean, default: false
    add_column :users, :first_login, :boolean, default: true
  end
end
