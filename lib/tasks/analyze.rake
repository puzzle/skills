desc 'Run brakeman'
task :brakeman do
  begin
    Timeout.timeout(300) do
      sh %w(brakeman).join(' ')
    end
  rescue Timeout::Error
    puts "\nBrakeman took too long. Aborting."
  end
end

desc 'Run rubocop and fail if there are issues'
task :rubocop do
  begin
    sh 'rubocop'
  rescue
    abort('RuboCop failed!')
  end
end
