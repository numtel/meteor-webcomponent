Package.describe({
  name: 'numtel:webcomponent',
  summary: 'Create WebComponents from Templates',
  version: '0.0.1',
  git: 'https://github.com/numtel/meteor-webcomponent.git'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.use([
    'underscore',
    'coffeescript',
    'templating'
  ]);
  api.addFiles([
    'dist/x-tag-components.min.js',
    'lib/registerComponent.coffee'
  ], 'client');
});

Package.onTest(function(api) {
  api.use([
    'tinytest',
    'test-helpers',
    'coffeescript',
    'session',
    'templating',
    'numtel:webcomponent'
  ]);
  api.addFiles([
    'test/mockup/component.html',
    'test/mockup/component.css',
    'test/mockup/component.coffee',
    'test/componentRendered.coffee'
  ], 'client');
});
