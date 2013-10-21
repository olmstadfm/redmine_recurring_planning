require 'redmine_recurring_planning/hooks'
require 'colorize'

Redmine::Plugin.register :redmine_recurring_planning do
  name 'Redmine Recurring Planning plugin'
  author 'antonovgks'
  description 'Autoplanning for issues.'
  version '0.0.1'
  url 'https://bitbucket.org/antonovgks/redmine_recurring_planning'
  author_url 'http://project.u-k-s.ru/people/479'
  
  project_module :recurring_planning do
    permission :edit_recurring_planning, {:recurring_planning => :index}
  end

end

Rails.configuration.to_prepare do

  [
   :issue
  ].each do |cl|
    require "redmine_recurring_planning/recurring_planning_#{cl}_patch"
  end

  [
    [Issue, RecurringPlanningPlugin::IssuePatch]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end

end
