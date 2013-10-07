class PlanningScheduleToText < ActiveRecord::Migration
  def up
    change_column(:issues, :planning_schedule, :text)
  end

  def down
    change_column(:issues, :planning_schedule, :string)
  end
end
