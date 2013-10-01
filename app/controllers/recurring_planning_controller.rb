class RecurringPlanningController < ApplicationController
  unloadable

  before_filter :find_issue, :only => [:new, :create]

  def index

  end

  def new

  end

  def create

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

    @issue.recurring_rule = IceCube::Schedule.new(now = Time.now) do |s|
      s.add_recurrence_rule IceCube::Rule.from_hash(params)
    end

    @issue.save

    redirect_to issue_path(@issue)

  end

end
