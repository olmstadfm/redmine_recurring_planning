require 'active_support/concern'

module RecurringPlanningHelper

  extend ActiveSupport::Concern
    
  def rule_type_options
    rule_types = {
      :none => l(:label_recurrence_none),
   #  "IceCube::DailyRule" => l(:label_recurrence_dayly),
      "IceCube::WeeklyRule" => l(:label_recurrence_weekly),
      "IceCube::MonthlyRule" => l(:label_recurrence_monthly),
   #  "IceCube::YearlyRule" => l(:label_recurrence_yearly)
    }
    rule_types_collection = rule_types.map{|k,v| OpenStruct.new(id: k.to_s, name: v.to_s) }
    # options_from_collection_for_select(rule_types_collection, 'id', 'name', (params[:recurrence_rule][:type].to_i rescue nil)).html_safe
    options_from_collection_for_select(rule_types_collection, 'id', 'name', current_rule_type).html_safe
  end

  def weekdays_with_index(format = 'day_names')
    res = (0..6).to_a.zip(::I18n::t("date.#{format}"))
    res << res.shift # week starts from monday (which index is 1)
  end


  def month_date_checked?(date_number)
    schedule = @issue.planning_schedule
    if schedule
      rule = schedule.recurrence_rules.first.try(:to_hash) || Hash.new
      if rule[:rule_type] == "IceCube::MonthlyRule"
        rule[:validations][:day_of_month].include?(date_number) rescue false
      else
        false
      end
    else
      false
    end
  end

  def dates_ul(param_name)
    ('<ul style = "list-style-type: none;">' +
      (1..31).to_a.map{|dt|
        '<li style="display: inline-block; width: 50px;">' + check_box_tag(param_name, dt, month_date_checked?(dt)) + ' ' + dt.to_s + '</li>'
      }.each_slice(7).to_a.
      map{|sept|
        sept.join + '<br>' + '<hr>'
      }.join +
      '<li style="display: inline-block; width: 200px; margin-top: 10px;">' + check_box_tag(param_name, '-1', month_date_checked?(-1)) + ' ' + l(:label_recurrence_last) + '</li>' +
    '</ul>').html_safe
  end

  def weekday_checked?(day_number)
    schedule = @issue.planning_schedule
    if schedule
      rule = schedule.recurrence_rules.first.try(:to_hash) || Hash.new
      if rule[:rule_type] == "IceCube::WeeklyRule"
        rule[:validations][:day].include?(day_number)
      else
        false
      end
    else
      false
    end
  end

  def weekdays_ul(param_name)
    ('<ul style = "list-style-type: none;">' +
      weekdays_with_index.map{|i, wd|
        '<li>' + check_box_tag(param_name, i, weekday_checked?(i)) + wd + '</li>'
      }.join +
    '</ul>').html_safe
  end

  def weekdays_options
    weekdays_ul('validations[day][]')
  end

  def monthly_dates_options
    dates_ul('validations[day_of_month][]')
  end

  # def monthly_weekdays_options # old
  #   weekdays_ul('validations[day][]')
  # end

  def monthly_weekdays_checked?(week_number, day_number)
    schedule = @issue.planning_schedule
    if schedule
      rule = schedule.recurrence_rules.first.try(:to_hash) || Hash.new
      if rule[:rule_type] == "IceCube::MonthlyRule"
        rule[:validations][:day_of_week][week_number].include?(day_number) rescue false
      else
        false
      end
    else
      false
    end

    # probably, this method should be written as follows:
    #   rule = @issue.planning_schedule.recurrence_rules.first.to_hash
    #   rule[:rule_type] == "IceCube::MonthlyRule" && rule[:validations][:day_of_week][week_number].include?(day_number)
    # rescue
    #   false

  end
    
  def monthly_weekdays_options
    (1..4).map{|i|
      "<b style=\"margin-right: 10px;\">#{i}</b>" + 
      weekdays_with_index(:abbr_day_names).map{|j,wd| 
        check_box_tag("validations[day_of_week][#{j}][]", i, monthly_weekdays_checked?(j,i), style: "margin-left: 15px;") + wd.to_s 
      }.join + '<br>' + '<hr>'
    }.join.html_safe
  end

  def current_rule_type
    if schedule = @issue.planning_schedule
      rule = schedule.recurrence_rules.first.try(:to_hash) || Hash.new
      rule_type = rule[:rule_type]
    end
  end

  
  def auto_select_tabs
    elements = [] 
    if schedule = @issue.planning_schedule
      rule = schedule.recurrence_rules.first.try(:to_hash) || Hash.new
      if rule[:rule_type] =~ /Monthly/
        select = '#recurrence-monthly'
        elements << select
        if rule[:validations].has_key?(:day_of_month)
          elements << select+'-by-date'
        elsif rule[:validations].has_key?(:day_of_week)
          elements << select+'-by-weekday'
        end
      elsif rule[:rule_type] =~ /Weekly/
        elements << '#recurrence-weekly'
      end
      elements << '#recurrence-details' unless elements.empty?
    end
    elements
  end

end
