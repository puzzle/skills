module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module'
  },
  extends: 'eslint:recommended',
  env: {
    browser: true
  },
  rules: {
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
