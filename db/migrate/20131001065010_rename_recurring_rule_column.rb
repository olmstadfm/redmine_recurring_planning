class RenameRecurringRuleColumn < ActiveRecord::Migration
  def change
    rename_column :issues, :recurring_rule, :planning_schedule
  end
end
