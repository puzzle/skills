Rake::TestTask.new do |t|
  t.libs = ['test']
  t.name = 'test:features'
  t.warning = false
  t.test_files = FileList['test/features/*_test.rb']
end
