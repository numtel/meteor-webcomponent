Session.setDefault 'counter', 0

Template.testElementInner.helpers
  counter: -> Session.get 'counter'

Template.testElementInner.events
  'click button': -> Session.set 'counter', Session.get('counter') + 1

Template.testElement.registerElement 'test-element',
  css: 'h1 { color: red; } p { color: blue; }'
  cssLinks: ['notfound.css']

