# Register a Blaze Template as a WebComponent using X-Tags
# @param {string} name - Node name for new element (must include hyphen)
# @param {object} options
# @option {[string]} attributes - list to forward to template data
Blaze.Template.prototype.registerComponent = (name, options) ->
  blazeTemplate = @
  options = _.defaults options || {},
    attributes: []

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
        self.blazeView = Blaze.render blazeTemplate, self.shadowRoot

        # Translate Blaze events
        _.each blazeTemplate.__eventMaps, (eventMap) ->
          _.each eventMap, (handler, blazeKey) ->
            boundHandler = (event) ->
              self = @
              handler.call self.blazeView, event
            blazeKey.split(',').forEach (eventKey) ->
              eventSpacePos = eventKey.indexOf(' ')
              if eventSpacePos == -1
                # Event is on the root element
                eventType = eventKey
                self.addEventListener eventType, boundHandler, false
              else
                # Event is bound to a child
                eventType = eventKey.substr 0, eventSpacePos
                eventTarget = eventKey.substr(eventSpacePos).trim()
                _.each self.shadowRoot.querySelectorAll(eventTarget), (target) ->
                  target.blazeView = self.blazeView
                  target.addEventListener eventType, boundHandler, false
      attributeChanged: ->
        # hmmm
    accessors: accessors

  # Create global reference
  nameCamelCase = name.replace /-([a-z])/g, (g) -> g[1].toUpperCase()
  window[nameCamelCase] = component
