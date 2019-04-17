desc 'Synchronize data'
task sync: :environment do
  # run sync data job and set datetime of execution
  SynchronizeDataJob.new.perform
  delayed_job = Delayed::Job.where(queue: 'sync_data').last
  delayed_job.update_attribute(:run_at, DateTime.now)
end
