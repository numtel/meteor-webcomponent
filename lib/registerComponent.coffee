# numtel:webcomponent
# MIT License, ben@latenightsketches.com
# lib/registerComponent.coffee

# Register a Blaze Template as a WebComponent using X-Tags
# @param {string} name - Node name for new element (must include hyphen)
# @param {object} options
# @option {[string]} attributes - list to forward to template data
# @option {string} css - Rules to apply in Shadow DOM context
# @option {[string]} cssLinks - list of hrefs
Blaze.Template.prototype.registerComponent = (name, options) ->
  blazeTemplate = @
  options = _.defaults options || {},
    attributes: []
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

  # Generate accessors for each attribute
  accessors = {}
  _.each options.attributes, (attr) ->
    accessors[attr] =
      attribute: {}
      get: -> @getAttribute attr
      set: (value) -> @xtag.data[attr] = value

  # Build element
  element = xtag.register name,
    lifecycle:
      created: ->
        self = @
        self.shadowRoot = self.createShadowRoot()
        self.shadowRoot.innerHTML = shadowContent
        self.blazeRoot = self.shadowRoot.querySelector('div')
      inserted: ->
        self = @
        self.blazeView = Blaze.renderWithData blazeTemplate, self, self.blazeRoot
    accessors: accessors

  # Create global reference
  nameCamelCase = name.replace /-([a-z])/g, (g) -> g[1].toUpperCase()
  window[nameCamelCase] = element
