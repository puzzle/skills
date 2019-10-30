# PuzzleSkills

[![Build Status](https://travis-ci.org/puzzle/skills.svg?branch=master)](https://travis-ci.org/puzzle/skills)

PuzzleSkills is a open source webapplication for skill management. Users can manage their profiles and CVs with PuzzleSkills. We are working on additional skill management features.

## Back-End

The Back-End is built with Ruby on Rails with an API interface.

### Prerequisites

You will need the following things properly installed on your computer.

-   [Git](http://git-scm.com/)
-   [RVM](http://rvm.io/)
-   PostgreSQL

### Development

-   `git clone https://github.com/puzzle/skills.git`
-   `cd skills`
-   `rvm install 2.5`
-   `rvm use 2.5`
-   `gem install bundler`
-   `sudo apt-get install libpq-dev`
-   `sudo apt-get install libmysqlclient-dev`
-   `bundle install`

#### database setup

##### Docker

-   Install docker and docker-compose <https://docs.docker.com/install/linux/docker-ce/ubuntu/>
-   `cd $project_git_dir` and `docker-compose up -d`

##### Classic

-   `sudo apt-get install postgresql postgresql-contrib`
-   `sudo su - postgres`
-   `createuser puzzlecv -s -l -P` (with password puzzlecv)
-   type `exit`

go back to skills repo

-   `rails db:setup`

now run backend server

-   `rails s`

#### Testing

-   To run the backend tests run `rake spec`
-   Frontend tests can be executed with `rake spec:frontend`
-   Frontend tests with livereload `rake spec:frontend:serve`
-   To run a single test run the following command in the frontend folder `npm test --filter "some filter words"`
-   There is also `rake ci` and `rake ci:nightly` which should be periodically exectued by a build job (e.g. on jenkins)

#### Definition of Done (DoD) for new Code / Features

-   implementation (inclusive correspondent frontend and backend tests)
-   `rake spec` passes
-   `rake spec:frontend` passes
-   `rake rubocop` passes
-   manual testing (start server, frontend and click through the new feature)
-   peer review
-   remove obsolete code

#### Entity Relationship Diagram

-   run `bundle exec erd` to create the current ERD

### LDAP config

The following environment variables are required for using ldap:

| Umgebungsvariable | Beschreibung                                       | Default |
| ----------------- | -------------------------------------------------- | ------- |
| LDAP_BASENAME     | LDAP Base name, e.g. ou=users,dc=yourdomain,dc=com | -       |
| LDAP_HOSTNAME     | LDAP Server host name                              | -       |
| LDAP_PORT         | LDAP Server Port                                   | 686     |

### Enable Authentication in development

Set the Environment variable ENABLE_AUTH to true in backend.

### Managing Roles

Roles can't be updated, created or deleted through the UI. For this you must use the rails console.

-   Enter the root folder and type `rails c`
-   Establish the connection to the table: `Role.connection`
-   Use `Role.create`, `Role.update` or `Role.delete` for your desired action.

Exact documentation for these methods can be found [here](https://guides.rubyonrails.org/active_record_basics.html#crud-reading-and-writing-data)

### Managing Categories

Categories can be added using the [skill_config.yml](https://github.com/puzzle/skills/blob/master/config/skill_config.yml) file.

But they can't be removed or updated this way. They have to be updated/deleted manually like the roles above.

## Docker

there's an official build on dockerhub: <https://hub.docker.com/r/puzzle/skills/>

| tag    | purpose       | description                                                                     |     |
| ------ | ------------- | ------------------------------------------------------------------------------- | --- |
| latest | testing / dev | built from master branch which includes most recent but maybe unstable features | -   |
| stable | production    | built from stable branch with most recent tested/stable features                |     |

### Run with PostgreSQL

For ubuntu:

  Prerequisites [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu) && [docker-compose](https://docs.docker.com/compose/install)

  1. `$ mkdir -p skills && cd skills`
  1. `$ wget https://raw.githubusercontent.com/puzzle/skills/master/images/docker/docker-compose.yml`
  1. `$ docker-compose up -d`
  1. `$ docker exec -it skills /bin/bash`
  1. `$ bundle exec rake db:setup`
  1. open http://localhost:3000 in the browser

## Front-End

The Front-End is built with EmberJS.

See [frontend/README.md](https://github.com/puzzle/skills/blob/master/frontend/README.md)
