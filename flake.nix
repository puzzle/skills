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
            nodejs_24       # bundles corepack, which provides yarn 4.12.0
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

          shellHook = ''
            # --- Project-local state, nothing installed globally -----------------
            export PROJECT_ROOT="$PWD"
            export BUNDLE_PATH="$PROJECT_ROOT/vendor/bundle"
            export BUNDLE_BIN="$PROJECT_ROOT/vendor/bundle/bin"
            export GEM_HOME="$BUNDLE_PATH"
            export PATH="$BUNDLE_BIN:$PATH"

            # Yarn 4.12 via corepack, kept inside the project.
            # `corepack enable` requires the target dir to exist beforehand.
            export COREPACK_HOME="$PROJECT_ROOT/tmp/corepack"
            mkdir -p "$PROJECT_ROOT/tmp/corepack-bin"
            corepack enable --install-directory "$PROJECT_ROOT/tmp/corepack-bin" >/dev/null 2>&1 || true
            export PATH="$PROJECT_ROOT/tmp/corepack-bin:$PATH"

            # --- Database connection (matches config/database.yml defaults) ------
            export RAILS_DB_HOST="127.0.0.1"
            export RAILS_DB_PORT="5432"
            export RAILS_DB_USERNAME="skills"
            export RAILS_DB_PASSWORD="skills"

            # --- Project-local PostgreSQL (managed via the justfile) -------------
            export PGDATA="$PROJECT_ROOT/tmp/postgres/data"
            export PGHOST="$PROJECT_ROOT/tmp/postgres/sockets"
            export PGPORT="5432"
            export PGUSER="skills"

            cat <<'EOF'

  Skills dev shell ready. Tasks are managed with `just` — run `just` for the list.

  First time:   just init     (gems + JS deps + database)
  Develop:      just dev       Test: just test       Lint: just lint

EOF
          '';
        };
      });
    };
}
