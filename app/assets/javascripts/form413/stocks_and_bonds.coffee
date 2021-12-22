

class window.StocksAndBonds extends window.BaseTable
  fields: ->
    [
      {
        label: "Type",
        name: "type",
        type:  "select",
        options: [
          { label: "Stocks", value: "Stocks" },
          { label: "Bonds", value: "Bonds" },
          { label: "Mutual Funds", value: "Mutual Funds" },
          { label: "Other", value: "Other" }
        ]
      }, {
        label: "Name Of Securities",
        name: "securities_name"
      }, {
        label: "Total Value",
        name: "total_value",
      }, {
        label: "Number of Shares",
        name: "num_of_shares"
      }, {
        label: "Cost",
        name: "cost"
      },{
        label: "Market Value Quotation/ Exchange",
        name: "market_value"
      },{
        label: "Date of Quotation/ Exchange",
        name: "date",
        type:  'datetime',
        format: 'MM/DD/YYYY',
        def: ->
          d = new Date
          return getFormattedDate(d);
      },{
        label: 'Interest & Dividends Received',
        name: 'interest_dividends'
      }
    ]

  columns: ->
    return [
      {data: "type"},
      {data: "securities_name"},
      {data: "total_value", render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
      {data: "num_of_shares"},
      {data: "cost", render: $.fn.dataTable.render.number( ',', '.', 2, '$' )},
      {data: "market_value", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
      {data: "date", render: $.fn.dataTable.render.moment( 'MM/DD/YYYY' )},
      {data: "interest_dividends", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) }
    ]

  pre_process: (value) ->
    value.total_value=to_currency(value.total_value);
    value.cost=to_currency(value.cost);
    value.market_value=to_currency(value.market_value);
    value.interest_dividends=to_currency(value.interest_dividends);
    value

  footer_callback: ( row, data, start, end, display ) ->
    api = @api()
    COLNUMBERS = [ 2, 4, 5, 7 ]
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
        'securities_name'
        'total_value'
        'cost'
        'num_of_shares'
        'market_value'
        'date'
        'interest_dividends'
      ]
      numeric_fields = [
        'total_value'
        'cost'
        'num_of_shares'
        'market_value'
        'interest_dividends'
      ]
      date_fields = [
        'date'
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
