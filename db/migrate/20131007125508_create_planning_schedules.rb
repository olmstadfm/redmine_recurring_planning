class CreatePlanningSchedules < ActiveRecord::Migration
  def change
    create_table :planning_schedules do |t|
      t.integer :issue_id
      t.text :planning_schedule
      t.timestamps
    end
  end
end
