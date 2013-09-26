require 'redmine_recurring_planning/hooks'

Redmine::Plugin.register :redmine_recurring_planning do
  name 'Redmine Recurring Planning plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  
  project_module :recurring_planning do
    permission :edit_recurring_planning, {:recurring_planning => :index}
  end
  
end

Rails.configuration.to_prepare do

  [
   :issues_helper 
  ].each do |cl|
    require "redmine_recurring_planning/recurring_planning_#{cl}_patch"
  end

  [
    [IssuesHelper, RecurringPlanningPlugin::IssuesHelperPatch],
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end

end
