
class window.RothIRARetirement extends window.BaseTable
  fields: ->
    [
      {
        label: "Type",
        name: "type",
        type:  "select",
        options: [
          { label: "Roth IRA", value: "Roth IRA" }
        ]
      }, {
        label: "Total Value",
        name: "total_value"
      }, {
        label: "Contributions Thus Far",
        name: "contributions_thus_far",
      }, {
        label: "Date of Initial Contribution",
        name: "date_of_initial_contribution",
        type: "datetime",
        format: 'MM/DD/YYYY',
        dateFormat: 'MM/DD/YYYY',
        def: ->
          d = new Date
          return getFormattedDate(d);
      }, {
        label: "Name of Investment Company",
        name: "investment_company"
      }
    ]

  columns: ->
    return [
      {data: "type"},
      {data: "total_value", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ) },
      {data: "contributions_thus_far", render: $.fn.dataTable.render.number( ',', '.', 2, '$' ), "defaultContent": "" },
      {data: "date_of_initial_contribution", "defaultContent": "" },
      {data: "investment_company"}
    ]

  pre_process: (value) ->
    value.total_value=to_currency(value.total_value);
    value.contributions_thus_far=to_currency(value.contributions_thus_far);
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
        'type'
        'total_value'
        'date_of_initial_contribution'
        'contributions_thus_far'
        'investment_company'
      ]
      numeric_fields = [
        'total_value'
        'contributions_thus_far'
      ]
      date_fields = [
        'date_of_initial_contribution'
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