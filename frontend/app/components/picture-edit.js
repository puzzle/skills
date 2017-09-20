import Ember from 'ember';

const { Component, inject } = Ember;

const ObjectPromiseProxy = Ember.ObjectProxy.extend(Ember.PromiseProxyMixin);

export default Component.extend({
  ajax: inject.service(),

  uploadImage(file) {
    let formData = new FormData();

    if (!file.name.match(/.(jpg|jpeg|png|gif|svg|bmp)$/i)) {
      this.get('notify').alert('Invalider Datentyp');
      return
    }

    if (file.size > 10000000) { //10MB
      this.get('notify').alert('Datei ist zu gross, max 10MB');
      return
    }

    formData.append('picture', file);

    let res = this.get('ajax').put(this.get('uploadPath'), {
      contentType: false,
      processData: false,
      timeout: 5000,
      data: formData
    });

    let oldPicture = this.get('picturePath');
    this.set('picturePath', URL.createObjectURL(file));

    res
      .then(res =>
        this.set('picturePath', `${res.data.picture_path}?${Date.now()}`)
      )
      .then(() =>
        this.get('notify').success('Profilbild wurde aktualisiert!')
      )
      .catch(err => {
        this.get('notify').error(err.message)
        this.set('picturePath', oldPicture)
      });

    this.set('response', ObjectPromiseProxy.create({ promise: res }))
  },
  didInsertElement() {
    this.$('.img-input').on('change', e => {
      if (e.target.files.length) {
        this.uploadImage(e.target.files[0]);
        e.target.value = null;
      }
    });
  },
  actions: {
    changePicture() {
      this.$('.img-input').click();
    }
  }
});
