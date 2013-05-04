class CreateAlleApiAccounts < ActiveRecord::Migration
  def change
    create_table :alle_api_accounts do |t|

      t.timestamps
    end
  end
end
