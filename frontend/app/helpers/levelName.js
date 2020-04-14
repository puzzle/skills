import { helper } from "@ember/component/helper";

function levelName([num]) {
  const levelNames = [
    "Nicht bewertet",
    "Trainee",
    "Junior",
    "Professional",
    "Senior",
    "Expert"
  ];
  return levelNames[num];
}

export default helper(levelName);
