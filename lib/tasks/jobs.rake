namespace :db do
  desc 'Schedule all cron jobs'
  task :schedule_jobs => :environment do
    glob = Rails.root.join('app', 'jobs', '**', '*_job.rb')
    Dir.glob(glob).each { |f| require f }
    CronJob.subclasses.each { |job| job.schedule }
  end
end

# invoke schedule_jobs automatically after every migration and schema load.
%w(db:migrate db:schema:load).each do |task|
  Rake::Task[task].enhance do
    Rake::Task['db:schedule_jobs'].invoke
  end
end
