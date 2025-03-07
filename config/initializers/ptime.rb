Rails.application.config.after_initialize do
  PeopleController.prepend Ptime::PeopleController if Skills.use_ptime_sync?
end