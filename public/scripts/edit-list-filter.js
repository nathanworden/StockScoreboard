
$(function() {


  let $checkboxes = $('#edit-list-checkbox-options label input');
  $checkboxes.click(function() {
    if ($(this).prop("checked") === true) {
      let attribName = $(this).attr('name')
      $(`#${attribName}`).css(
        {display: 'inline-block',
        }
      );
    } else if ($(this).prop("checked") === false) {
      let attribName = $(this).attr('name')
      $(`#${attribName}`).css({display: 'none'});
    }
  });
});  
