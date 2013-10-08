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

      def planning_schedule=(arg)
        if issue_planning_schedule
          issue_planning_schedule.planning_schedule = arg || IceCube::Schedule.new
          issue_planning_schedule.save
        else
          create_issue_planning_schedule(planning_schedule: arg)
        end
      end

    end
  end
end
