
class window.NotesReceivables extends window.BaseTable
  fields: ->
    [
      {
        label: "Name of Debtor",
        name: "debtor_name"
      }, {
        label: "Address of Debtor",
        name: "debtor_address"
      }, {
        label: "Original Balance",
        name: "original_balance",
      }, {
        label: "Current Balance",
        name: "current_balance"
      }, {
        label: 'Payment Amount ( Calculated Annually )',
        name: 'pay_amount',
      }, {
        label: 'How Secured or Endorsed / Type of Collateral',
        name: 'collateral_type',
      }
    ]

  columns: ->
    return [
        {data: "debtor_name"},
        {data: "debtor_address"},
        {data: "original_balance", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "current_balance", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "pay_amount", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "collateral_type"}
    ]

  pre_process: (value) ->
    value.original_balance=to_currency(value.original_balance);
    value.current_balance=to_currency(value.current_balance);
    value.pay_amount=to_currency(value.pay_amount);
    value

  footer_callback: ( row, data, start, end, display ) ->
    api = @api()
    COLNUMBERS = [ 2 ]
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
        'debtor_name'
        'debtor_address'
        'original_balance'
        'current_balance'
        'pay_amount'
      ]
      numeric_fields = [
        'original_balance'
        'current_balance'
        'pay_amount'
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
