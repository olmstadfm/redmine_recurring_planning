require_dependency 'issue'

module RecurringPlanningPlugin
  module IssuePatch
    def self.included(base)

      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do

        serialize :recurring_rule

      end

    end

    module ClassMethods
    end

    module InstanceMethods

      # fixme: rename field to something like recurring_planning or
      # recurring_planning_schedule. point is it returns schedule, not rule.
            
      def recurring_rule
        IceCube::Schedule.load(read_attribute(:recurring_rule))
      end

      def recurring_rule=(arg)
        if arg.kind_of? IceCube::Schedule
          write_attribute(:recurring_rule, arg.to_yaml)
        elsif !arg
          write_attribute(:recurring_rule, nil)
        else
          raise ArgumentError
        end
      end

    end
  end
end
