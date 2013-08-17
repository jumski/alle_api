class AddMissingUtilityDefault < ActiveRecord::Migration
  def up
    change_column :alle_api_accounts, :utility, :boolean, default: false
  end

  def down
    change_column :alle_api_accounts, :utility, :boolean, default: nil
  end
end
