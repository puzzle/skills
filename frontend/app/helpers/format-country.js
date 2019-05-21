import { helper } from "@ember/component/helper";
import { isBlank } from "@ember/utils";
import { getNames as countryNames } from "ember-i18n-iso-countries";

export function formatCountry(params /*, hash*/) {
  const countryCode = params[0];
  if (isBlank(countryCode)) return "";
  const countries = Object.entries(countryNames("de"));
  const country = countries.find(function(country) {
    return country[0] === countryCode;
  });
  return country[1];
}

export default helper(formatCountry);
