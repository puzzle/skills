Rails.application.config.to_prepare do
  PeopleController.prepend Ptime::PeopleController if Skills.ptime_available?
end