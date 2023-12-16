---
layout: page
title: IFrame Plugin
---

The iframe plugin provides the functionality to open sidebar & navbar items in a tabbed iframe.

##### Required Markup
To get the iframe 100% working you need the following content-wrapper markup:

```html
<div class="content-wrapper iframe-mode" data-widget="iframe" data-loading-screen="750">
  <div class="nav navbar navbar-expand-lg navbar-white navbar-light border-bottom p-0">
    <a class="nav-link bg-danger" href="#" data-widget="iframe-close">Close</a>
    <ul class="navbar-nav" role="tablist"></ul>
  </div>
  <div class="tab-content">
    <div class="tab-empty">
      <h2 class="display-4">No tab selected!</h2>
    </div>
    <div class="tab-loading">
      <div>
        <h2 class="display-4">Tab is loading <i class="fa fa-sync fa-spin"></i></h2>
      </div>
    </div>
  </div>
</div>
```

###### Markup with Default IFrame Tab
```html
<div class="content-wrapper iframe-mode" data-widget="iframe" data-loading-screen="750">
  <div class="nav navbar navbar-expand navbar-white navbar-light border-bottom p-0">
    <div class="nav-item dropdown">
      <a class="nav-link bg-danger dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Close</a>
      <div class="dropdown-menu mt-0">
        <a class="dropdown-item" href="#" data-widget="iframe-close" data-type="all">Close All</a>
        <a class="dropdown-item" href="#" data-widget="iframe-close" data-type="all-other">Close All Other</a>
      </div>
    </div>
    <a class="nav-link bg-light" href="#" data-widget="iframe-scrollleft"><i class="fas fa-angle-double-left"></i></a>
    <ul class="navbar-nav overflow-hidden" role="tablist"><li class="nav-item active" role="presentation"><a href="#" class="btn-iframe-close" data-widget="iframe-close" data-type="only-this"><i class="fas fa-times"></i></a><a class="nav-link active" data-toggle="row" id="tab-index-html" href="#panel-index-html" role="tab" aria-controls="panel-index-html" aria-selected="true">Dashboard v1</a></li></ul>
    <a class="nav-link bg-light" href="#" data-widget="iframe-scrollright"><i class="fas fa-angle-double-right"></i></a>
    <a class="nav-link bg-light" href="#" data-widget="iframe-fullscreen"><i class="fas fa-expand"></i></a>
  </div>
  <div class="tab-content">
    <div class="tab-empty">
      <h2 class="display-4">No tab selected!</h2>
    </div>
    <div class="tab-loading">
      <div>
        <h2 class="display-4">Tab is loading <i class="fa fa-sync fa-spin"></i></h2>
      </div>
    </div>
    <div class="tab-pane fade" id="panel-index-html" role="tabpanel" aria-labelledby="tab-index-html"><iframe src="./index.html"></iframe></div>
  </div>
</div>
```

##### Usage
This plugin can be activated as a jQuery plugin or using the data api.

###### Data API
{: .text-bold }
Activate the plugin by adding `data-widget="iframe"` to the `.content-wrapper`. If you need to provide onCheck and onUncheck methods, please use the jQuery API.

###### jQuery
{: .text-bold }
The jQuery API provides more customizable options that allows the developer to handle checking and unchecking the todo list checkbox events.
```js
$('.content-wrapper').IFrame({
  onTabClick(item) {
    return item
  },
  onTabChanged(item) {
    return item
  },
  onTabCreated(item) {
    return item
  },
  autoIframeMode: true,
  autoItemActive: true,
  autoShowNewTab: true,
  autoDarkMode: false,
  allowDuplicates: true,
  loadingScreen: 750,
  useNavbarItems: true
})
```


##### Options
{: .mt-4}

|---
| Name | Type | Default | Description
|-|-|-|-
|onTabClick | Function | Anonymous Function | Handle tab click event.
|onTabChanged | Function | Anonymous Function | Handle tab changed event.
|onTabCreated | Function | Anonymous Function | Handle tab created event.
|autoIframeMode | Boolean | true | Whether to automatically add `.iframe-mode` to `body` if page is loaded via iframe.
|autoItemActive | Boolean | true | Whether to automatically set the sidebar menu item active based on the active iframe.
|autoShowNewTab | Boolean | true | Whether to automatically display created tab.
|autoDarkMode | Boolean | false | Whether to automatically enable dark-mode in iframe pages.
|allowDuplicates | Boolean | true | Whether to allow creation of duplicate tab/iframe.
|allowReload | Boolean | true | Whether to allow reload non duplicate tab/iframes.
|loadingScreen | Boolean/Number | true | [Boolean] Whether to enable iframe loading screen; [Number] Set loading screen hide delay.
|useNavbarItems | Boolean | true | Whether to open navbar menu items, instead of open only sidebar menu items.
|---
{: .table .table-bordered .bg-light}


##### Methods
{: .mt-4}

|---
| Method | Description
|-|-
|createTab| Create tab by title, link & uniqueName. Available arguments: title `String`, link `String`, uniqueName `String`, autoOpen `Boolean/Optional`.
|openTabSidebar| Create tab by sidebar menu item. Available arguments: item `String|jQuery Object`, autoOpen `Boolean/Optional`.
|switchTab| Switch tab by iframe tab navbar item. Available arguments: item `String|jQuery Object`.
|removeActiveTab| Remove active iframe tab.
{: .table .table-bordered .bg-light}

Example: `$('.content-wrapper').IFrame('createTab', 'Home', 'index.html, 'index', true)`
