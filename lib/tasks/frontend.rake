# encoding: utf-8

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

namespace :frontend do
  desc 'prepare for running front end tests'
  task :prepare do
    sh 'cd frontend && yarn install && bower install'
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

