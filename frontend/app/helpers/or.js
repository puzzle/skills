import { helper } from "@ember/component/helper";

export function or(params) {
  return params.find(Boolean);
}

export default helper(or);
