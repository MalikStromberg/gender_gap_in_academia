vii_script <- function(id) {
  ret <- sprintf("
      var window_size_id = '%s';
      var window_size = [0, 0];

      $(document).on('shiny:connected', function(e) {
        window_size[0] = window.innerWidth;
        window_size[1] = window.innerHeight;
        Shiny.onInputChange(window_size_id, window_size);
      });

      $(window).resize(function(e) {
        window_size[0] = window.innerWidth;
        window_size[1] = window.innerHeight;
        Shiny.onInputChange(window_size_id, window_size);
      });
  ",
  id)
  return(ret)
}