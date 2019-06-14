desc 'Synchronize person'
task sync: :environment do
  # run sync person job and set datetime of execution
  SynchronizePersonJob.perform
  delayed_job = Delayed::Job.where(queue: 'person_sync').last
  delayed_job.update_attribute(:run_at, DateTime.now)
end
