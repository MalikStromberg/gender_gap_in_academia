# html specifications for section iv

iv_html_specifications <- function(active_color,
                                   font_family,
                                   font_color,
                                   bg_color) {
    ret <- paste(
'.col-sm-offset-2 {
  margin-left: 16.66666667%;
}
.col-sm-8 {
    width: 66.66666667%;
}',

'.col-lg-1, .col-lg-10, .col-lg-11, .col-lg-12, .col-lg-2, .col-lg-3, .col-lg-4,
.col-lg-5, .col-lg-6, .col-lg-7, .col-lg-8, .col-lg-9, .col-md-1, .col-md-10,
.col-md-11, .col-md-12, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,
.col-md-7, .col-md-8, .col-md-9, .col-sm-1, .col-sm-10, .col-sm-11, .col-sm-12,
.col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8,
.col-sm-9, .col-xs-1, .col-xs-10, .col-xs-11, .col-xs-12, .col-xs-2, .col-xs-3,
.col-xs-4, .col-xs-5, .col-xs-6, .col-xs-7, .col-xs-8, .col-xs-9 {
    position: relative;
    min-height: 1px;
    padding-right: 0px;
    padding-left: 0px;
}',

'caption {
    padding-top: 8px;
    padding-bottom: 8px;
    color: ', font_color,
'; text-align: left;
}',

'.irs--shiny .irs-bar--single {
    border-radius: 8px 0 0 8px;
  }',

'.irs--shiny .irs-bar {
    top: 25px;
    height: 8px;
    background-color: ', active_color,
'; border: 1px solid ', active_color,
'; border-radius: 8px;
}',

'.irs--shiny .irs-line {
    top: 25px;
    height: 8px;
    background: ', active_color,
'; background-color: rgba(0, 0, 0, 0);
    background-color: ', active_color,
'; border: 1px solid ', active_color,
'; border-radius: 8px;
}',

'.irs--shiny .irs-handle {
    top: 17px;
    width: 22px;
    height: 22px;
    border: 1px solid ', active_color,
'; background-color: ', font_color,
'; box-shadow: 0px 0px 0px', active_color, ' !important;
    border-radius: 22px;
}
.irs-handle {
    position: absolute;
    display: block;
    box-sizing: border-box;
    cursor: pointer;
    z-index: 1;
}',

'.irs--shiny .irs-handle.state_hover, .irs--shiny .irs-handle:hover {
    background: ', '#FFD8B2', ';
}',

'.irs--shiny .irs-single {
    color: #3d3d3d;
    text-shadow: none;
    padding: 1px 3px;
    background-color: ', active_color,
'; border: 1px solid ', active_color,
'; border-radius: 3px;
    font-size: 11px !important;
    font-family: ', font_family,
'; line-height: 1;
}',

'.irs--shiny .irs-min, .irs--shiny .irs-max {
    top: 0;
    padding: 0px 3px;
    color:', "#3d3d3d;",
'text-shadow: none;
    background-color: ', font_color,
'; border: none',
'; border-radius: 3px;
    font-size: 11px !important;
    font-family: ', font_family,
'; line-height: 1.333;
}
.irs-min {
    left: 0;
}
.irs-min, .irs-max {
    position: absolute;
    display: block;
    cursor: default;
}',

'.form-control {
    display: block;
    width: 100%;
    height: 34px;
    padding: 6px 12px;
    font-size: 12px;
    line-height: 1.42857143;
    color:', "#3d3d3d;",
'background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    -webkit-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
}',

'.btn-pick {
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
    }',

'.irs {
  font-family: ', font_family, ';
}',

'.irs--shiny .irs-grid-text {
    bottom: 5px;
    color: ', font_color,
';}
.irs-grid-text {
    position: absolute;
    bottom: 0;
    left: 0;
    white-space: nowrap;
    text-align: center;
    font-size: 11px !important;
    font-family: ', font_family,
'; line-height: 9px;
    padding: 0 3px;
    color: ', font_color,
';}',

'.irs--shiny .irs-grid-pol {
    background-color: ', font_color,
';}
.irs-grid-pol {
    position: absolute;
    top: 0;
    left: 0;
    width: 1px;
    height: 8px;
    background: ', font_color,
'; background-color: rgb(0, 0, 0);
}


.pickerinput_iv .selected {
    background-color:', active_color, ' !important;
    color:', bg_color, ' !important;
}

.pickerinput_iv .dropdown-menu {
    font-size:11px;
    font-family: ', font_family, ';
    color: ', bg_color, ';
}',

'.checkbox_iv label {
    color: ', font_color, ';
    font-size: 11px !important;
}'


    )
    return(ret)
  }
