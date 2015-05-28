$(function() {
  if ($('#infinite-scrolling').size() > 0) {
    $(window).on('scroll', function() {
      var more_posts_url;
      more_posts_url = $('.pagination a[rel=next]').attr('href');
      if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html("");
        $.ajax({
          url: more_posts_url,
          success: function(data) {
            return $(".properties").append(data);
          }
        });
      }
      if (!more_posts_url) {
        return $('.pagination').html("");
      }
    });
  }
});
