class AddPlannedAmountToIssue < ActiveRecord::Migration
  def change

    add_column :issues, :planned_amount, :integer

  end
end
