Blaze.Template.prototype.registerComponent = (name, options) ->
  blazeTemplate = @
  options = _.defaults options || {},
    attributes: {}

  # Generate accessors for each attribute
  accessors = {}
  _.each options.attributes, (attr) ->
    accessors[attr] =
      attribute: {}
      get: -> @getAttribute attr
      set: (value) -> @xtag.data[attr] = value

  xtag.register name,
    lifecycle:
      created: ->
        @shadowRoot = @createShadowRoot()
        @loadTemplate()
      attributeChanged: ->
        # hmmm
    accessors: accessors
    methods:
      loadTemplate: ->
        @shadowRoot.innerHTML = ''
        delete @blazeView if @blazeView
        @blazeView = Blaze.render blazeTemplate, @shadowRoot
