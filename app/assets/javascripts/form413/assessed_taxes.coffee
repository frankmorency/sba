
class window.AssessedTaxes extends window.BaseTable
  fields: ->
    [
      {
        label: "Whom Payable",
        name: "whom_payable"
      }, {
        label: "Amount",
        name: "amount"
      }, {
        label: "When Due",
        name: "when_due",
        type:  'datetime',
        format: 'MM/DD/YYYY',
        def: ->
          d = new Date
          return getFormattedDate(d);
      }, {
        label: "Property (if any) a tax lien attaches",
        name: "property_tax_lien"
      }
    ]

  columns: ->
    return [
        {data: "whom_payable"},
        {data: "amount", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "when_due", render: $.fn.dataTable.render.moment( 'MM/DD/YYYY' )},
        {data: "property_tax_lien"}
    ]

  pre_process: (value) ->
    value.amount=to_currency(value.amount);
    value

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

  pre_submit: (self, e, o, action, unique_id_editor) ->
    if action != 'remove'
      mandatory_fields = [
        'whom_payable'
        'amount'
        'when_due'
        'property_tax_lien'
      ]
      numeric_fields = [
        'amount'
      ]
      date_fields = [
        'when_due'
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
      $.each date_fields, (i, key) ->
        KeyName = unique_id_editor.field(key)
        # Only validate user input values - different values indicate that
        # the end user has not entered a value
        if !KeyName.isMultiValue()
          if !isValidDate(KeyName.val())
            KeyName.error 'Date field - Please enter in mm/dd/yyyy format'
        return
      # ... additional validation rules
      # If any error was reported, cancel the submission so it can be corrected
      if self.inError()
        return false
    return
