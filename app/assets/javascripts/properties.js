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

  function attachAddToWishListHandler(selector){
    $(selector).on("click", addToWishList);
  };

  function detachAddToWishListHandler(selector){
    $(selector).off("click", addToWishList);
  };

  function attachRemoveFromWishListHandler(selector){
    $(selector).on("click", removeFromWishList);
  };

  function detachRemoveFromWishListHandler(selector){
    $(selector).off("click", removeFromWishList);
  };

  function addToWishList(){
    var property_id = $(this).attr("data-id");

    $.ajax({
      method: "POST",
      url: "/favorites",
      data: { wishlist: { property_id: property_id }}
    });

    $(this).removeClass("wishlist").addClass("on-wishlist");
    $(".wishlist-text").text("Remove from Wishlist");

    detachAddToWishListHandler(".wishlist");
    attachRemoveFromWishListHandler(".on-wishlist");
  };

  function removeFromWishList(){
    var property_id = $(this).attr("data-id");

    $.ajax({
      method: "DELETE",
      url: "/favorites/" + property_id
    });

    $(this).removeClass("on-wishlist").addClass("wishlist");
    $(".wishlist-text").text("Add to Wishlist")

    detachRemoveFromWishListHandler(".on-wishlist");
    attachAddToWishListHandler(".wishlist");
  };

  attachAddToWishListHandler(".wishlist");
  attachRemoveFromWishListHandler(".on-wishlist");
});
