class RecurringPlanningController < ApplicationController
  unloadable

  before_filter :find_issue, :only => [:new, :create]

  def index
  end

  def new
  end

  def create

    @amount = params['amount'].to_f

    delete_current_schedule_occurences

    schedule = schedule_from_params

    schedule && schedule.occurrences_between(Date.today.end_of_week + 1.day, @issue.due_date).each do |occ|
      create_estimated_time_from_occurence(occ, @amount)
    end

    @issue.save_planning_schedule(schedule,) # TODO currently auto-saves issue_planning_schedule

    redirect_to issue_path(@issue)

  end

  private

  def schedule_from_params

    if params['rule_type'] == 'none'
      @issue.save_planning_schedule(nil, nil) if @issue.issue_planning_schedule
      # @issue.issue_planning_schedule.destroy if @issue.issue_planning_schedule
      return nil
    end

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

    IceCube::Schedule.new(now = Time.now) do |s|
      s.add_recurrence_rule IceCube::Rule.from_hash(params)
    end
  end

  def create_estimated_time_from_occurence(occ, amount)

    existing_entry = estimated_time_from_occurence(occ)

    if existing_entry
      existing_entry.hours += @amount
      existing_entry.save
    else
      es = EstimatedTime.new(estimated_time_conditions(occ).merge({hours: amount, comments: l(:label_recurring_planning_comment)} ))
      es.valid? ? es.save : Rails.logger.error("  Estimated_times: #{es.errors.full_messages}".red)
    end
  end

  def delete_current_schedule_occurences
    if old_schedule = @issue.planning_schedule
      old_schedule.occurrences_between(Date.today.end_of_week + 1.day, @issue.due_date).each do |occ|
        delete_estimated_time_from_occurence(occ)
      end
    end
  end

  def delete_estimated_time_from_occurence(occ)
    estimated_time = estimated_time_from_occurence(occ)
    estimated_time.destroy if estimated_time
  end

  def estimated_time_from_occurence(occ)
    EstimatedTime.where(estimated_time_conditions(occ)).first
  end

  def estimated_time_conditions(occ)
    {
      project_id: @issue.project_id, 
      issue_id: @issue.id, 
      user_id: @issue.assigned_to_id,
      plan_on: occ.to_date
    }
  end

end
