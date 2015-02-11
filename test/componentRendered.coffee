# numtel:webcomponent
# MIT License, ben@latenightsketches.com
# test/componentRendered.coffee

Tinytest.add 'window reference created', (test) ->
  test.equal typeof window.testElement, 'function'

Tinytest.add 'return value correct', (test) ->
  retval = Template.testElement.registerElement 'return-test'
  test.equal typeof retval, 'function'

Tinytest.add 'h1 is red and contains "someval"', (test) ->
  rendered = document.querySelector 'test-element'
  h1 = rendered.shadowRoot.querySelector 'h1'
  style = rendered.shadowRoot.querySelector 'style'
  # Check attribute forwarding
  test.equal h1.innerHTML, 'someval'
  # Check css option
  test.include ['rgb(255, 0, 0)', 'red'], getStyleProperty(h1, 'color')
  # Check cssLinks option
  test.matches style.innerText, \
    /^(@import url\("notfound.css"\);)/

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
