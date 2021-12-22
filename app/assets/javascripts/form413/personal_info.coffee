
class window.PersonalInfo
  constructor: (@data) ->

  to_html: ->
    return "<div class='panel' data-editor-id='#{@data.DT_RowId}'>

        <div class='usa-width-one-third'>
          <b><label for='firstname'>First Name</label></b>
          <span data-editor-field='first_name' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.first_name}</span>
        </div>
        <div class='usa-width-one-third'>
          <b><label for='firstname'>Last Name</label></b>
          <span data-editor-field='last_name' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.last_name}</span>
        </div>
        <div class='usa-width-one-fourth'>
          <b><label for='firstname'>Role/Title</label></b>
          <span data-editor-field='title' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.title}</span>
        </div>

        <div class='usa-width-one-third'>
          <b><label for='firstname'>Social Security Number</label></b>
          <span data-editor-field='ssn' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.ssn}</span>
        </div>
        <div class='usa-width-one-third'>
          <b><label for='firstname'>Marital Status</label></b>
          <span data-editor-field='marital_status' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.marital_status}</span>
        </div>

        <div class='usa-width-one-fourth'>
          <b><label for='firstname'>Email Address</label></b>
          <span data-editor-field='email' class='dtb_custom_ro_fields dtb_custom_ro_fields_large'>#{@data.email}</span>
        </div>

        <div class='usa-width-one-whole'>
          <b><label for='firstname'>Mailing Address</label></b>
          <span data-editor-field='address' class='dtb_custom_ro_fields dtb_custom_ro_fields_large'>#{@data.address}</span>
        </div>

        <div class='usa-width-one-third'>
          <b><label for='firstname'>City</label></b>
          <span data-editor-field='city' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.city}</span>
        </div>
        <div class='usa-width-one-third'>
          <b><label for='firstname'>State</label></b>
          <span data-editor-field='state' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.state}</span>
        </div>
        <div class='usa-width-one-fourth'>
          <b><label for='firstname'>Zip Code</label></b>
          <span data-editor-field='postal_code' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.postal_code}</span>
        </div>

        <div class='usa-width-one-third'>
          <b><label for='firstname'>Country</label></b>
          <span data-editor-field='country' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.country}</span>
        </div>
        <div class='usa-width-one-third'>
          <b><label for='firstname'>Business Phone</label></b>
          <span data-editor-field='home_phone' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.home_phone}</span>
        </div>
        <div class='usa-width-one-fourth'>
          <b><label for='firstname'>Personal Phone</label></b>
          <span data-editor-field='business_phone' class='dtb_custom_ro_fields dtb_custom_ro_fields_medium'>#{@data.business_phone}</span>
        </div>
      <br/>
      <div class='usa-grid-full'>
        <button data-id='#{@data.DT_RowId}'>Remove</button>
      </div>
      <br>
"

