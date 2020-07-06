
$(function() {

  var click = 1;
  $('.editlist').on('click', function(event) {
    event.preventDefault();
    let $editlist = $('.editlist');

    if (click) {
      click = 0;
      $editlist.prop('disabled', true);

      $('section.metrics').animate({
        "flex-grow": "0",
        opacity: 'toggle',
      }, 700);


      $('.list-control-sidebar').animate({
        "flex-grow": "10",
      }, 700, function() {
        $(".list-controls").animate({height: "180px"}, 500);
        $(".list-controls").css({display: "flex"});
        $('.stay-box').css({flex: "1"});
        $('#edit-list-checkbox-options').css({
            display: "inline-block",
            padding: "0px",
            margin: "0px",
            "max-height": "178px",
        });
        $('#edit-list-checkbox-options label').css({
          display: "inline-block",
        });
        $editlist.prop('disabled', false);
      });

    } else if (click === 0) {
      click = 1;
      $editlist.prop('disabled', true);

      $('#edit-list-checkbox-options').css({
        display: "none",
      });

      $('#edit-list-checkbox-options label').css({
        display: "none",
      });

      $(".list-controls").animate({height: "60px"}, 500, function() {
        $('section.metrics').animate({
          "flex-grow": "9",
          opacity: 'toggle',
        }, 700);

        $('.list-control-sidebar').animate({
          "flex-grow": "1",
        }, 700, function() {
          $('.stay-box').css({ flex: "1"});

          $editlist.prop('disabled', false);
        });
      });

      $(".list-controls").css({display: "inline-block"});

    }
  });

  $listInfo = $('.list-info p');

  $('.list-info').on('click', function(event) {
    event.preventDefault();
    $listInfo.toggle();
  })
});  
