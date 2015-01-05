$(document).ready(function() {
  $('#reservation').daterangepicker({
    format: 'DD/MM/YYYY',
    opens: 'left'
  });

  $("#properties_search input").keyup(function() {
    $.get($("#properties_search").attr("action"), $("#properties_search").serialize(), null, "script");
    return false;
  });
});
