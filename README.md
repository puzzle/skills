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
Managing employees and getting an overview of each of their skills has never been easier.

![Skills Workflow](skills.gif)



## Back-End

This is the Backend documentation for the PuzzleSkills Application .
The Back-End is built with [Ruby on Rails](https://rubyonrails.org/) with an API interface.

## Prerequisites

You will need the following things properly installed on your computer:

-   [Git (Version Control System)](http://git-scm.com/)
-   [RVM (Ruby Version Manager)](https://rvm.io/) ([installation](https://rvm.io/rvm/install) requires `curl` and `gpg`)
-   Either [PostgreSQL](https://www.postgresql.org/) or [Docker](https://www.docker.com/) for the Database (Docker is recommended)

## Setup dockerized Application👩🏽‍💻
We're glad you want to setup your machine for PuzzleSkills development 💃

## System Requirements

You need to have [Docker][docker] and _[docker-compose][doco]_ installed on your computer.
The free _Docker Community Edition (CE)_ works perfectly fine. Make sure your user is part of the docker group:
```bash
usermod -a -G docker $USER
```

[docker]: https://docs.docker.com/install/
[doco]: https://docs.docker.com/compose/install/

Additionally you need **git** to be installed and configured.

🐧 This manual focuses on Linux/Ubuntu. PuzzleSkills development also runs on other plattforms with some adjustments.

### Windows users
If you're on Windows you should be able to Download Ubuntu from Microsoft Store. Note that you need to enable Subsystem for Linux and virtual machine platform in your Windows features.  
Then you can open Ubuntu and follow the manual using the Ubuntu console.  
When you finished use your Windows IDE and open the skills folder that's located in your Linux subsystem -> Ubuntu and start developing.  
If this doesn't work you can always use a VM.

First you need to clone this repository:

```bash
mkdir -p ~/git/ && cd ~/git/
git clone https://github.com/puzzle/skills.git && cd ~/git/skills
```

⚡ If your user id is not 1000 (run id -u to check), you need to export this as env variable: **export UID=$UID** before running any of the further commands. Maybe you want to add this to your bashrc.

## Start Development Containers
To start the PuzzleSkills application, run the following commands in your shell:

```bash
docker compose build
docker compose up -d
```

⚡ This will also install all required gems and seed the database, which takes some time to complete if it's executed the first time. You can follow the progress using `docker-compose logs --follow rails` (exit with Ctrl+C).

After the startup has completed (once you see `Listening on tcp://0.0.0.0:3000` in the logs), make sure all services are up and running:

```bash
docker-compose ps
```

This should look something like this:

```
Name                           Command                State   Ports                                                            
-------------------------------------------------------------------------------------------------------
skills-ember-1                 skills-postgres-1      Up      0.0.0.0:4200->4200/tcp, :::4200->4200/tcp
skills-postgres-1              docker-entrypoint.s…   Up      0.0.0.0:5432->5432/tcp, :::5432->5432/tcp
skills-rails-1                 rails-entrypoint ra…   Up      0.0.0.0:3000->3000/tcp, :::3000->3000/tcp
```

Access the web application by browser: http://localhost:4200 and enjoy the ride!
<img src="https://developers.redhat.com/sites/default/files/styles/article_feature/public/blog/2014/05/homepage-docker-logo.png?itok=zx0e-vcP" alt="docker whale">

## Setup undockerized Application 👩🏽‍💻

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
rvm install 2.7
```
Tell RVM to use the just install Ruby Version:
```shell
rvm use 2.7
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

