class RenamePlanningSchedule < ActiveRecord::Migration
  def up
    rename_table :planning_schedules, :issue_planning_schedules
  end
end
