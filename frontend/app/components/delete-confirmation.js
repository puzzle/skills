import Component from '@ember/component';

export default Component.extend({

  actions: {

    delete(object) {
      //remove overlay from delete confirmation
      $('.modal-backdrop').remove();
      object.destroyRecord();
    },
  }
});
