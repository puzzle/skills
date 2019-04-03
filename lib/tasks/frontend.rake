namespace :frontend do
  desc 'prepare for running front end tests'
  task :prepare do
    sh 'cd frontend && yarn install'
  end
end

namespace :spec do
  desc 'Runs frontend unit tests'
  task :frontend do
    sh 'bin/frontend-tests.sh'
  end

  namespace :frontend do
  desc 'Runs frontend unit tests with livereload'
    task :serve do
      sh 'bin/frontend-tests.sh serve'
    end
  end
end

