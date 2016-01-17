---
layout: post
title: "Creating a Copy to Clipboard Button with Bootstrap"
date: 2016-01-19 01:30:00
categories:
  - tech
---

The other day, I was trying to implement a UI widget consisting of a text box
containing some text and a button that would automatically copy the contents of
the text box into the clipboard, not unlike the ones on GitHub repository pages
or, similarly, the code listings on the [Bootstrap
documentation][bootstrap-docs].

[bootstrap-docs]: http://getbootstrap.com/

In particular, I wanted the behavior of the button to be the same:

1. When hovering over the button, display a tooltip with the message "Copy to
   Clipboard"
2. When the button is clicked and the text is copied,, the message on the
   tooltip changes to "Copied!"

Creating the textbox itself is easy: simply create a Bootstrap input group
consisteing of a text input and a [button addon][button-addon] with a
[tooltip][tooltip]:

[button-addon]: http://getbootstrap.com/components/#input-groups-buttons
[tooltip]: http://getbootstrap.com/javascript/#tooltips

```html
<form>
  <div class="input-group">
    <input type="text" class="form-control"
        value="/path/to/foo/bar" placeholder="Some path" id="copy-input">
    <span class="input-group-btn">
      <button class="btn btn-default" type="button" id="copy-button"
          data-toggle="tooltip" data-placement="button"
          title="Copy to Clipboard">
        Copy
      </button>
    </span>
  </div>
</form>
```

The more involved part is the Javascript that wires everything together.
Specifically, we want to do the following:

* When we hover over the copy button, display the tooltip with the original
  "Copy to Clipboard" message.
* When we click the copy button, copy the contents of the text input into the
  clipboard.
* Once the contents of the text input are copied, change the tooltip message to
  "Copied!"
* If we mouse over the button again, the tooltip again displays the original
  "Copy to Clipboard" message.

First, we need to initialize the tooltip according to Bootstrap's documentation:

```javascript
$('#copy-button').tooltip();
```

That was easy. Next, we need to add a handler for the Copy button that would
copy the contents of the text box into the clipboard. One way we can do this
without using a third-party library is to first use the [Selection
API][selection-api] to select the text inside the text box and then execute the
copy command using [`Document.execCommand()`][execcommand] to copy it to the
clipboard. For a detailed explanation, see [this documentation][copy-command].

[execcommand]: https://developer.mozilla.org/en-US/docs/Web/API/Document/execCommand
[selection-api]: https://developer.mozilla.org/en-US/docs/Web/API/Selection
[copy-command]: https://developers.google.com/web/updates/2015/04/cut-and-copy-commands?hl=en

```javascript
$('#copy-button').bind('click', function() {
  var input = document.querySelector('#copy-input');
  input.setSelectionRange(0, input.value.length + 1);
  try {
    var success = document.execCommand('copy');
    if (success) {
      // Change tooltip message to "Copied!"
    } else {
      // Handle error. Perhaps change tooltip message to tell user to use Ctrl-c
      // instead.
    }
  } catch (err) {
    // Handle error. Perhaps change tooltip message to tell user to use Ctrl-c
    // instead.
  }
});
```

Once the text is copied, we also want to update the tooltip message. To do this,
we can trigger a custom `copied` event to update the tooltip. Let's we add a
handler to `#copy-button` to handle a custom event, `copied`, that contains the
message to display on the tooltip.

```javascript
$('#copy-button').bind('copied', function(event, message) {
  $(this).attr('title', message)
      .tooltip('fixTitle')
      .tooltip('show')
      .attr('title', "Copy to Clipboard")
      .tooltip('fixTitle');
});
```

Finally, we update the click handler for `#copy-button` to trigger `copied`
events to update the tooltip message. Putting everything together, we have the
following:

```javascript
$(document).ready(function() {
  // Initialize the tooltip.
  $('#copy-button').tooltip();

  // When the copy button is clicked, select the value of the text box, attempt
  // to execute the copy command, and trigger event to update tooltip message
  // to indicate whether the text was successfully copied.
  $('#copy-button').bind('click', function() {
    var input = document.querySelector('#copy-input');
    input.setSelectionRange(0, input.value.length + 1);
    try {
      var success = document.execCommand('copy');
      if (success) {
        $('#copy-button').trigger('copied', ['Copied!']);
      } else {
        $('#copy-button').trigger('copied', ['Copy with Ctrl-c']);
      }
    } catch (err) {
      $('#copy-button').trigger('copied', ['Copy with Ctrl-c']);
    }
  });

  // Handler for updating the tooltip message.
  $('#copy-button').bind('copied', function(event, message) {
    $(this).attr('title', message)
        .tooltip('fixTitle')
        .tooltip('show')
        .attr('title', "Copy to Clipboard")
        .tooltip('fixTitle');
  });
});
```

Here is a live demo of this copy-to-clipboard widget in action:

<iframe src="/example/bootstrap-clipboard.html"
    class="example"
    width="847" height="125"
    frameborder="0"
    marginwidth="0"
    marginheight="0"
    scrolling="no">
</iframe>

The main downside of this approach is that the copy command is [not supported in
Safari][copy-browser-support]. One way to mitigate this is to use
[`queryCommandSupported` and `queryCommandEnabled`][querycommandsupported] to
check whether the command is supported and fall back gracefully display a
"Copy with Ctrl-c" message on the tooltip instead. In essence, this how the
[Clipboard.js][clipboardjs] library works, except wrapped up in a much more
polished API.

[copy-browser-support]: https://developers.google.com/web/updates/2015/04/cut-and-copy-commands?hl=en#browser-support
[querycommandsupported]: https://developers.google.com/web/updates/2015/04/cut-and-copy-commands?hl=en#querycommandsupported-and-querycommandenabled
[clipboardjs]: https://clipboardjs.com

Unfortunately, until the new [HTML 5 Cipboard API][html5-clipboard] is finalized
and adopted by all major browsers, the only cross-browser way to reliably copy
to clipboard is using Flash. This is the approach taken by libraries such as
[ZeroClipboard][zeroclipboard], which is, in fact, the library [used by
GitHub][github-zeroclipboard] as well as the [Bootstrap
documentation][bootstrap-clipboard]. Hopefully, once the HTML 5 Clipboard API is
available, adding such a simple feature will become much less of a hassle.

[html5-clipboard]: https://www.w3.org/TR/clipboard-apis/
[zeroclipboard]: http://zeroclipboard.org/
[github-zeroclipboard]: http://techcrunch.com/2013/01/02/github-replaces-copy-and-paste-with-zeroclipboard/
[bootstrap-clipboard]: https://github.com/twbs/bootstrap/blob/cf3f8e0d580888ec9459270ed67dc86c13f5b41a/docs/assets/js/src/application.js#L143
