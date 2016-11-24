# PuzzleCV 2

## Back-End

Das Back-End ist umgesetzt mit Ruby on Rails mit einer API Schnittstelle.

### Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [RVM](http://rvm.io/)
* PostgreSQL

### Development

* `git clone https://gitlab.puzzle.ch/pitc_puzzlecv/cv2.git`
* `cd cv2`
* `rvm install 2.3`
* `rvm use 2.3`
* `gem install bundler`
* `bundle`

#### database setup

* `sudo su - postgres`
* `createuser puzzlecv -s -l -P` (with password puzzlecv)

go back to user / cv2 dir
* `rake db:setup`

## Front-End

Das Front-End ist umgesetzt mit EmberJS.

see frontend/README.md
