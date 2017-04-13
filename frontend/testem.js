/* eslint-env node */
module.exports = {
  "test_page": "tests/index.html?hidepassed",
  "disable_watching": true,
  "browser_args": {
    "Firefox": [
      "--no-remote",
    ]
  },
  "launch_in_ci": [
    "Firefox"
  ],
  "launch_in_dev": [
    "PhantomJS",
    "Chrome"
  ]
};
