import Ember from 'ember';

export default Ember.Service.extend({
  session: Ember.inject.service(),

  file(url) {
    let xhr = new XMLHttpRequest;
    xhr.responseType = 'blob';
    xhr.onload = () => {
      let [ , fileName ] = /filename="(.*?)"/.exec(xhr.getResponseHeader('Content-Disposition'));
      let file = new File([ xhr.response ], fileName);
      let link = document.createElement('a');
      link.style.display = 'none';
      link.href = URL.createObjectURL(file);
      link.download = file.name;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    };
    xhr.open('GET', url);
    xhr.setRequestHeader('api-token', this.get('session.data.authenticated.token'));
    xhr.setRequestHeader('ldap-uid', this.get('session.data.authenticated.ldap_uid'));
    xhr.send();
  }
});
