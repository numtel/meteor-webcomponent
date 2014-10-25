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

  # Generate accessors for each attribute
  accessors = {}
  _.each options.attributes, (attr) ->
    accessors[attr] =
      attribute: {}
      get: -> @getAttribute attr
      set: (value) -> @xtag.data[attr] = value

  component = xtag.register name,
    lifecycle:
      created: ->
        self = @
        self.shadowRoot = self.createShadowRoot()
        styles = ''
        styles += '<style>' + options.css + '</style>' if options.css
        for link in options.cssLinks
          styles += '<link rel="stylesheet" href="' + link + '" />' 

        self.shadowRoot.innerHTML = styles + '<div></div>'
        self.blazeRoot = self.shadowRoot.querySelector('div')
        self.blazeView = Blaze.render blazeTemplate, self.blazeRoot
      attributeChanged: ->
        # hmmm
    accessors: accessors

  # Create global reference
  nameCamelCase = name.replace /-([a-z])/g, (g) -> g[1].toUpperCase()
  window[nameCamelCase] = component
