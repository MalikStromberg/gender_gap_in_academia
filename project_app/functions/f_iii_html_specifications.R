# html specifications for section III 

iii_html_specifications <- function(active_input_color, inactive_input_color, text_input_color,
                                    bg_color, font_family){
  
  ret <- paste0(
    '.form-control {
    display: block;
    width: 100%;
    height: 34px;
    padding: 6px 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 0px 0px ',
    inactive_input_color,
    
    '; box-shadow: inset 0 0px 0px',
    inactive_input_color,
    '; -webkit-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
}',
    
    '.js-plotly-plot .plotly, .js-plotly-plot .plotly div {
    direction: ltr;
    font-family:',
    font_family,
    'color: #ff0000;}',
    
    'Element {
    pointer-events: all;
    stroke: ',
    inactive_input_color,
    ';
    stroke-opacity: 1;
    fill: ',
    inactive_input_color,
    ';
    fill-opacity: 1;
    stroke-width: 1px;
}',
    'Element {
    pointer-events: all;
    fill: ',
    inactive_input_color,
    ';
    fill-opacity: 1;
}',
    
    '.btn-picklight {
      box-shadow: none;
      background-color:',
    inactive_input_color,
    ';
      background: ',
    inactive_input_color,
    ';
      border-radius: 4px;
      border:0px solid ',
    bg_color,
    ';
      display:inline-block;
      cursor:pointer;
      color:',
    bg_color,
    ';
      font-family:',
    font_family,
    ';
      font-size:11px;
      text-valign: middle;
      text-decoration:none;
      text-shadow:none;
      width:550px;
      height:30px;
  }
  .btn-picklight:hover {
      color:',
    bg_color,
    ';
  }
  .btn-picklight:focus {
      color:',
    bg_color,
    ';
  }

  .pickerinput_iii .selected {
    background-color:',
    active_input_color,
    ' !important;
    color:',
    bg_color,
    ' !important;
  }

  .pickerinput_iii .dropdown-menu {
    font-size:11px;
    font-family: ',
    font_family,
    ';
    color: ',
    bg_color,
    ';
  }',
    
    '.checkbox_iii label {
    color: #3d3d3d;
    font-size: 12px;
}',
    
    '.col-sm-offset-4 {
    margin-left: 33.33333333%;
}
.col-sm-1 {
    width: 8.33333333%;
}',

'.hovertext {
      opacity: 1;
      border:5px solid ', bg_color, ';
      align:"left" !important;
  }'

  )
  return(ret)
}