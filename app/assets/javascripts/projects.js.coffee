# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('ready page:change', ->
  codeMirrorSettings =
    lineNumbers: true
    mode: "text/x-coffeescript"
    keyMap: "vim"
    showCursorWhenSelecting: true
    theme: "solarized dark"

  readOnlySettings =
    readOnly: 'nocursor'
  _.extend(readOnlySettings, codeMirrorSettings)

  CodeMirror.commands.save = -> $('form').submit()
  for textarea in $('.codemirror-edit')
    CodeMirror.fromTextArea(textarea, codeMirrorSettings)
  for textarea in $('.codemirror-readonly')
    CodeMirror.fromTextArea(textarea, readOnlySettings)

)
