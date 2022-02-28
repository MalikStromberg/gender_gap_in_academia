# this function contains all necessary HTML specifications for section V

v_html_specifications <- function(bg_color, active_color, inactive_color,
                                  font_family, font_color, font_size) {
  ret <- paste0('
  body {
      font-family: "',
      font_family, '";
      font-size:12px;
  }
  
  :focus {
    outline: 0 !important;
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0) !important;
  }
  
  .hovertext {
      opacity: 0.8;
      border:5px solid ', bg_color, ';
  }
  
  .btn-unchecked {
      box-shadow: 0px 0px 0px 0px #ffffff;
      background:linear-gradient(to bottom, ', inactive_color,
      ' 0%, ', inactive_color, ' 100%);
       background-color:', active_color, ';
         border-radius:15px;
       border:3px solid ', bg_color, ';
       display:inline-block;
       cursor:pointer;
       color:', bg_color, ';
       font-family:', font_family, ';
       font-size:', font_size, 'px;
       padding:0px 5px;
       text-decoration:none;
       text-shadow:0px 0px 0px #ffffff;
       width:250px;
       height:25px;
  }
  .btn-unchecked:hover {
    color:', bg_color, ';
    font-weight:bold;
  }
    
  .v_right_table {
    margin-left:12px;
  }
  
  .v_left_table {
    margin-right:12px;
  }
    
  .v_plot {
    font-size:', font_size + 4, 'px;
  }
  
    ')
  
  return(ret)  
}