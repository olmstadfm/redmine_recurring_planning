require 'active_support/concern'

module RecurringPlanningHelper

  extend ActiveSupport::Concern
    
  def rule_type_options
    rule_types = {
      :none => l(:label_recurrence_none),
      :daily => l(:label_recurrence_dayly),
      :weekly => l(:label_recurrence_weekly),
      :monthly => l(:label_recurrence_monthly),
      :yearly => l(:label_recurrence_yearly)
    }
    rule_types_collection = rule_types.map{|k,v| OpenStruct.new(id: k.to_s, name: v.to_s) }
    options_from_collection_for_select(rule_types_collection, 'id', 'name', (params[:recurrence_rule][:type].to_i rescue nil)).html_safe
  end

  def weekdays_with_index
    res = (0..6).to_a.zip(::I18n::t('date.day_names'))
    res << res.shift
  end

  def dates_with_index
    ((1..31).to_a + [:last]).zip((1..31).to_a + [l(:label_recurrence_last)])
  end

  def dates_ul(param_name)
    ('<ul style = "list-style-type: none;">' +
      dates_with_index.map{|i, dt|
        '<li style="display: inline-block; width: 50px;">' + check_box_tag(param_name, i) + " " + dt.to_s + '</li>'
      }.each_slice(7).to_a.
     map{|sept|
       sept.join + '<br>' 
     }.join +
    '</ul>').html_safe
  end

  def weekdays_ul(param_name)
    ('<ul style = "list-style-type: none;">' +
      weekdays_with_index.map{|i, wd|
        '<li>' + check_box_tag(param_name, i) + wd + '</li>'
      }.join +
    '</ul>').html_safe
  end

  def weekdays_options
    weekdays_ul('recurrence[weekdays][]')
  end

  def monthly_dates_options
    dates_ul('recurrence[monthly_dates][]')
  end

  def monthly_weekdays_options
    weekdays_ul('recurrence[monthly_weekdays][]')
  end
    
  # self.instance_methods.each{|m| module_function m }
  
end
