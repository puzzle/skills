namespace :ptime do
  desc 'assign puzzletime employee ids to people'
  task :assign => :environment do
    Ptime::AssignEmployeeIds.new.run
  end
end