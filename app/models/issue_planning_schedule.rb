class IssuePlanningSchedule < ActiveRecord::Base

  belongs_to :issue
  serialize :planning_schedule

end
