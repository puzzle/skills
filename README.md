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

# Disclaimer

We are currently rewriting the application and completely removing EmberJS.
The new Techstack will solely rely on Rails and some Hotwire/Stimulus.

If you still need the old state you can find the last release [here](https://github.com/puzzle/skills/releases/tag/v4.4.1).
The EmberJS-based Application will no longer be maintained.

However, we intend to provide the same functionality in the new Tech Stack without any fundamental data changes.

## Prerequisites

You will need the following things properly installed on your computer:

-   [Git (Version Control System)](http://git-scm.com/)
-   [RVM (Ruby Version Manager)](https://rvm.io/) ([installation](https://rvm.io/rvm/install) requires `curl` and `gpg`)
-   Either [PostgreSQL](https://www.postgresql.org/) or [Docker](https://www.docker.com/) for the Database (Docker is recommended)

## Setup dockerized Application👩🏽‍💻
We're glad you want to setup your machine for PuzzleSkills development 💃

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

After the startup has completed (once you see `Listening on tcp://0.0.0.0:4200` in the logs), make sure all services are up and running:

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
<img src="https://developers.redhat.com/sites/default/files/styles/article_feature/public/blog/2014/05/homepage-docker-logo.png?itok=zx0e-vcP" alt="docker whale" width="350">

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

