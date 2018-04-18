#  Copyright (c) 2012-2016, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

desc 'Run brakeman'
task :brakeman do
  begin
    Timeout.timeout(300) do
      sh %w(brakeman).join(' ')
    end
  rescue Timeout::Error => e
    puts "\nBrakeman took too long. Aborting."
  end
end

desc 'Run rubocop-must.yml and fail if there are issues'
task :rubocop do
  begin
    sh 'rubocop --config .rubocop-must.yml'
  rescue
    abort('RuboCop failed!')
  end
end
