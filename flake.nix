{
  description = "Dev shell for the Skills Rails app (Ruby 4.0 / Node 24 / PostgreSQL 18)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          # Toolchain pinned to match .tool-versions / docker-compose.yml.
          # (nixpkgs ships Ruby 4.0.5; the project requests 4.0.1 — patch-compatible.)
          packages = with pkgs; [
            ruby_4_0
            nodejs_24       # Node 24 runtime (also ships corepack and yarn 4.12.1)
            #yarn-berry_4    # Yarn 4.14.x — matches the Yarn 4 line pinned in package.json
            postgresql_18
            just            # task runner (see ./justfile)

            # Build/runtime deps for native gems
            pkg-config
            libxml2         # nokogiri
            libxslt         # nokogiri
            libffi          # ffi / ruby-vips
            libyaml         # psych
            openssl
            zlib
            postgresql_18.lib  # libpq for the pg gem
            vips            # ruby-vips (loaded at runtime via FFI)
            imagemagick     # mini_magick (shells out to the CLI)
            graphicsmagick
          ];

          # Static env vars: any non-special attribute is exported into the shell.
          # (Path-derived vars that need $PWD live in shellHook — see below.)

          # Database connection (matches config/database.yml defaults).
          RAILS_DB_HOST = "127.0.0.1";
          RAILS_DB_PORT = "5432";
          RAILS_DB_USERNAME = "skills";
          RAILS_DB_PASSWORD = "skills";

          # Project-local PostgreSQL (managed via the justfile).
          PGPORT = "5432";
          PGUSER = "skills";

          shellHook = ''
            # Path-derived vars: kept here because attribute values are not
            # shell-expanded, so $PWD must be resolved at shell-entry time.

            # --- Project-local state, nothing installed globally -----------------
            export PROJECT_ROOT="$PWD"
            export BUNDLE_PATH="$PROJECT_ROOT/vendor/bundle"
            export BUNDLE_BIN="$PROJECT_ROOT/vendor/bundle/bin"
            export GEM_HOME="$BUNDLE_PATH"
            export PATH="$BUNDLE_BIN:$PATH"

            # Yarn 4 comes from nixpkgs (yarn-berry_4) — no corepack download needed.

            # --- Project-local PostgreSQL data dir / socket ----------------------
            export PGDATA="$PROJECT_ROOT/tmp/postgres/data"
            export PGHOST="$PROJECT_ROOT/tmp/postgres/sockets"

            echo
            echo '  Skills dev shell ready. Tasks are managed with `just` — run `just` for the list.'
            echo
            echo '  First time:   just init     (gems + JS deps + database)'
            echo '  Develop:      just dev       Test: just test       Lint: just lint'
            echo
          '';
        };
      });
    };
}
