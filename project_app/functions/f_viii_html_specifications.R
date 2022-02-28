# this function returns html specifications for section VII

viii_html_specifications <- function(bg_color, inactive_color,
                                    active_color, font_color,
                                    font_family, text_input_color,
                                    text_input_font_color) {
  ret <- paste0('
  body {
      font-family: "',
      font_family, '";
      font-size:12px;
      color: ',
      font_color,
      ';
    }
  
  :focus {
    outline: 0 !important;
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0) !important;
  }
  
  .viii_paragraph_left {
    font-size:13px;
    margin-right:15px;
  }
  
  .viii_paragraph_right {
    font-size:13px;
    margin-left:15px;
  }
  
  .viii_paragraph {
    font-size:13px;
  }
  
  .viii_paragraph_center {
    display: block;
    justify-content: center;
    align-items: center;
    vertical-align: middle;
    font-size: 13px;
  }
  
  ')
}