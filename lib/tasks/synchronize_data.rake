desc 'Synchronize data'
task sync: :environment do
  SynchronizeDataJob.new.perform
  delayed_job = Delayed::Job.where(queue: 'sync_data').last
  delayed_job.update_attribute(:run_at, DateTime.now)
end
