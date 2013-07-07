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
  for textarea in $('.codemirror')
    settings = _.clone(codeMirrorSettings)
    settings.readOnly = 'nocursor' if $(textarea).hasClass('readonly')
    settings.mode = "text/x-coffeescript" if $(textarea).hasClass('coffeescript')
    settings.mode = "text/html" if $(textarea).hasClass('html')
    _.extend(readOnlySettings, codeMirrorSettings)
    CodeMirror.fromTextArea(textarea, settings)

)
