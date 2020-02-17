module.exports = {
  globals: {
    server: true
  },
  root: true,
  parser: "babel-eslint",
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: "module",
    ecmaFeatures: {
      legacyDecorators: true
    }
  },
  plugins: ["prettier"],
  extends: [
    "eslint:recommended",
    "plugin:ember/recommended",
    "plugin:prettier/recommended"
  ],
  env: {
    browser: true,
    node: true
  },
  rules: {
    "ember/no-on-calls-in-components": 0,
    "ember/no-observers": 0, // Remove this rule and take care of it asap
    "ember/alias-model-in-controller": 0,
    "ember/use-ember-get-and-set": 0,
    "ember/named-functions-in-promises": 0,
    "ember/new-module-imports": 2,
    "ember/no-global-jquery": 2,
    "ember/require-super-in-init": 2,
    "ember/order-in-components": 0,
    "ember/order-in-controllers": 0,
    "ember/order-in-routes": 0,
    "ember/closure-actions": 0,

    "arrow-body-style": [
      2,
      "as-needed",
      { requireReturnForObjectLiteral: true }
    ],
    "guard-for-in": 2,
    "max-depth": [2, 4],
    "max-len": [2, 120, 4],
    "max-params": [2, 4],
    "max-statements": [0, 10],
    "no-alert": 2,
    "no-array-constructor": 2,
    "no-delete-var": 2,
    "no-unused-vars": [
      "error",
      {
        args: "none"
      }
    ],
    "no-var": "error",
    "object-shorthand": 2,
    "one-var": 0,
    yoda: [2, "never"]
  }
};
