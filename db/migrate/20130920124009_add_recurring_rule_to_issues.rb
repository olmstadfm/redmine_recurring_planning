class AddRecurringRuleToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :recurring_rule, :string
  end
end
