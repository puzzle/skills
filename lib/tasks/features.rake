# encoding: utf-8

#  Copyright (c) 2008-2016, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

Rake::TestTask.new do |t|
  t.libs = ["test"]
  t.name = "test:features"
  t.warning = false
  t.test_files = FileList['test/features/*_test.rb']
end
