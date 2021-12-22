$(document).ready(function() {
  Certify.Notify.MarkRead.update();
});

Certify.Notify.MarkRead = {
  update: function() {
    $('.notification').click(function() {
      var notificationID = $(this).data("notify-id");
      var updateNotifyPayload =  { id: notificationID , read: true };
      
      //find other notifications with same notify-id
      $('[data-notify-id="' + notificationID + '"]').removeClass('unread').addClass('read');
      
      $.ajax({
        url: '/update_status',
        type: 'GET',
        data: updateNotifyPayload,
        success: function() {
          // console.log('update response', resp);
        }
      });
    });
  }
};
