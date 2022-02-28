# this function returns html specifications for section VII

i_html_specifications <- function(bg_color,
                                    font_color,
                                    font_family,
                                  inactive_color,
                                  active_color,
                                  font_size) {
  ret <- paste0('
  body {
      width: 100%;
      padding: 0;
      margin: 0;
      font-family: "',
      font_family, '";
      font-size:12px;
  }
  
  :focus {
    outline: 0 !important;
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0) !important;
  }
  
  .title-area {
    width: 100%;
    height: 60vh !important;
  }

  .btn-threshold {
      box-shadow: 0px 0px 0px 0px #ffffff;
      background:linear-gradient(to bottom, ', '#787878', ' 0%, ',
      '#787878', ' 100%);
      background-color:', '#252525', ';
      border-radius:15px;
      border:0px solid ', bg_color, ';
      display:inline-block;
      cursor:pointer;
      color:', bg_color, ';
      font-family:', font_family, ';
      font-size:11px;
      padding:0px 5px;
      text-decoration:none;
      text-shadow:0px 0px 0px ', bg_color, ';
      width:45px;
      height:25px;
  }
  
  .btn-threshold:hover {
      color:', bg_color, ';
      font-weight:bold;
  }
  
  .btn-threshold:focus {
      color:', bg_color, ';
  }
  
  .threshold_container label {
    color:', font_color, ';
    font-size:', font_size, 'px;
    font-weight: 400;
  }
  
  ')
}