window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
  callback();
  if (element.data('valid') !== false) {
    if (element.parent().find("i.validate_icon").length > 0) {
      element.parent().find("i.validate_icon").remove();
    }
    /*
    if ( element.parent().find('span.help-inline').length > 0 ) {
      $("<i class='validate_icon validate_error_icon'></i>").insertBefore(element.parent().find('span.help-inline'));
    } else {
      $("<i class='validate_icon validate_error_icon'></i>").appendTo(element.parent());
    }
    */
    if ( element.parent().find('p.help-block').length > 0 ) {
      element.parent().find('p.help-block').remove();
    }
    if( element.parent().parent().find("i.validate_icon").length > 0 ) {
      element.parent().parent().find("i.validate_icon").remove();
    }
    $("<i class='validate_icon validate_error_icon'></i>").insertAfter(element)
  }
}

window.ClientSideValidations.callbacks.element.pass = function(element, callback) {
  element.parent().find("i.validate_icon").hide(callback);
  $("<i class='validate_icon validate_success_icon'></i>").insertAfter(element);
}

