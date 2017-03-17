module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 6,
    sourceType: 'module'
  },
  extends: 'eslint:recommended',
  env: {
    browser: true
  },
  rules: {
    'indent': ['error', 2],
    'no-trailing-spaces': 'error',
    'no-unused-vars': ['error', {
      args: 'none'
    }]
  }
};
