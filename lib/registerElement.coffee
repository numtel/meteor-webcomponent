# numtel:webcomponent
# MIT License, ben@latenightsketches.com
# lib/registerElement.coffee

# Register a Blaze Template as a WebComponent
# @param {string} name - Node name for new element (must include hyphen)
# @param {object} options
# @option {string} css - Rules to apply in Shadow DOM context
# @option {[string]} cssLinks - list of hrefs
Blaze.Template.prototype.registerElement = (name, options) ->
  blazeTemplate = @
  options = _.defaults options || {},
    css: undefined
    cssLinks: []

  # Build styles from options
  styles = ''
  styles += '<style>' + options.css + '</style>' if options.css
  for link in options.cssLinks
    styles += '<link rel="stylesheet" href="' + link + '" />'
  # Blaze Template must be wrapped as jQuery fails to find children
  # directly from the shadowRoot.
  shadowContent = styles + '<div></div>'

  newPrototype = Object.create HTMLElement.prototype
  newPrototype.createdCallback = ->
    shadow = this.createShadowRoot()
    shadow.innerHTML = shadowContent
    @childRoot = shadow.querySelector 'div'
    @blazeData = {}
    @blazeView = Blaze.renderWithData blazeTemplate, @blazeData, @childRoot
  newPrototype.attributeChangedCallback = (name, oldValue, newValue) ->
    @blazeData[name] = newValue
    Blaze.remove @blazeView
    @blazeView = Blaze.renderWithData blazeTemplate, @blazeData, @childRoot

  element = document.registerElement name,
    prototype: newPrototype

  # Create global reference
  nameCamelCase = name.replace /-([a-z])/g, (g) -> g[1].toUpperCase()
  window[nameCamelCase] = element
