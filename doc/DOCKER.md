<p align="center">
  <a href="https://github.com/puzzle/skills">
    <img src="https://skills.puzzle.ch/logo.svg"  width="400" height="82">
  </a>
</p>


## Docker

There's an official build on dockerhub: <https://hub.docker.com/r/puzzle/skills/>

| tag    | purpose       | description                                                                     |     
| ------ | ------------- | ------------------------------------------------------------------------------- |
| stable | production	 | built from stable branch with most recent tested/stable features      		   |
| latest | testing / dev | built from master branch which includes most recent but maybe unstable features |     

### Run with PostgreSQL

For ubuntu:

  Prerequisites are [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu) and [docker-compose](https://docs.docker.com/compose/install)

  1. `mkdir -p skills && cd skills`
  1. `get https://raw.githubusercontent.com/puzzle/skills/master/config/docker/postgresql/docker-compose.yml`
  1. `wget https://raw.githubusercontent.com/puzzle/skills/master/config/docker/postgresql/psql-prod.env.tmpl -O psql-prod.env`
  1. edit psql-prod.env
  1. `docker-compose up -d`
  1. `docker exec -it skills_web /bin/bash`
  1. `bundle exec rake db:setup`
  1. open http://localhost:8080 in the browser