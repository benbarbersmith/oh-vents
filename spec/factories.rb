# By using the symbols :minimal_event and :full_event, we get Factory girl to simulate the event model.
    
Factory.define :minimal_event, :class => 'event' do |e|
  e.name        "Sunshiney day"
  e.startdate   (DateTime.now() + 1.days)
end

Factory.define :full_event, :class => 'event' do |e|
  e.name        "Sunshine, lollipops and rainbows"
  e.startdate   (DateTime.now() + 1.days)
  e.enddate     (DateTime.now() + 2.days)
  e.location    "Somewhere, beyond the sea."
  e.details     "An epic party."
end
