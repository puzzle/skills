import { helper } from '@ember/component/helper';

export function toLowercase(params) {
  return params[0].toLowerCase();
}

export default helper(toLowercase);
