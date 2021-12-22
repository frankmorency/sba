
class window.BaseTable
  constructor: () ->
  to_html: (@data) ->
    return ""
  fields: ->
    return ""
  columns: ->
    return ""
  pre_process: (value) ->
    return ""
  footer_callback: ( row, data, start, end, display ) ->
    return true

