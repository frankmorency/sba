// Quill Helper utilities
Certify.MSG.QuillHelpers = (function(){
  return {

    // this holds the instance of quill
    quill: {},

    // check the form body content for content
    checkForEmptyBody: function(body_content){
      return ( body_content === Certify.MSG.QuillHelpers.placeholder_text ||
               body_content === "<p><br></p>"    || // this is the default 'empty' state of quilljs
               body_content === null             ||
               body_content === undefined        ||
               body_content === ""
             );
    },

    // build a new quill form
    buildForm: function(quill_body_id, form_id){
      var options = {
        theme: 'snow',
        modules: {
          toolbar: [
            ['bold', 'italic', 'underline', 'link'],
            [{ 'list': 'ordered'}, { 'list': 'bullet' }]
          ]
        }
      };
      Certify.MSG.QuillHelpers.quill = new Quill(quill_body_id, options);

      Certify.MSG.QuillHelpers.addFormHandlers(form_id);
    },

    // adding in custom form handlers for the new quill form
    addFormHandlers: function(form_id){
      var form = document.querySelector(form_id);

      form.onsubmit = function(event){
        var messageBody = document.querySelector('#form_body');
        var body = Certify.MSG.QuillHelpers.quill.root.innerHTML;
        messageBody.value = body.replace(/\&lt\;/g, '<').replace(/\&gt\;/g, '>');

        // if the form body is empty, reset the form
        if (Certify.MSG.QuillHelpers.checkForEmptyBody(messageBody.value)){
          Certify.MSG.QuillHelpers.blockSubmitAndReset(event, form);
        }
      };
    },

    blockSubmitAndReset: function(event, form){
      console.log('body is empty'); // probably need to add another little pop up here
      event.preventDefault();
      form.reset();
    }
  };
})();
