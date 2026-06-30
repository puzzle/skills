import { execSync } from "child_process"

if (process.env.RAILS_ENV === "production") {
    execSync("yarn build:css:prod", { stdio: 'inherit' })
} else {
    execSync("yarn build:css:dev", { stdio: 'inherit' })
}

execSync("yarn build:css:prefix", { stdio: 'inherit' })