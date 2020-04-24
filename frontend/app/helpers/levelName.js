import { helper } from "@ember/component/helper";
import PeopleSkill from "../models/people-skill";

function levelName([num]) {
  const levelNames = PeopleSkill.LEVEL_NAMES;
  return levelNames[num];
}

export default helper(levelName);
