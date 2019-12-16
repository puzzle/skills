import { helper } from "@ember/component/helper";

export function selectedPersonRoleLevel(personRoleLevels, namedArgs) {
  return personRoleLevels[0].filter(l => l.get("level") === namedArgs.level)[0];
}

export default helper(selectedPersonRoleLevel);
