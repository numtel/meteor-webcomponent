Package.describe({
  name: 'numtel:webcomponent',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.use([
    'underscore',
    'coffeescript',
    'templating'
  ]);
  api.addFiles([
    'dep/x-tag-components.js',
    'lib/registerComponent.coffee'
  ], 'client');
});

Package.onTest(function(api) {
  api.use([
    'tinytest',
    'coffeescript',
    'numtel:webcomponent'
  ]);
  api.addFiles([
    'test/registerComponent.coffee'
  ], 'client');
});
