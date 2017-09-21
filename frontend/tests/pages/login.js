import {
  create,
  visitable,
  fillable,
  clickable,
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/login'),

  async login(username, password) {
    await this.loginForm.username(username);
    await this.loginForm.password(password);

    return this.loginForm.submit();
  },

  loginForm: {
    scope: '.form-login',

    username: fillable('.login-form-user > input'),
    password: fillable('.login-form-password > input[type="password"]'),

    submit: clickable('.btn-primary'),
  },
})
