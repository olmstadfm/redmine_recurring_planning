class ChangePlannedAmountType < ActiveRecord::Migration

  def change
    change_column :issues, :planned_amount, :float
  end

end
