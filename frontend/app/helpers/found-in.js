import { helper } from "@ember/component/helper";

export function foundIn(params) {
  const foundIn = params[0];
  const t = "person.";
  if (foundIn.includes("#")) {
    return t + foundIn.split("#")[0];
  }
  return t + foundIn;
}

export default helper(foundIn);
