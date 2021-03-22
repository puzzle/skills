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
  1. `wget https://raw.githubusercontent.com/puzzle/skills/master/config/docker/postgresql/docker-compose.yml`
  1. `wget https://raw.githubusercontent.com/puzzle/skills/master/config/docker/postgresql/psql-prod.env.tmpl -O psql-prod.env`
  1. edit psql-prod.env
  1. `docker-compose up -d`
  1. `docker exec -it skills_web /bin/bash`
  1. `bundle exec rake db:setup`
  1. open http://localhost:8080 in the browser

### Run with PostgreSQL and Keycloak

This setup is a work in progress. Right now the setup doesn't work with Keycloak in confidential setting.

For ubuntu:

  Prerequisites are [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu) and [docker-compose](https://docs.docker.com/compose/install)

   1. Checkout the Repository with `git clone https://github.com/puzzle/skills`
   1. `cd skills`
   1. `docker build . -t puzzle/skills:latest`
   1. add `127.0.0.1   keycloak` to /etc/hosts
   1. `cd config/docker/keycloak`
   1. `docker-compose up -d`
   1. `docker exec -it skills_web /bin/bash`
   1. `bundle exec rake db:setup`
   1. open http://keycloak:8180 in the browser and login with the admin credentials from keycloak.env
   1. create new user in Keycloak with a temporary password
   1. open http://localhost:8080 in the browser login with the new User (if you login for the first time, update the password when asked) 

#### Add companies, roles, departments and person-role-levels

It is not possible to create a new profile without some predefined data. This data can be added with the following commands.

1. `docker exec -it skills_web /bin/bash`
1. `rails c`
1.
    ```shell
   Company.connection
   Company.create(name:"Firma")
   Company.create(name:"Partner")
   ```
1.
   ```shell
   Department.connection
   Department.create(name:"Funktionsbereiche")
   Department.create(name:"/dev/ruby")
   ```
