module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "bg-success"
      when "error"
        "bg-danger"
      when "alert"
        "bg-danger"
      when "notice"
        "bg-info"
      else
        flash_type.to_s
    end
  end

  def icon_text(text, icon)
    content_tag(:span, "", class: "glyphicon glyphicon-#{icon}") + " " + text
  end

  def date_format(date)
    date = date.in_time_zone("UTC")
    time_field = time_tag(date, datetime: date.strftime("%Y-%jT%RZ"), "data-timezone" => "UTC")
    time_field
  end

  def date_format_raw(date)
    date = date.in_time_zone("UTC")
    date.strftime("%B #{date.day.ordinalize}, %Y at %H:%M %P UTC")
  end
end
