import EmberRouter from '@embroider/router';
import config from 'ember-learning/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('login');
  this.route('dashboard');
  this.route('products', function () {
    this.route('product', { path: '/:product_id' });
  });
});
