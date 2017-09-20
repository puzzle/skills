export default function() {

  // this.urlPrefix = '';    // make this `http://localhost:8080`, for example, if your API is on a different server
  this.namespace = '/api';
  // this.timing = 400;      // delay for each request, automatically set to 0 during testing

  this.get('/people');
  this.get('/people/:id');
  this.post('/people');
  this.patch('/people/:id');

  /*
    Shorthand cheatsheet:
    http://www.ember-cli-mirage.com/docs/v0.3.x/shorthands/
    this.get('/posts');
    this.post('/posts');
    this.get('/posts/:id');
    this.put('/posts/:id'); // or this.patch
    this.del('/posts/:id');

    http://www.ember-cli-mirage.com/docs/v0.2.x/shorthands/
  */
}
