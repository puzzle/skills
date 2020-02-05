<p align="center">
  <a href="https://github.com/puzzle/skills">
    <img src="https://skills.puzzle.ch/logo.svg"  width="400" height="82">
  </a>
</p>

[![Build Status](https://travis-ci.org/puzzle/skills.svg?branch=master)](https://travis-ci.org/puzzle/skills)

PuzzleSkills is an open source webapplication to facilitate skill management.   
With the help of PuzzleSkills Users can manage their profiles, CVs and Skills.   

## Back-End

This is the Backend documentation for the PuzzleSkills Application .
The Back-End is built with [Ruby on Rails](https://rubyonrails.org/) with an API interface.

## Prerequisites

You will need the following things properly installed on your computer:

-   [Git (Version Control System)](http://git-scm.com/)
-   [RVM (Ruby Version Manager)](http://rvm.io/)
  -   Either [PostgreSQL](https://www.postgresql.org/) or [Docker](https://www.docker.com/) for the Database (Docker is recommended)

## Quick Setup

Clone the repository to your machine:
```shell
git clone https://github.com/puzzle/skills.git
```  
Enter the repository:
```shell
cd skills
```
Install Ruby with the help of RVM:
```shell
rvm install 2.5
```
Tell RVM to use the just install Ruby Version:
```shell
rvm use 2.5
```
Install the ruby package manager:
```shell
gem install bundler
```
And let the bundler install all the prerequisite gems:
```shell
bundle install
```

#### Database setup

##### With Docker

  Install [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [docker-compose](https://docs.docker.com/compose/install/)
```
docker-compose up -d
```

##### Just with Vanilla Postgresql
Install Postgresql

```shell
sudo apt-get install postgresql postgresql-contrib
```
Start Postgresql as superuser
```shell
sudo su - postgres
```
Create the user skills
```shell
createuser skills -s -l -P
```
(with password 'skills')
```shell
exit
```


##### With the Server setup completed
go back to the skills folder

And let rails setup the database  
```shell
rails db:setup
```

## Running / Development
You can run the backend server with
```shell
rails s
```
Congratulations you have the Ruby on Rails backend up and running.
From here on continue with the [frontend setup](https://github.com/puzzle/skills/blob/master/frontend/README.md)

## Testing

-   To run the backend tests run `rake spec`
-   Frontend tests can be executed with `rake spec:frontend`
-   Frontend tests with livereload `rake spec:frontend:serve`
-   To run a single test run the following command in the frontend folder `npm test --filter "some filter words"`
-   There is also `rake ci` and `rake ci:nightly` which should be periodically exectued by a build job (e.g. on jenkins)


## Contributing
#### Definition of Done (DoD) for new Code / Features

-   Implementation (including frontend and backend tests)
-   `rake spec` passes
-   `rake spec:frontend` passes
-   `rubocop` passes
-   Manual testing (start server, frontend and click through the new feature)
-   Peer review (We will assign a reviewer)
-   Remove obsolete code

#### Entity Relationship Diagram
To gain an overview of the project an ERD might help, run:

```shell
bundle exec erd
```

## Configuration

### LDAP config

The following environment variables are required for using ldap:

| Umgebungsvariable | Beschreibung                                       | Default |
| ----------------- | -------------------------------------------------- | ------- |
| LDAP_BASENAME     | LDAP Base name, e.g. ou=users,dc=yourdomain,dc=com | -       |
| LDAP_HOSTNAME     | LDAP Server host name                              | -       |
| LDAP_PORT         | LDAP Server Port                                   | 686     |

### Enable Authentication in development

Set the Environment variable ENABLE_AUTH to true in backend.

### Managing Data

Roles, departments and person-role-levels can't be updated, created or deleted through the UI. For this you must use the rails console.

-   Enter the root folder and type `rails c`
-   Establish the connection to the table: `Model.connection` e.g. `Role.connection`
-   Use `Model.create`, `Model.update` or `Model.delete` for your desired action.

Model names: Role, PersonRoleLevel, Department

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
  1. `$ wget https://raw.githubusercontent.com/puzzle/skills/master/config/docker/postgresql/docker-compose.yml`
  1. `$ wget https://raw.githubusercontent.com/puzzle/skills/master/config/docker/postgresql/psql-prod.env.tmpl -O psql-prod.env`
  1. edit psql-prod.env
  1. `$ docker-compose up -d`
  1. `$ docker exec -it skills_web /bin/bash`
  1. `$ bundle exec rake db:setup`
  1. open http://localhost:8080 in the browser

## Front-End

The Front-End is built with EmberJS.

See [frontend/README.md](https://github.com/puzzle/skills/blob/master/frontend/README.md)
