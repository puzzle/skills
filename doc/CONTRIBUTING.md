# Contributing

Thanks for your interest in improving PuzzleSkills! 🎉
Feel free to tackle one of the [open issues](https://github.com/puzzle/skills/issues) or
propose a completely new feature.

This guide walks you through the whole flow: setting up a development environment,
running the app and the tests, and getting your change merged.

## Contribution Workflow

1. **Fork** the repository (external contributors) or create a branch directly
   (if you have write access to `puzzle/skills`).
2. **Create a branch** off `master` with a descriptive name, e.g.
   `feat/skill-filter` or `fix/1234-broken-login`.
3. **Implement** your change, including tests (see the [Definition of Done](#definition-of-done)).
4. **Run the tests and linter locally** (see [Testing](#testing) and [Linting](#linting)).
5. **Commit** following the [Conventional Commits](https://www.conventionalcommits.org/)
   format, e.g. `feat: add skill level filter`.
6. **Open a pull request** against the `master` branch of `puzzle/skills`.
   A maintainer will be assigned as reviewer.

## Setting up a Development Environment

You can develop PuzzleSkills either with the **dockerized setup (recommended)** or with a
**local toolchain**. Pick whichever you prefer — both result in the app running on
http://localhost:3000.

### Prerequisites

- [Git](https://git-scm.com/)
- For the dockerized setup: [Docker](https://www.docker.com/) with Docker Compose
- For the local setup: a Ruby version manager (e.g. [rbenv](https://github.com/rbenv/rbenv),
  [asdf](https://asdf-vm.com/) or [RVM](https://rvm.io/)), [Node.js](https://nodejs.org/) and
  [PostgreSQL](https://www.postgresql.org/)

The required tool versions are pinned in [`.tool-versions`](../.tool-versions):

| Tool       | Version  |
| ---------- | -------- |
| Ruby       | 4.0.1    |
| Node.js    | 24.13.0  |
| Yarn       | 4.12.0   |
| PostgreSQL | 18       |

Clone the repository first:

```bash
git clone https://github.com/puzzle/skills.git
cd skills
```

### Option A — Dockerized setup (recommended)

The project uses [Docker Compose profiles](https://docs.docker.com/compose/how-tos/profiles/)
to manage different sets of services.

> ⚡ If your user id is not `1000` (check with `id -u`), export it before running any command:
> `export UID=$UID` (consider adding this to your `.bashrc`).

1. **Build the images** (first time, or after dependency changes):

   ```bash
   docker compose --profile all build
   ```

   Add `--no-cache` if you want to rebuild from scratch.

2. **Start the development containers** (`postgres`, `rails`, `assets`, `worker`):

   ```bash
   docker compose up -d
   ```

   On the first start this also installs all gems and seeds the database, which takes a
   while. Follow the progress with `docker logs -f rails` (exit with `Ctrl+C`). The app is
   ready once you see `Listening on http://0.0.0.0:3000`.

3. **Open the app** at http://localhost:3000.

Stop the containers with `docker compose down`.

Run commands inside the running `rails` container, e.g.:

```bash
docker compose exec rails bin/rails console
docker compose exec rails bin/rails db:migrate
```

### Option B — Local toolchain

1. **Install the tool versions** from `.tool-versions` with your version manager, then
   enable Yarn via Corepack:

   ```bash
   corepack enable
   ```

2. **Start a PostgreSQL server** and make sure the credentials match
   [`config/database.yml`](../config/database.yml) (defaults to user `skills` /
   password `skills` on `127.0.0.1:5432`). You can override these via the `RAILS_DB_*`
   environment variables.

3. **Set up the project** — install dependencies and prepare the database:

   ```bash
   bundle install
   yarn install
   bin/rails db:prepare
   ```

   Alternatively, `bin/setup --skip-server` installs the gems and runs `db:prepare` for
   you (you still need to run `yarn install` for the JS dependencies).

4. **Run the app** (starts the Rails server plus the JS and CSS watchers on port 3000):

   ```bash
   bin/dev
   ```

> **Delayed jobs:** features like the monthly department snapshots rely on a background
> worker. The dockerized setup runs a `worker` container automatically; locally, run
> `bin/rails jobs:work` in a separate terminal.

## Testing

The backend test suite runs with RSpec.

- **Local:**

  ```bash
  bundle exec rspec        # or: rake spec
  ```

- **Docker:**

  ```bash
  bin/test                 # runs the suite inside the test container
  ```

To test as a non-admin user, change the email in
`app/controllers/application_controller.rb#authenticate_auth_user` to `user@skills.ch`.

## Linting

This project follows the standard Ruby/Rails style enforced by RuboCop.

- **Local:** `bin/rubocop` (or `bundle exec rubocop`)
- **Docker:** `docker compose exec rails bin/rubocop`

Use `-A` to apply safe autocorrections: `bin/rubocop -A`.

## Git Hooks

Install the pre-commit hooks (runs RuboCop and other checks before each commit):

```bash
overcommit --install
```

## Definition of Done

Before requesting a review, make sure your change satisfies all of the following:

- [ ] Implementation including tests (feature tests wherever a user-facing flow is involved)
- [ ] `rake spec` passes
- [ ] `rubocop` passes
- [ ] Manually tested (start the server and click through the new feature)
- [ ] Obsolete code removed
- [ ] Code follows the [guidelines](#code-guidelines) below
- [ ] Peer review (a reviewer will be assigned)

## Code Guidelines

- [Ruby Style Guide](https://github.com/rubocop-hq/ruby-style-guide)
- [Rails Style Guide](https://github.com/rubocop-hq/rails-style-guide)
- Use spaces instead of tabs

## Commit Guidelines

- Follow [Conventional Commits](https://www.conventionalcommits.org/)

## Entity Relationship Diagram

To get an overview of the data model, generate an ERD:

```bash
bundle exec erd
```
