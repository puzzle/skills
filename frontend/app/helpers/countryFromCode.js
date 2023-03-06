import { helper } from "@ember/component/helper";
import { isBlank } from "@ember/utils";
import { getNames as countryNames } from "ember-i18n-iso-countries";

export function countryFromCode([code] /*, hash*/) {
  if (isBlank(code)) return "";
  const countries = Object.entries(countryNames("de"));
  return countries.find(function(country) {
    return country[0] === code;
  });
}

export default helper(countryFromCode);
