// (function() {
//
//   // Define our constructor
//   this.PasswordStrengthMeter = function() {
//     this.passwordInput = null;
//   }
//
//   // Public Method
//   PasswordStrengthMeter.prototype.open = function(id) {
//     this.passwordInput = $('#'+id);
//     addKeyUpEvent.call(this);
//   }
//
//   // Private Methods
//   function addKeyUpEvent() {
//     var password_field = this.passwordInput;
//     this.passwordInput.keyup(function(){
//         checkPasswordStrength(password_field.val());
//     });
//   }
//
//   function checkPasswordStrength(password_field_text) {
//     this.pws1 = $("#pws1");
//     this.pws2 = $("#pws2");
//     this.pws3 = $("#pws3");
//
//     str_password = password_field_text;
//     char_password = str_password.split("");
//
//     if (char_password.length > 0) {
//       getPasswordStrength(str_password);
//     } else {
//       $("#password-meter").css('visibility', 'visible');
//       pws1.css('visibility', 'visible');
//       pws2.css('visibility', 'hidden');
//       pws3.css('visibility', 'hidden');
//     }
//   }
//
//   function getPasswordStrength(str_password) {
//     this.password_strength = $("#password_strength");
//     this.pws1 = $("#pws1");
//     this.pws2 = $("#pws2");
//     this.pws3 = $("#pws3");
//
//     $.ajax({
//       url: '/password_strength',
//       type: 'POST',
//       beforeSend: function(jqXHR) {jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
//       dataType: "json",
//       data: {str_password: str_password},
//       success: function(data, textStatus, jqXHR) {
//         score = jqXHR.responseJSON["password_strength"];
//         if (score == 'weak') {
//           password_strength.html("Very Weak").trigger('password_change_trigger');
//           $("#text_strength").css('visibility', 'visible');
//           $("#password-meter").removeClass("weak strong").addClass("very-weak").css('visibility', 'visible');
//           pws2.css('visibility', 'hidden');
//           pws3.css('visibility', 'hidden');
//         } else if (score == 'average') {
//           password_strength.html("Weak").show().trigger('password_change_trigger');
//           $("#password-meter").removeClass("very-weak strong").addClass("weak").css('visibility', 'visible');
//           pws2.css('visibility', 'visible');
//           pws3.css('visibility', 'hidden');
//         }
//         else if (score == 'strong') {
//           password_strength.html("Strong").show().trigger('password_change_trigger');
//           $("#password-meter").removeClass("very-weak weak ").addClass("strong").css('visibility', 'visible');
//           pws2.css('visibility', 'visible');
//           pws3.css('visibility', 'visible');
//         }
//       },
//       error: function(jqXHR, textStatus, errorThrown){
//           // indicates the CSRF token has expired, reload the page to reinitialize
//           location.reload();
//       }
//     });
//   }
// }());
