namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Example User", :screen_name => "exampal")
    9.times do |n|
      name = Faker::Name.name
      screen_name = name.downcase.gsub(/[^a-z1-9]+/, '-').chomp('-')
      User.create!(:name => name, :screen_name => screen_name)
      u = User.last
      15.times do |e|
        name = "#{u.name}'s event #{e+1}"
        start_date = (DateTime.now + (e+1).hours)
        end_date = start_date + 1.hours
        location = "#{u.name}'s house"
        publicrsvp = false
        if rand(1..2) == 1 then publicrsvp = true end
        u.events.build(:name => name, :start_date => start_date, :end_date => end_date, :location => location, :publicrsvp => publicrsvp)
        u.save
      end
    end
  end
end
