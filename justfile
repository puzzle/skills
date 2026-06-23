# Task runner for the Skills app. Run inside the nix dev shell (`nix develop`).
# `just` itself is provided by flake.nix. List all recipes with `just`.

set shell := ["bash", "-uc"]

# Show all available recipes
default:
    @just --list

# --- Setup -------------------------------------------------------------------

# One-shot environment setup: gems, JS deps and a ready-to-use database
init: deps db
    @echo "==> Done. Start developing with: just dev"

# Install Ruby gems (-> vendor/bundle) and JS deps (yarn 4 from the nix shell)
deps:
    bundle install
    yarn install

# --- Database (project-local PostgreSQL in tmp/postgres) ---------------------

# Start PostgreSQL, initializing the cluster on first run (idempotent)
[group('db')]
db-start:
    #!/usr/bin/env bash
    set -euo pipefail
    if pg_ctl -D "$PGDATA" status >/dev/null 2>&1; then
        echo "PostgreSQL already running on port $PGPORT"
        exit 0
    fi
    if [ ! -d "$PGDATA" ]; then
        echo "==> Initializing PostgreSQL cluster in $PGDATA"
        mkdir -p "$PGDATA"
        # trust auth: local-only dev DB. Rails still sends skills/skills; accepted.
        initdb --username=skills --auth=trust "$PGDATA" >/dev/null
    fi
    mkdir -p "$PGHOST"
    pg_ctl -D "$PGDATA" -l "$PGDATA/../server.log" \
        -o "-c listen_addresses=127.0.0.1 -p $PGPORT -c unix_socket_directories=$PGHOST" \
        start

# Stop PostgreSQL (no error if it is not running)
[group('db')]
db-stop:
    @pg_ctl -D "$PGDATA" stop 2>/dev/null || echo "PostgreSQL not running"

# Show PostgreSQL server status
[group('db')]
db-status:
    @pg_ctl -D "$PGDATA" status || true

# Create + migrate the development and test databases
[group('db')]
db: db-start
    bin/rails db:prepare

# Run pending migrations
[group('db')]
db-migrate: db-start
    bin/rails db:migrate

# Drop, recreate, migrate and seed the databases
[group('db')]
db-reset: db-start
    bin/rails db:reset

# Load seed data
[group('db')]
db-seed: db-start
    bin/rails db:seed

# Open a psql shell on the development database
[group('db')]
psql: db-start
    psql -h 127.0.0.1 -p "$PGPORT" -U skills -d skills_development

# --- Develop / run -----------------------------------------------------------

# Run the full dev stack: web + js + css watchers (Procfile.dev)
dev: db-start
    bin/dev

# Run only the Rails server
[group('run')]
server: db-start
    bin/rails server

# Open a Rails console
[group('run')]
console: db-start
    bin/rails console

# Build JS and CSS assets once
[group('run')]
assets:
    yarn build
    yarn build:css

# Show all routes
[group('run')]
routes:
    bin/rails routes

# --- Test & quality ----------------------------------------------------------

# Run the RSpec suite (pass extra args, e.g. `just test spec/models`)
test *args: db-start
    bundle exec rspec {{args}}

# Run RuboCop
lint:
    bundle exec rubocop

# Run RuboCop with autocorrect
lint-fix:
    bundle exec rubocop -A

# Brakeman security scan
brakeman:
    bin/brakeman

# Check gems for known vulnerabilities
audit:
    bin/bundler-audit check --update

# --- Maintenance -------------------------------------------------------------

# Stop services and clear Rails logs/tmp
clean: db-stop
    bin/rails log:clear tmp:clear
