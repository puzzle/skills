import Component from '@ember/component';
import $ from 'jquery';

export default Component.extend({
  actions: {
    scrollTo(target) {
      $(target)[0].scrollIntoView({ behavior: 'smooth', block: 'start' });
      return false;
    }
  }
});
