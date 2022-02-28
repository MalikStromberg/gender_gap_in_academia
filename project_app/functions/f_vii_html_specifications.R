# this function returns html specifications for section VII

vii_html_specifications <- function(bg_color, inactive_color,
                                    active_color, font_color,
                                    font_family, text_input_color,
                                    text_input_font_color,
                                    font_size) {
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
  
  .btn-page {
      box-shadow: 0px 0px 0px 0px #ffffff;
      background:linear-gradient(to bottom, ', inactive_color, ' 0%, ',
      inactive_color, ' 100%);
      background-color:', active_color, ';
      border-radius:12px;
      border:3px solid ', bg_color, ';
      display:inline-block;
      cursor:pointer;
      color:', bg_color, ';
      font-family:', font_family, ';
      font-size:', font_size - 1, 'px;
      padding:0px 5px;
      text-decoration:none;
      text-shadow:0px 0px 0px ', bg_color, ';
      width:30px;
      height:30px;
    }
    .btn-page:hover {
      color:', bg_color, ';
      font-weight:bold;
      cursor:pointer;
    }
    .btn-page:focus {
      color:', bg_color, ';
      cursor:pointer;
    }
    .btn-page:disabled {
      cursor:pointer;
      font-weight:normal;
    }
    .btn-radio {
      box-shadow: 0px 0px 0px 0px #ffffff;
      background:linear-gradient(to bottom, ', inactive_color, ' 0%, ',
      inactive_color, ' 100%);
      background-color:', active_color, ';
      border-radius:15px;
      border:0px solid ', bg_color, ';
      cursor:pointer;
      color:', bg_color, ';
      font-family:', font_family, ';
      font-size:', font_size - 1, 'px;
      padding:0px 5px;
      text-decoration:none;
      text-shadow:0px 0px 0px ', bg_color, ';
      width:80px;
      height:25px;
    }
    .btn-radio:hover {
      color:', bg_color, ';
      font-weight:bold;
    }
    .btn-radio:focus {
      color:', bg_color, ';
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
      font-size:', font_size, 'px;
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
    
    .irs-grid-text {
      color: ', font_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    .irs-from, .irs-to {
      background: ', active_color, ';
      color: ', bg_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    .irs-grid-pol {
      background: ', active_color, ';
    }
    .irs-grid-pol.small {
      background: ', active_color, ';
    }
    .irs-max {
      color: ', bg_color, ';
      background-color: ', inactive_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    .irs-min {
      color: ', bg_color, ';
      background-color: ', inactive_color, ';
      font-family: ', font_family, ';
      font-size:9px;
      left:0;
    }
    .irs-bar {
      background: ', inactive_color, ';
      border: 0px;
      width: 100%;
    }
    .irs-bar-edge {
      background: ', inactive_color, ';
      border: 0px;
    }
    .irs-line {
      background: ', inactive_color, ';
      border: 0px
    }
    .irs-single {
      background: ', active_color, ';
      color: ', bg_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    .irs-slider {
      color: ', font_color, ';
      background: ', active_color, ';
      radius: 50%;
    }
    .irs-slider:hover {
      background: ', inactive_color, '
    }
    
    .irs--shiny .irs-grid-text {
      color: ', font_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    .irs--shiny .irs-from, .irs--shiny .irs-to {
      padding: 0.5px 3px;
      background: ', active_color, ';
      color: ', bg_color, ';
      font-family: ', font_family, ';
      font-size:11px;
    }
    .irs--shiny .irs-grid-pol {
      background: ', active_color, ';
    }
    .irs--shiny .irs-grid-pol.small {
      background: ', active_color, ';
    }
    .irs--shiny .irs-max {
      color: ', bg_color, ';
      background-color: ', inactive_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    .irs--shiny .irs-min {
      color: ', bg_color, ';
      background-color: ', inactive_color, ';
      font-family: ', font_family, ';
      font-size:9px;
      left:0;
    }
    .irs--shiny .irs-bar {
      background: ', inactive_color, ';
      border: 0px;
      width: 100%;
    }
    .irs--shiny .irs-bar-edge {
      background: ', inactive_color, ';
      border: 0px;
    }
    .irs--shiny .irs-line {
      background: ', inactive_color, ';
      border: 0px
    }
    .irs--shiny .irs-single {
      background: ', active_color, ';
      color: ', bg_color, ';
      font-family: ', font_family, ';
      font-size:9px;
    }
    
    .irs--shiny .irs-handle {
      top: 17px;
      width: 22px;
      height: 22px;
      border: 1px solid', active_color, ';
      background-color:', active_color, ';
      box-shadow: 1px 1px 3px rgba(255, 255, 255, 0.3);
      border-radius: 22px;
    }
    
    input[type = "number"] {
      width: 75px;
      height:27px;
      font-size:', font_size, 'px;
      background-color:', text_input_color, ';
      color:', text_input_font_color, ';
    }
    
    input[type = "text"] {
      width: 300px;
      height:27px;
      font-size:', font_size, 'px;
      background-color:', text_input_color, ';
      color:', text_input_font_color, ';
    }
    
    .hovertext {
      opacity: 0.8;
      border:5px solid ', bg_color, ';
    }
    
    .picker_input .selected {
      background-color:', active_color, ' !important;
      color:', bg_color, ' !important;
    }
    
    .picker_input .dropdown-menu {
      font-size:', font_size, 'px;
      font-family: ', font_family, ';
      color: ', bg_color, ';
    }
    
    
    .vii_right {
      margin-left:12px;
    }
    
    .vii_right_table {
      margin-left:12px;
      font-size:11px !important;
    }
    
    .vii_left {
      margin-right:12px;
    }
    
    .vii_label label {
      color:', font_color, ';
      font-weight: 400;
      font_size:', font_size, 'px;
    }
    
    td{vertical-align: top;}
    
  ')
}