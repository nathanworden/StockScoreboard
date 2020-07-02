$(function() {
    $(".add-position").on("click", function(event) {
      event.preventDefault();
      var $e = $(this);

      $(".add-position-modal").css({
        top: $(window).scrollTop() + 30
      });

      $(".add-position-modal").fadeIn(400);
      $(".modal-layer").fadeIn(400);
    });

    $(".modal-layer, a.close").on("click", function(event) {
      event.preventDefault();

      console.log(event);
      $(".add-position-modal").fadeOut(400);
      $(".modal-layer").fadeOut(400);
    });
});