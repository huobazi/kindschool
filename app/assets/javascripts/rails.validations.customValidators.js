window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
  callback();
  if (element.data('valid') !== false) {
    /*
     * element.parent().find('.message').hide().show('slide', {direction: "left", easing: "easeOutBounce"}, 500);
     */
    if (element.parent().find("i.validate_icon").length > 0) {
      element.parent().find("i.validate_icon").remove();
    }
    if ( element.parent().find('span.help-inline').length > 0 ) {
      $("<i class='validate_icon validate_error_icon'></i>").insertBefore(element.parent().find('span.help-inline'));
    } else {
      $("<i class='validate_icon validate_error_icon'></i>").appendTo(element.parent());
    }
  }
}

window.ClientSideValidations.callbacks.element.pass = function(element, callback) {
  // Take note how we're passing the callback to the hide()
  // method so it is run after the animation is complete.
  /*
   * element.parent().find('.message').hide('slide', {direction: "left"}, 500, callback);
   */
  element.parent().find("i.validate_icon").hide(callback);
  $("<i class='validate_icon validate_success_icon'></i>").appendTo(element.parent());
}

