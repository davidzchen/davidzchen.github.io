---
layout: post
title: "Creating a Copy to Clipboard Button with Bootstrap"
date: 2016-01-16 15:30:00
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
        value="/path/to/foo/bar" placeholder="Some path" id="copy-input"
        readonly>
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
        $('#copy-button').trigger(
            'copied',
            ['Copy unsuccessful. Please copy manually using Ctrl-c']);
      }
    } catch (err) {
      $('#copy-button').trigger(
          'copied',
          ['Error copying. Please copy manually using Ctrl-c']);
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


