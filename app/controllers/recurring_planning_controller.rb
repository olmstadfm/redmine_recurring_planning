class RecurringPlanningController < ApplicationController
  unloadable

  before_filter :find_issue, :only => [:new, :create]

  def index

  end

  def new

  end

  def create
    schedule_from_params
    @issue.planning_schedule = @shedule
    @issue.save

    @schedule.occurrences(@issue.due_date).each do |occ|
      create_estimated_time_from_occurence(occ)
    end

    redirect_to issue_path(@issue)

  end

  private

  def schedule_from_params
    
    if params['validations']
      if params['validations']['day'].kind_of? Array
        params['validations']['day'].map!{|d| d.to_i}
      end
      if params['validations']['day_of_week'].kind_of? Hash
        # convert hash of strings to hash of integers
        params['validations']['day_of_week'] = params['validations']['day_of_week'].inject(Hash.new){|s,p| s[p[0].to_i] = p[1].map{|i| i.to_i}; s }
      end
      if params['validations']['day_of_month'].kind_of? Array
        params['validations']['day_of_month'].map!{|d| d.to_i} 
      end
    end

    params['interval'] = params['interval'].to_i

    @schedule = IceCube::Schedule.new(now = Time.now) do |s|
      s.add_recurrence_rule IceCube::Rule.from_hash(params)
    end
  end

  def create_estimated_time_from_occurence(occ)
    es = EstimatedTime.new(project_id: @issue.project_id, 
                           issue_id: @issue.id, 
                           user_id: @issue.assigned_to_id, 
                           hours: 1.0, 
                           plan_on: occ.to_date, 
                           comments: l(:label_recurring_planning_comment))
    if es.valid?
      es.save
    else
      Rails.logger.errors "  Estimated_times: #{es.errors.full_messages}".red
    end
  end

end
