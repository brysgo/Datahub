# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('page:change', ->
  codeMirrorSettings =
    lineNumbers: true
    mode: "text/x-coffeescript"
    keyMap: "vim"
    showCursorWhenSelecting: true
    theme: "solarized dark"

  CodeMirror.fromTextArea($('#project_logic_code')[0], codeMirrorSettings)
  CodeMirror.fromTextArea($('#project_display_code')[0], codeMirrorSettings)
)
