import { helper } from '@ember/component/helper';

export function eq([ firstArg, ...restArgs ]) {
  return restArgs.every(a => a === firstArg);
}

export default helper(eq);
