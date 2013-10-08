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
    options_from_collection_for_select(rule_types_collection, 'id', 'name', (params[:recurrence_rule][:type].to_i rescue nil)).html_safe
  end

  def weekdays_with_index(format = 'day_names')
    res = (0..6).to_a.zip(::I18n::t("date.#{format}"))
    res << res.shift
  end

  def dates_ul(param_name)
    ('<ul style = "list-style-type: none;">' +
      (1..31).to_a.map{|dt|
        '<li style="display: inline-block; width: 50px;">' + check_box_tag(param_name, dt) + ' ' + dt.to_s + '</li>'
      }.each_slice(7).to_a.
      map{|sept|
        sept.join + '<br>' + '<hr>'
      }.join +
      '<li style="display: inline-block; width: 200px; margin-top: 10px;">' + check_box_tag(param_name, '-1') + ' ' + l(:label_recurrence_last) + '</li>' +
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
    weekdays_ul('validations[day][]')
  end

  def monthly_dates_options
    dates_ul('validations[day_of_month][]')
  end

  # def monthly_weekdays_options # old
  #   weekdays_ul('validations[day][]')
  # end
    
  def monthly_weekdays_options
    (1..4).map{|i|
      "<b style=\"margin-right: 10px;\">#{i}</b>" + 
      weekdays_with_index(:abbr_day_names).map{|j,wd| 
        check_box_tag("validations[day_of_week][#{j}][]", i, false, style: "margin-left: 15px;") + wd.to_s 
      }.join + '<br>' + '<hr>'
    }.join.html_safe
  end
  
end
