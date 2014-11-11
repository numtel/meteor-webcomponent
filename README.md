# numtel:webcomponent

Turn any Meteor template into a new element on all modern browsers with help from Polymer's [webcomponents.js polyfill library](https://github.com/Polymer/webcomponentsjs)

Last decade's iframes can finally be banished in favor of new WebComponents. Full stylesheet and DOM isolation without extra layers is native in some browsers already (Chrome, Firefox 34). The Polymer library brings WebComponent support to all modern browsers (IE 9+). [Learn more about WebComponents...](http://webcomponents.org/)

### Why use WebComponents when Meteor already has Spacebars?

Spacebars already provides some of the features of WebComponents: attributes, child DOM.
Beyond these features, a WebComponent provides CSS and DOM isolation in what is called a Shadow DOM.
DOM isolation means that `querySelector()` or jQuery will not be able to directly find the elements.
CSS isolation means that a rules on your page will not effect an element in your WebComponent's Shadow DOM (or vice-versa).

Polymer's webcomponents.js library includes polyfills for all features except shadow DOM CSS isolation. To make up for this shortcoming, I have been working on a [shadow DOM CSS isolation polyfill](https://github.com/numtel/shadowstyles).

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

This widget can be converted in to a WebComponent using its `registerElement` method:

```javascript

// ...Default event handlers...

Template.hello.registerElement('hello-counter');
```

Then insert the new element anywhere in your application:

```html
<hello-counter></hello-counter>
```

## Implements

#### Template.prototype.registerElement(name, options)

`name` *String* - The name of the new element type to be created. Must include a hyphen. A reference to the element constructor will be added to `window` on the camel-cased version of this name.

`options` *Object* - Optionally, specify the following options:

Key      | Type     | Description
---------|----------|--------------------------
`css`       |`string`   | Rules to add in a `<style>` tag
`cssLinks`  |`[string]` | Array of HREFs to create `<link>` tags

**Returns:** Element constructor

## Advanced Usage

Template:

HTML:
```html
<template name="example">
  <!-- Insert value from attribute -->
  <h1>{{myval}}</h1>
  <button>Click Me</button>

  <p class="answer">This will be blue.</p>

  <!-- Forward child DOM -->
  <content></content>
</template>
```

Javascript:
```javascript
Template.example.registerElement('advanced-example', {
  css: 'h1 { color: red; } p { color: blue; }'
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
<advanced-example myval="Something in the way">
  <p>This will not be blue because it has been forwarded. (In Chrome anyways)</p>
</advanced-example>
```

Element attributes will be added to an object accessible as the template's context.
Attributes names must be lowercase. The template will be rerendered when an attribute changes.

## Compatibility Notes

For browsers that support Shadow DOM:

* Styles may be applied from document sheets using the `::shadow` pseudo-class.
* When using CSS embedded in a component, the `:host` pseudo-class matches the root element. By default, WebComponents are `display: inline`. Pass the following in the `css` option to change that:

    ```css
    :host { display: block; }
    ```

## Running tests

Tests may be ran like any other Meteor package:

```bash
# From repository directory (named numtel:webcomponent)
$ meteor test-packages ./
```

Travis CI badge has been removed as PhantomJS <2.0 (1.9.7 is latest stable installed on Travis) does not support MutationObservers or the polyfill to bring support to other browsers. If concerned, please run the tests locally. (They work for me in IE9/10, FF33, and Chrome. Soon, I may set up SauceLabs so that the tests can run in a normal browser with Travis.)

## License

MIT
