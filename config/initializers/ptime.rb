Rails.application.config.to_prepare do
  PeopleController.include Ptime::PeopleController if Skills.ptime_available?
end