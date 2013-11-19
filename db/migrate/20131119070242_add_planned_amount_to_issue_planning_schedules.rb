class AddPlannedAmountToIssuePlanningSchedules < ActiveRecord::Migration
  def change

    remove_column :issues, :planned_amount

    add_column :issue_planning_schedules, :amount, :float

  end
end
