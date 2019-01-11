import Component from '@ember/component';

export default Component.extend({
  actions: {
    setWithTab(saveAction, select, e)
    {
      if (e.keyCode == 9) {
        this.send(saveAction, select.highlighted)
      }
    }
  }
})
