/* eslint-env node */
module.exports = {
  test_page: 'tests/index.html?hidepassed',
  disable_watching: true,
  launch_in_ci: [
    'Firefox'
  ],
  launch_in_dev: [
    'Chrome'
  ],
  browser_args: {
    Firefox: [
      '--no-remote',
      '--headless'
    ],
    Chrome: [
      //'--disable-gpu',
      //'--headless',
      '--remote-debugging-port=9222',
      '--window-size=1440,900'
    ]
  },
  proxies: {
    '/api': {
      target: 'http://localhost:' + (process.env.RAILS_PORT || '3000')
    }
  }
};
