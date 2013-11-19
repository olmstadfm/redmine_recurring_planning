require_dependency 'issue'

module RecurringPlanningPlugin
  module IssuePatch
    def self.included(base)

      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        has_one :issue_planning_schedule, :dependent => :destroy
      end

    end

    module ClassMethods
    end

    module InstanceMethods
       
      def planning_schedule
        if issue_planning_schedule
          issue_planning_schedule.planning_schedule
        end
      end

      def planned_amount
        if issue_planning_schedule
          issue_planning_schedule.amount
        end
      end

      def save_planning_schedule(schedule, amount=nil)
        if issue_planning_schedule
          issue_planning_schedule.planning_schedule = schedule || IceCube::Schedule.new
          issue_planning_schedule.amount = amount 
          issue_planning_schedule.save
        else
          create_issue_planning_schedule(planning_schedule: schedule, amount: amount)
        end
      end

    end
  end
end
