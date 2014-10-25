# numtel:webcomponent
# MIT License, ben@latenightsketches.com
# test/componentRendered.coffee

Tinytest.add 'window reference created', (test) ->
  test.equal typeof window.testElement, 'function'
  test.equal window.testElement.name, 'test-element'

Tinytest.add 'return value correct', (test) ->
  retval = Template.testElement.registerComponent 'return-test'
  test.equal typeof retval, 'function'
  test.equal retval.name, 'return-test'

Tinytest.add 'h1 is red and contains "someval"', (test) ->
  rendered = document.querySelector 'test-element'
  h1 = rendered.shadowRoot.querySelector 'h1'
  link = rendered.shadowRoot.querySelector 'link'
  # Check attribute forwarding
  test.equal h1.innerHTML, 'someval'
  # Check css option
  test.equal getStyleProperty(h1, 'color'), 'rgb(255, 0, 0)'
  # Check cssLinks option
  test.equal link.href, \
    document.location.origin + document.location.pathname + 'notfound.css'
  test.equal link.rel, 'stylesheet'

Tinytest.addAsync 'counter span text is 1 greater after click', (test, done) ->
  # Check that events and reactivity work
  rendered = document.querySelector 'test-element'
  span = rendered.shadowRoot.querySelector 'span'
  button = rendered.shadowRoot.querySelector 'button'
  origValue = parseInt span.innerHTML, 10
  $(button).trigger 'click'
  Meteor.setTimeout (->
    newValue = parseInt span.innerHTML, 10
    test.equal origValue, newValue - 1
    done()
  ), 10
