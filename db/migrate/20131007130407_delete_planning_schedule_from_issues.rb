class DeletePlanningScheduleFromIssues < ActiveRecord::Migration

  def change
    remove_column :issues, :planning_schedule
  end

end
