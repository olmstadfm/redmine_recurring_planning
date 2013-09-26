module RedmineRecurringPlanning
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_sidebar_issues_bottom, :partial => 'issues/recurrence'
  end
end 
