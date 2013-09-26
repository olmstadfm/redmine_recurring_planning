module RecurringPlanningPlugin
  module IssuesHelperPatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
    end

    module InstanceMethods
      def rule_type_options
        rule_types = [:dayly, :weekly, :monthly, :yearly]
        rule_types_collection = rule_types.map{|t| OpenStruct.new(name: t.to_s) }
        options_from_collection_for_select(rule_types_collection, 'name', 'name', (params[:recurrence_rule][:type].to_i rescue nil)).html_safe
      end
    end

  end
end
