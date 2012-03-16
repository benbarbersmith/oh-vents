module EventsHelper

  def event_item(item)
    unless item.nil?
      html = "<dt>".html_safe + item[:name].to_s + "</dt>\n<dd><span class='".html_safe + item[:class].to_s + "'>".html_safe + item[:value].to_s + "</span></dd>".html_safe
      return html
    end
  end

  def startdate
    if @event.enddate.nil?
      name = "Date"
    else
      name = "Start Date"
    end
    return {:name => name, 
            :value => @event.startdate.to_formatted_s(:rfc822),
            :class => 'startdate'}
  end

  def enddate
    unless @event.enddate.nil?
      return {:name => 'End Date', 
              :value => @event.enddate.to_formatted_s(:rfc822),
              :class => 'enddate'}
    end
    return nil
  end

  def location
    unless @event.location.nil?
      return {:name =>  'Location', 
              :value => @event.location,
              :class => 'location'}
    end
    return nil
  end

  def details
    unless @event.details.nil?
      return {:name =>  'Details', 
              :value => @event.details,
              :class => 'details'}
    end
    return nil
  end
end
