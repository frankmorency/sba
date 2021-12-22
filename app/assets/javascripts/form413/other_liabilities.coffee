
class window.OtherLiabilities extends window.BaseTable
  fields: ->
    [
      {
        label: "Liability",
        name: "liability"
      }, {
        label: "Amount Owed",
        name: "amount_owed"
      }, {
        label: "Description",
        name: "description"
      }
    ]

  columns: ->
    return [

        {data: "liability"},
        {data: "amount_owed", render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
        {data: "description" }
    ]

  pre_process: (value) ->
    value.amount_owed=to_currency(value.amount_owed);
    value

  pre_submit: (self, e, o, action, unique_id_editor) ->
    if action != 'remove'
      mandatory_fields = [
        'liability'
        'amount_owed'
      ]
      numeric_fields = [
        'amount_owed'
      ]
      $.each mandatory_fields, (i, key) ->
        KeyName = unique_id_editor.field(key)
        # Only validate user input values - different values indicate that
        # the end user has not entered a value
        if !KeyName.isMultiValue()
          if !KeyName.val()
            KeyName.error 'Mandatory field cannot be empty!'
        return
      $.each numeric_fields, (i, key) ->
        KeyName = unique_id_editor.field(key)
        # Only validate user input values - different values indicate that
        # the end user has not entered a value
        if !KeyName.isMultiValue()
          if isNaN(KeyName.val())
            KeyName.error 'Numeric field - Only numbers are allowed!'
        return
      # ... additional validation rules
      # If any error was reported, cancel the submission so it can be corrected
      if self.inError()
        return false
    return

  footer_callback: ( row, data, start, end, display ) ->
    api = @api()
    COLNUMBERS = [ 1 ]
    # Remove the formatting to get integer data for summation
    for COLNUMBER in COLNUMBERS
      # Total over all pages
      if api.column(COLNUMBER).data().length
        total = api.column(COLNUMBER).data().reduce((a, b) ->
          intVal(a) + intVal(b)
        )
      else
        total = 0

      # Total over this page
      if api.column(COLNUMBER).data().length
        pageTotal = api.column(COLNUMBER, page: 'current').data().reduce((a, b) ->
          to_currency(intVal(a)) + to_currency(intVal(b))
        )
      else
        pageTotal = 0

      # Update footer
      $(api.column(COLNUMBER).footer()).html '$' + num_to_fixed_string(pageTotal)
