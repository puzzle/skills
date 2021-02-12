<p align="center">
  <a href="https://github.com/puzzle/skills">
    <img src="https://skills.puzzle.ch/logo.svg"  width="400" height="82">
  </a>
</p>

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/puzzle/skills/issues)
![Build Status](https://github.com/puzzle/skills/workflows/Rails/badge.svg)
![Stable Build Status](https://github.com/puzzle/skills/workflows/Rails/badge.svg?branch=stable)
![GitHub contributors](https://img.shields.io/github/contributors/puzzle/skills)
![GitHub last commit](https://img.shields.io/github/last-commit/puzzle/skills)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![GitHub stars](https://img.shields.io/github/stars/puzzle/skills)


PuzzleSkills is an open source webapplication to facilitate skill management.   
With the help of PuzzleSkills Users can manage their profiles, CVs and Skills.   

## Back-End

This is the Backend documentation for the PuzzleSkills Application .
The Back-End is built with [Ruby on Rails](https://rubyonrails.org/) with an API interface.

## Prerequisites

You will need the following things properly installed on your computer:

-   [Git (Version Control System)](http://git-scm.com/)
-   [RVM (Ruby Version Manager)](https://rvm.io/) ([installation](https://rvm.io/rvm/install) requires `curl` and `gpg`)
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
Note that the PostgreSQL gem `pg` requires header files for the Postgres library `libqp` to be available.  Therefore,
make sure `libpq-dev` is installed:
```shell
sudo apt install libpq-dev
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

## Front-End

The Front-End is built with EmberJS.

See [frontend/README.md](https://github.com/puzzle/skills/blob/master/frontend/README.md)


## Testing

-   To run the backend tests run `rake spec`
-   Frontend tests can be executed with `rake spec:frontend`
-   Frontend tests with livereload `rake spec:frontend:serve`
-   To run a single test run the following command in the frontend folder `npm test --filter "some filter words"`
-   There is also `rake ci` and `rake ci:nightly` which should be periodically exectued by a build job (e.g. on jenkins)

## Documentation
Find further Documentation at the links below

[Changelog](https://github.com/puzzle/skills/blob/master/doc/CHANGELOG.md)  
[Configuration](https://github.com/puzzle/skills/blob/master/doc/CONFIGURATION.md)  
[Contributing](https://github.com/puzzle/skills/blob/master/doc/CONTRIBUTING.md)  
[DockerImage](https://github.com/puzzle/skills/blob/master/doc/DOCKER.md)  

