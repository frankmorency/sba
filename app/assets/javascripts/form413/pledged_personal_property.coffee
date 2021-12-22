
class window.PledgedPersonalProperty extends window.BaseTable
  fields: ->
    [
      {
        label: "Name of Lien Holder",
        name: "lien_holder_name"
      }, {
        label: "Amount of Lien",
        name: "lien_amount"
      }, {
        label: "Terms of Payment",
        name: "pay_terms"
      }
    ]

  columns: ->
    return [

        {data: "lien_holder_name"},
        {data: "lien_amount", render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
        {data: "pay_terms" }
    ]

  pre_process: (value) ->
    value.lien_amount=to_currency(value.lien_amount);
    value

  pre_submit: (self, e, o, action, unique_id_editor) ->
    if action != 'remove'
      mandatory_fields = [
        'lien_holder_name'
        'lien_amount'
        'pay_terms'
      ]
      numeric_fields = [
        'lien_amount'
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
