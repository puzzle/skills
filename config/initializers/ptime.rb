Rails.application.config.after_initialize do
  PeopleController.prepend Ptime::PeopleController if Skills.ptime_available?
end