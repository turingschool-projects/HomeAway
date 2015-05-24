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
      debugger; 
      
      $.ajax({
        method: "POST",
        url: "/wishlist",
        data: { wishlist: { }}
      });
    });
  };

  addToWishList("#wishlist");

});
