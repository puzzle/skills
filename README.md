# Puzzle Skills

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

Don't forget to run `rake rubocop` after making code changes. 

#### database setup

* `sudo su - postgres`
* `createuser puzzlecv -s -l -P` (with password puzzlecv)

go back to user / cv2 dir
* `rails db:setup`

now run backend server
* `rails s`

#### Testing

* To run the backend tests run `rake spec` 
* Frontend tests can be executed with `rake spec:frontend`
* Frontend tests with livereload `rake spec:frontend:serve`
* To run a single test run the following command in the frontend folder `npm test --filter "some filter words"`
* There is also `rake ci` and `rake ci:nightly` which should be periodically exectued by a build job (e.g. on jenkins)

### LDAP config

The following environment variables are required for using ldap:

| Umgebungsvariable | Beschreibung | Default |
| --- | --- | --- |
| LDAP_BASENAME | LDAP Base name, e.g. ou=users,dc=yourdomain,dc=com  | - |
| LDAP_HOSTNAME | LDAP Server host name | - |
| LDAP_PORT | LDAP Server Port | 686 |

### Enable Authentication in development

Set the Environment variable ENABLE_AUTH to true in backend.

## Front-End

Das Front-End ist umgesetzt mit EmberJS.

see frontend/README.md
