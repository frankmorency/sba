
class window.NotesPayable extends window.BaseTable
  fields: ->
    [
      {
        label: "Type",
        name: "type",
        type:  "select",
        options: [
          { label: "Credit Card", value: "Credit Card" },
          { label: "Lien on Vehicle", value: "Lien on Vehicle" },
          { label: "Lien on Personal Property", value: "Lien on Personal Property" },
          { label: "Personal Loan", value: "Personal Loan" },
          { label: "Personal Line of Credit", value: "Personal Line of Credit" },
          { label: "Other", value: "Other" }
        ]
      }, {
        label: "Original Balance",
        name: "original_balance"
      }, {
        label: "Current Balance",
        name: "current_balance",
      }, {
        label: "Payment Amount",
        name: "payment_amount"
      }, {
        label: "How Secured or Endorsed Type of Collateral ",
        name: "collateral_type"
      }, {
        label: "Name of Noteholder",
        name: "noteholder"
      }, {
        label: "Address of Noteholder",
        name: "noteholder_address"
      }
    ]

  columns: ->
    return [
        {data: "type"},
        {data: "original_balance", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "current_balance", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "payment_amount", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
        {data: "collateral_type"},
        {data: "noteholder"},
        {data: "noteholder_address"},

    ]

  pre_process: (value) ->
    value.current_balance=to_currency(value.current_balance);
    value.original_balance=to_currency(value.original_balance);
    value.payment_amount=to_currency(value.payment_amount);
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
        'type'
        'original_balance'
        'current_balance'
        'payment_amount'
        'collateral_type'
        'noteholder'
        'noteholder_address'
      ]
      numeric_fields = [
        'original_balance'
        'current_balance'
        'payment_amount'
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
