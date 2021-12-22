// build the quill js text editor for the new message view and add event listeners
document.addEventListener('DOMContentLoaded', bindMessageReplyListeners);

function bindMessageReplyListeners(){
  showReply();
}

// listeners for showing and hiding the message edtior on the messages page
function showReply(){
  document.getElementById('show-reply').addEventListener('click', catchClick);
  Certify.MSG.QuillHelpers.buildForm('#new_message_body', '#new_message_form');
}

function catchClick(){
  document.getElementById('show-reply').classList.add('hidden');
  document.getElementById('reply-box').classList.remove('hidden');
  document.getElementById('cancel-reply').addEventListener('click', cancelReply);
}

function cancelReply(){
  document.getElementById('show-reply').classList.remove('hidden');
  document.getElementById('reply-box').classList.add('hidden');
}
