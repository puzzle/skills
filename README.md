![Skills Logo](logo.svg)

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/puzzle/skills/issues)
![Build Status](https://github.com/puzzle/skills/workflows/Rails/badge.svg)
![GitHub contributors](https://img.shields.io/github/contributors/puzzle/skills)
![GitHub last commit](https://img.shields.io/github/last-commit/puzzle/skills)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![GitHub stars](https://img.shields.io/github/stars/puzzle/skills)


PuzzleSkills is an open source web application to facilitate skill management.   
With the help of PuzzleSkills users can manage their profiles, CVs and Skills.
Managing employees and gaining an overview of each of their skills has never been easier.

![Skills Workflow](skills.gif)

## Prerequisites

You will need the following things properly installed on your computer:

-   [Git (Version Control System)](http://git-scm.com/)
-   [RVM (Ruby Version Manager)](https://rvm.io/) ([installation](https://rvm.io/rvm/install) requires `curl` and `gpg`)
-   Either [PostgreSQL](https://www.postgresql.org/) or [Docker](https://www.docker.com/) for the Database (Docker is recommended)

## 📄 Changelog
See what’s new in the latest versions by checking the [CHANGELOG.md](https://github.com/puzzle/skills/blob/master/doc/CHANGELOG.md).


## Setup dockerized Application👩🏽‍💻
We're glad you want to setup your machine for PuzzleSkills development 💃

### Windows users
If you're on Windows you should be able to Download Ubuntu from the Microsoft Store. Note that you need to enable Subsystem for Linux and virtual machine platform in your Windows features.  
Then you can open Ubuntu and follow the manual using the Ubuntu console.  
Once you're done, open your Windows IDE and navigate to the skills folder located in your Linux subsystem under Ubuntu to start developing.
If this doesn't work you can always use a VM.

First you need to clone this repository:

```bash
mkdir -p ~/git/ && cd ~/git/
git clone https://github.com/puzzle/skills.git && cd ~/git/skills
```

⚡ If your user id is not 1000 (run id -u to check), you need to export this as an env variable: **export UID=$UID** before running any of the further commands. You may want to add this to your `.bashrc` file for convenience.

## Start Development Containers
<img src="https://developers.redhat.com/sites/default/files/styles/article_feature/public/blog/2014/05/homepage-docker-logo.png?itok=zx0e-vcP" alt="docker whale" width="350">

**Without Keycloak (recommended)**
Since this is the default, you don't have to do anything and can run all commands inside the root of the project.

**With Keycloak**
To use the application with Keycloak, navigate to `config/docker/keycloak` and run all commands from this directory.
You can log in either as `user` or as `admin`. The password for both accounts is `password`.


### Start application
To start the PuzzleSkills application, run the following commands in your shell:

```bash
docker compose up -d
```

⚡ This will also install all required gems and seed the database, which takes some time to complete if it's executed the first time. You can follow the progress using `docker logs -f rails` (exit with Ctrl+C).

After the startup has completed (once you see `Listening on http://0.0.0.0:3000` in the logs), make sure all services are up and running:

```bash
docker ps
```

This should look something like this:

```
IMAGE              COMMAND                   CREATED          STATUS           PORTS                                       NAMES
ruby:3.4.1         "/bin/bash -c '\n cur…"   11 seconds ago   Up 9 seconds                                                 assets
skills-dev/rails   "rails-entrypoint ra…"    11 seconds ago   Up 9 seconds     0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   rails
postgres:16        "docker-entrypoint.s…"    11 seconds ago   Up 10 seconds    0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
```

Access the web application by browser: http://localhost:3000 and enjoy the ride!

## Skill snapshot for departments
The core competence of this feature is to track how many people in a department have a given skill. This also includes tracking the level of the skill.
It works by running a monthly DelayedJob that creates these 'Snapshots' for each department.
You can then take a look at these Snapshots using `chart.js` to see how the amount people with certain skills have changed over the span of a year. 
This also features a soft-delete for skills since we want to be able to access skills that have been a thing in the past.
For local development dynamically generated, extensive seeds are available for each department and skill.

**Make sure to start the delayed job worker**, otherwise the job won't be executed. You can find help on how to do this in
[the delayed job documentation](https://github.com/collectiveidea/delayed_job?tab=readme-ov-file#running-jobs)
or just simply run `rails jobs:work` to start working off queued delayed jobs.

## PuzzleTime synchronisation
If you are using PuzzleSkills as an external company this part of the application will only bother you once. The only thing you need to know is how to disable it.

### Description of the PuzzleTime sync
The PuzzleTime sync was written to make people data less redundant and have a single source of truth. A nightly delayed job
that runs at midnight fetches employee data from the PuzzleTime API. The fetched data is then mapped and displayed
as people attributes in the application. While the PuzzleTime sync is active, the user is not allowed to edit certain
attributes of a person. The synchronisation also makes sure to create new people or set people to inactive which results
in them not being updated anymore.

### How to disable it
The whole PuzzleTime sync is dependent on a ENV variable, for which a default value can be set in the 'use_ptime_sync?'
method. The default value is true but can easily set to false. This method is defined in the `application.rb` file.

### Manual sync
There may be cases where the synchronisation needs to be done throughout the day instead of at midnight. For this exact
case a manual sync button has been added to the admin view. This button instantly executes the delayed job and
updates all persons accordingly.

## Debugging
To interact with `pry` inside a controller, you have to attach to the container first using `docker attach rails`.
This will show you any **new** logs, and if you encounter a `pry` prompt, you can interact with it.
**To detach from the container without stopping it, press `CTRL + p` then `CTRL + q`.**


## Testing

-   To run the backend tests run `rake spec`
-   To test with a non-admin user, change the email in `app/controllers/application_controller.rb#authenticate_auth_user"` to "user@skills.ch"

## Documentation
Find further Documentation at the links below

[Changelog](https://github.com/puzzle/skills/blob/master/doc/CHANGELOG.md)  
[Contributing](https://github.com/puzzle/skills/blob/master/doc/CONTRIBUTING.md)  

