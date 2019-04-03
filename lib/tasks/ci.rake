desc 'Runs the taks for a commit build and nightly build'
task ci: ['log:clear',
          'db:migrate',
          'spec',
          'frontend:prepare',
          'spec:frontend',
          'brakeman',
          'rubocop']
