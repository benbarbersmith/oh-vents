module EventsHelper

  def event_status
    if (@event.publicrsvp && @event.publicguestlist) then
      return "public"
    elsif @event.publicrsvp then
      return "closed"
    else
      return "secret"
    end
  end

  def event_item(item)
    unless item.nil?
      content_tag(:dt, item[:name]) + content_tag(:dd, item[:value], :class => item[:class])
    end
  end

  def publicity
    status = event_status()
    return {:name  => "",
            :value => "This event is #{status}.",
            :class => "publicity" }
  end

  def start_date
    if @event.end_date.blank?
      name = "Date"
    else
      name = "Start Date"
    end
    return {:name => name, 
            :value => @event.start_date.to_formatted_s(:friendly),
            :class => 'start_date'}
  end

  def end_date
    unless @event.end_date.blank?
      return {:name => 'End Date', 
              :value => @event.end_date.to_formatted_s(:friendly),
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
