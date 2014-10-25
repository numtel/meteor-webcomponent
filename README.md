# numtel:webcomponent

[![Build Status](https://travis-ci.org/numtel/meteor-webcomponent.svg?branch=master)](https://travis-ci.org/numtel/meteor-webcomponent)

Turn any Meteor template into a WebComponent with help from Mozilla's [X-Tag library](http://www.x-tags.org/).

Last decade's iframes can finally be banished in favor of new WebComponents. Full stylesheet and DOM isolation without extra layers is native in some browsers already. The X-Tag library brings WebComponent support to all modern browsers (IE 9+). [Learn more about WebComponents...](http://webcomponents.org/)

The included X-Tags distribution also adds the [HTML imports polyfill](https://github.com/pennyfx/htmlimports-polyfill).

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

```html
<template name="example">
  <!-- Insert value from attribute -->
  <h1>{{myVal}}</h1>

  <p>This will be blue.</p>

  <!-- Forward child DOM -->
  <content></content>
</template>
```

```javascript
Template.example.registerComponent('advanced-example', {
  attributes: ['myVal'],
  css: 'h1 { color: red; } p { color: blue; }'
});
```

Instance:

```html
<advanced-example myVal="Something in the way">
  <p>This will not be blue because it has been forwarded.</p>
</advanced-example>
```

## Notes

* Styles may also be applied from document sheets using the `::shadow` psuedo-class.

## License

MIT
