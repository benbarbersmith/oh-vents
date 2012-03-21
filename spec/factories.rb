# By using the symbols :minimal_event and :full_event, we get Factory girl to simulate the event model.
    
Factory.define :minimal_event, :class => 'event' do |e|
  e.name        "Sunshiney day"
  e.start_date   (DateTime.now() + 1.days)
  e.association :user
end

Factory.define :full_event, :class => 'event' do |e|
  e.name        "Sunshine, lollipops and rainbows"
  e.start_date   (DateTime.now() + 1.days)
  e.end_date     (DateTime.now() + 2.days)
  e.location    "Somewhere, beyond the sea."
  e.details     "An epic party."
  e.association :user
end

Factory.sequence :name do |n|
  "Event #{n}"
end

Factory.sequence :start_date do |n|
  (DateTime.now + n.minutes)
end

Factory.define :user do |u|
  u.name        "David Evnull"
  u.screen_name "devnull"  
end

Factory.define :other, :class => 'user' do |u|
  u.name        "A. N. Other"
  u.screen_name "another"
end
