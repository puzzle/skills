import Ember from 'ember';

const { Component, inject } = Ember;

const ObjectPromiseProxy = Ember.ObjectProxy.extend(Ember.PromiseProxyMixin);

export default Component.extend({
  ajax: inject.service(),

  uploadImage(file) {
    let formData = new FormData();

    formData.append('picture', file);

    let res = this.get('ajax').put(this.get('uploadPath'), {
      contentType: false,
      processData: false,
      data: formData
    });

    this.set('picturePath', URL.createObjectURL(file));

    res.then(res => this.set('picturePath', res.data.picture_path));

    this.set('response', ObjectPromiseProxy.create({ promise: res }))
      .then(() => this.get('notify').success('Profilbild wurde aktualisiert!'));
  },
  didInsertElement() {
    this.$('.img-input').on('change', e => {
      if(e.target.files.length){
        this.uploadImage(e.target.files[0]);
        e.target.value = null;
      }
    });
  },
  actions: {
    changePicture: function(){
      this.$('.img-input').click();
    }
  }
});
