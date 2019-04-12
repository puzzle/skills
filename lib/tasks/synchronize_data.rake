desc 'Synchronize data'
task sync: :environment do
  SynchronizeDataJob.new.perform
end
