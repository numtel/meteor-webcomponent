# numtel:webcomponent

[![Build Status](https://travis-ci.org/numtel/meteor-webcomponent.svg?branch=master)](https://travis-ci.org/numtel/meteor-webcomponent)

Turn any Meteor template into a WebComponent with help from Mozilla's [X-Tag library](http://www.x-tags.org/).

Last decade's iframes can finally be banished in favor of new WebComponents. Full stylesheet and DOM isolation without extra layers is native in some browsers already. The X-Tag library brings WebComponent support to all modern browsers (IE 9+). [Learn more about WebComponents...](http://webcomponents.org/)

The included X-Tags distribution also adds the [HTML imports polyfill](https://github.com/pennyfx/htmlimports-polyfill).

### Why use WebComponents when Meteor already has Spacebars?

Spacebars already provides some of the features of WebComponents: attributes, child DOM.
Beyond these features, a WebComponent provides CSS and DOM isolation in what is called a Shadow DOM.
CSS isolation means that a rules on your page will not effect an element in your WebComponent's Shadow DOM (or vice-versa).
DOM isolation means that `querySelector()` or jQuery will not be able to directly find the elements either.

Sadly, X-Tags does not polyfill the Shadow DOM features.
In browsers that do not provide Shadow DOM suport natively, the child DOM will be appended normally. See the 'Advanced Usage' section below for ways to work around these issues.

## Installation

```bash
$ meteor add numtel:webcomponent
```

## Hello, World

Imagine the familiar template:

```html
<template name="hello">
  <button>Click Me</button>
  <p>You've pressed the button {{counter}} times.</p>
</template>
```

This widget can be converted in to a WebComponent using its `registerComponent` method:

```javascript

// ...Default event handlers...

Template.hello.registerComponent('hello-counter');
```

Then insert the new element anywhere in your application:

```html
<hello-counter></hello-counter>
```

## Implements

#### Template.prototype.registerComponent(name, options)

`name` *String* - The name of the new element type to be created. Must include a hyphen. A reference to the element constructor will be added to `window` on the camel-cased version of this name.

`options` *Object* - Optionally, specify the following options:

Key      | Type     | Description
---------|----------|--------------------------
`attributes`|`[string]` | Array of element attributes to forward to template data
`css`       |`string`   | Rules to add in a `<style>` tag
`cssLinks`  |`[string]` | Array of HREFs to create `<link>` tags

**Returns:** Element constructor

## Advanced Usage

Template:

HTML:
```html
<template name="example">
  <!-- Insert value from attribute -->
  <h1>{{myVal}}</h1>
  <button>Click Me</button>

  <p class="answer">This will be blue.</p>

  <!-- Forward child DOM -->
  <content></content>
</template>
```

Javascript:
```javascript
Template.example.registerComponent('advanced-example', {
  attributes: ['myVal'],
  css: 'h1 { color: red; } p { color: blue; }'
});

Template.example.events({
  'click button': function(event) {
    // Find other elements inside child DOM (shadow or not)
    this.childRoot.querySelector('p.answer').innerHTML = 'Clicked';
  }
});
```

LESS:
```less
// Styles for non-native browsers
.componentMixin(~'>div');
// Styles for browsers with ShadowRoot native
.componentMixin(~'::shadow');

.componentMixin(@suffix) {
  advanced-example@{suffix} {
    .some-rule {
      color: blue;
    }
  }
}
```

Instance:

```html
<advanced-example myVal="Something in the way">
  <p>This will not be blue because it has been forwarded. (In Chrome anyways)</p>
</advanced-example>
```

The data context for the template rendered inside a WebComponent is the element instance. Although only `{{myVal}}` is displayed in the example, the entire element instance object is applied as the template's data. Forwarded element attributes are available to be inserted in this way because they are properties on the element instance object.

## Compatibility Notes

For browsers that support Shadow DOM:

* Styles may be applied from document sheets using the `::shadow` pseudo-class.
* When using CSS embedded in a component, the `:host` pseudo-class matches the root element. By default, WebComponents are `display: inline`. Pass the following in the `css` option to change that:

    ```css
    :host { display: block; }
    ```

## License

MIT
