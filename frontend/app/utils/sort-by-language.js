import { computed, get } from "@ember/object";
import config from "../config/environment";

export default function sortByLanguage(property) {
  return computed(`${property}.@each.{language}`, function() {
    let collection = get(this, property);

    const obligatoryLanguages = ["DE", "EN", "FR"];
    if (!collection) return [];
    if (!collection.promise && config.environment !== "test") return [];

    let newCollection = collection.toArray().sort((a, b) => {
      const aLanguage = get(a, "language");
      const bLanguage = get(b, "language");
      if (aLanguage == "-") return 1;
      if (bLanguage == "-") return -1;
      const aIsObligatory = obligatoryLanguages.includes(aLanguage);
      const bIsObligatory = obligatoryLanguages.includes(bLanguage);

      if (aIsObligatory && !bIsObligatory) return -1;
      if (!aIsObligatory && bIsObligatory) return 1;
      if (aIsObligatory && bIsObligatory) {
        return (
          obligatoryLanguages.indexOf(aLanguage) -
          obligatoryLanguages.indexOf(bLanguage)
        );
      }
      if (aLanguage < bLanguage) return -1;
      if (aLanguage > bLanguage) return 1;
      return 0;
    });
    return newCollection;
  });
}
