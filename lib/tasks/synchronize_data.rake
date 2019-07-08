desc 'Synchronize person'
task sync: :environment do
  SynchronizePersonJob.perform
end
