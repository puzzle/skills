import { helper } from '@ember/component/helper';

export function notEq([ firstArg, ...restArgs ]) {
  return restArgs.every(a => a !== firstArg);
}

export default helper(notEq);
