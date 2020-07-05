
$(function() {


  let $checkboxes = $('#edit-list-checkbox-options label input');
  $checkboxes.click(function() {
    if ($(this).prop("checked") === true) {
      let attribName = $(this).attr('name')
      console.log(`${attribName} is checked.`);
      $(`#${attribName}`).css({display: 'none'})
    } else if ($(this).prop("checked") === false) {
      let attribName = $(this).attr('name')
      console.log(`${attribName} is unchecked.`);
      $(`#${attribName}`).css({display: 'none'});
    }
  });
});  
