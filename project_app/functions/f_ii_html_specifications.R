# this function returns html specifications for section II

ii_html_specifications <- function(font_color, active_color, inactive_color,
                                   bg_color, font_family) {
  ret <- paste0('
  body {
      font-family: "',
      font_family, '";
      font-size:8pt;
  }
  
  :focus {
    outline: 0 !important;
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0) !important;
  }
  
  .btn-pick {
      box-shadow: none;
      background-color:', active_color, ';
      background: ', active_color, ';
      border-radius: 4px;
      border:0px solid ', bg_color, ';
      display:inline-block;
      cursor:pointer;
      color:', bg_color, ';
      font-family:', font_family, ';
      font-size:11px;
      text-valign: middle;
      text-decoration:none;
      text-shadow:none;
      width:550px;
      height:30px;
  }
    
  .btn-pick:hover {
    color:', bg_color, ';
  }
  
  .btn-pick:focus {
    color:', bg_color, ';
  }
    
  .picker_input .selected {
    background-color:', active_color, ' !important;
    color:', bg_color, ' !important;
  }
    
  .picker_input .dropdown-menu {
    font-size:11px;
    font-family: ', font_family, ';
    color: ', bg_color, ';
  }
  
  .ii_right {
    margin-left:8px;
  }
    
  .ii_left {
    margin-right:8px;
  }
    
  .ii_label label {
    color:', font_color, ';
    font-weight: normal;
  }
    
  .hovertext {opacity: 0.8; border:5px solid ', bg_color, ';}
  
  ')
}



# .selected {
#   background-color:', active_color, ' !important;
#   color:', bg_color, ' !important;