module.exports = {
  globals: {
    server: true,
  },
  root: true,
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module'
  },
  extends: [
    'eslint:recommended',
    'plugin:ember/recommended'
  ],
  env: {
    browser: true
  },
  rules: {
    'ember/no-on-calls-in-components': 0,
    'ember/alias-model-in-controller': 0,
    'ember/use-ember-get-and-set': 0,
    'ember/named-functions-in-promises': 0,
    'ember/new-module-imports': 2,
    'ember/no-global-jquery': 2,
    'ember/require-super-in-init': 2,
    'ember/order-in-components': 0,
    'ember/order-in-controllers': 0,
    'ember/order-in-routes': 0,
    'ember/closure-actions': 0,

    'arrow-body-style': [2, 'as-needed', { requireReturnForObjectLiteral: true }],
    'arrow-parens': [2, 'as-needed'],
    'arrow-spacing': [2, { 'before': true, 'after': true }],
    'generator-star-spacing': [
      2,
      {
        'before': false,
        'after': true
      }
    ],
    'guard-for-in': 2,
    'indent': [ 'error', 2 ],
    "keyword-spacing": 2,
    'key-spacing': [
      2,
      {
        'mode': 'minimum',
        'afterColon': true,
        'beforeColon': false
      }
    ],
    'linebreak-style': [
      2,
      'unix'
    ],
    'max-depth': [
      2,
      4
    ],
    'max-len': [
      2,
      120,
      4
    ],
    'max-params': [
      2,
      4
    ],
    'max-statements': [
      0,
      10
    ],
    'no-alert': 2,
    'no-array-constructor': 2,
    'no-delete-var': 2,
    'no-trailing-spaces': 'error',
    'no-unused-vars': ['error', {
      args: 'none'
    }],
    'no-var': 'error',
    'object-curly-spacing': [
      2,
      'always'
    ],
    'object-shorthand': 2,
    'one-var': 0,
    'one-var-declaration-per-line': 2,
    'quote-props': [ 'error', 'consistent-as-needed' ],
    'space-before-blocks': [
      2,
      'always'
    ],
    'space-before-function-paren': [
      2,
      {
        'anonymous': 'never',
        'named': 'never'
      }
    ],
    'space-in-parens': [
      2,
      'never'
    ],
    'yoda': [
      2,
      'never'
    ]
  }
};
