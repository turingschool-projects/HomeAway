$(document).ready(function() {
  $('#reservation').daterangepicker({
    format: 'DD/MM/YYYY',
    opens: 'left',
    applyClass: 'btn btn-default'
  });

  $('.selectpicker').selectpicker();

  $("#moneySlide").slider({});
  $("#moneySlide").on("slide", function(slideEvt) {
    $("#lowVal").text(slideEvt.value[0]);
    $("#highVal").text(slideEvt.value[1]);
    $.get($("#properties_search").attr("action"), $("#properties_search").serialize(), null, "script");
    return false;
  });

  $("#properties_search input").keyup(function() {
    $.get($("#properties_search").attr("action"), $("#properties_search").serialize(), null, "script");
    return false;
  });

  $("#properties_search select").change(function() {
    $.get($("#properties_search").attr("action"), $("#properties_search").serialize(), null, "script");
    return false;
  });

  function addToWishList(selector){
    $(selector).on("click", function(){
      var property_id = $(this).attr("data-id");            

      $.ajax({
        method: "POST",
        url: "/favorites",
        data: { wishlist: { property_id: property_id }}
      });

      $("#wishlist").css("color", "#cc0000").removeClass("#wishlist").addClass("#on-wishlist");
      $("#wishlist-text").text("Remove from Wishlist").css("color", "#cc0000");
    });
  };

  function removeFromWishList(selector){
    $(selector).on("click", function(){
      var property_id = $(this).attr("data-id");

      $.ajax({
        method: "DELETE",
        url: "/favorites/" + property_id 
      });

      $("#wishlist").css("color", "#777").removeClass("#on-wishlist").addClass("#wishlist");
      $("#wishlist-text").text("Add to Wishlist").css("color", "#777");
    });
  };

  addToWishList("#wishlist");
  removeFromWishList("#on-wishlist");

});
