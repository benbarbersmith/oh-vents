module EventsHelper

  def event_item(item)
    unless item.nil?
      html = "<dt>".html_safe + item[:name].to_s + "</dt>\n<dd><span class='".html_safe + item[:class].to_s + "'>".html_safe + item[:value].to_s + "</span></dd>".html_safe
      return html
    end
  end

  def start_date
    if @event.end_date.blank?
      name = "Date"
    else
      name = "Start Date"
    end
    return {:name => name, 
            :value => @event.start_date.to_formatted_s(:rfc822),
            :class => 'start_date'}
  end

  def end_date
    unless @event.end_date.blank?
      return {:name => 'End Date', 
              :value => @event.end_date.to_formatted_s(:rfc822),
              :class => 'end_date'}
    end
    return nil
  end

  def location
    unless @event.location.blank?
      return {:name =>  'Location', 
              :value => @event.location,
              :class => 'location'}
    end
    return nil
  end

  def details
    unless @event.details.blank?
      return {:name =>  'Details', 
              :value => @event.details,
              :class => 'details'}
    end
    return nil
  end
end
