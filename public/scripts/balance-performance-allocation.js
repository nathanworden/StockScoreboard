$(function() {
  $tabs = $('.option-heading h5');
  $tabs.on('click', function(event) {
    $(this).addClass('active');
    $(this).siblings().removeClass('active');

    $('section[data-block]').hide().filter('[data-block=' + $(this).attr('data-block') + ']').show()
  });
});

