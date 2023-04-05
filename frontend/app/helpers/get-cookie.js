import { helper } from "@ember/component/helper";

export function getCookie() {
  let cookieArray = document.cookie.valueOf().split(";");
  let cookie = cookieArray[cookieArray.length - 1];
  //Return value of cookie
  return cookie.split("=")[1];
}

export default helper(getCookie());
