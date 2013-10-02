require_dependency 'issue'

module RecurringPlanningPlugin
  module IssuePatch
    def self.included(base)

      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do

        serialize :planning_schedule, IceCube::Schedule

      end

    end

    module ClassMethods
    end

    module InstanceMethods
            
      # def planning_schedule
      #   IceCube::Schedule.load(read_attribute(:planning_schedule))
      # end

      # def planning_schedule=(arg)
      #   if arg.kind_of? IceCube::Schedule
      #     write_attribute(:planning_schedule, arg.to_yaml)
      #   elsif !arg
      #     write_attribute(:planning_schedule, nil)
      #   else
      #     raise ArgumentError
      #   end
      # end

    end
  end
end
