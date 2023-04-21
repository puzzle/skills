import { helper } from "@ember/component/helper";

export function getCookie() {
  let cookieArray = document.cookie.valueOf().split(";");
  let searchQuery = cookieArray.find(str => str.includes("cv_search_query="));

  if (searchQuery === undefined) return;

  let cookie = searchQuery.split("=")[1];

  return cookie;
}

export default helper(getCookie());
