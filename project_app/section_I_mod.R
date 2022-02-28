# load section functions
source('functions/f_i_html_specifications.R')
source('functions/f_i_create_icons.R')

# create section variables
i_icons <- i_create_icons(
  c('article', 'journal', 'author', 'hourglass', 'search'))

i_image_source <- 'title.jpg'

i_title_style <- paste0('height:60vh; background-image: url(',
                        i_image_source,
                        '); background-size: cover;')

i_icon_style <- paste0('background-color: ', theme$i_bg_color, ';
                      border: 0px;
                      font-size:60px;
                      height:90px;
                      width:150px;
                      vertical-align:bottom;
                      cursor:auto;')
# read section data
data_i <- readRDS('data/I.rds')


########## create section UI function

section_I_ui <- function(id) {
  ns <- NS(id)
  
  pageSection(
    center = T,
    menu = 'home',
    class = 'btnFinalizeProjectInformation',
    
    # styling
    tags$style(HTML(i_html_specifications(
      bg_color = theme$i_bg_color,
      font_color = theme$i_font_color,
      font_family = theme$font_family,
      active_color = theme$i_active_input_color,
      inactive_color = theme$i_inactive_input_color,
      font_size = theme$font_size
    ))),
    
    # header
    fluidRow(
      div(style = i_title_style,
          h1(HTML('<b>Gender Gap in Academic Publications<br>in Business and Economics</b>'),
             style = paste0(
               'background-color: #252525;
              padding:15px;
              position: absolute;
              top: 25%;
              left: 50%;
              color:',
               theme$i_bg_color,
               ';font-size:40px;
              transform: translate(-50%, -50%);')),
          
    )),
    
    # icons
    verticalLayout(
      fluidRow(
        column(1, div(style = 'height:30vh')),
        column(2, br(),
               # icon number of publications
               actionButton(
                 inputId = ns("i_dummy1"),
                 label = NULL,
                 icon = i_icons$article,
                 style = i_icon_style
               ),
               h5(tags$i(tags$b(as.character(data_i$n_articles))),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family)),
               h5(tags$i(tags$b('Publications')),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family))
        ),
        column(2,br(),
               # icon number of books and journals
               actionButton(
                 inputId = ns("i_dummy2"),
                 label = NULL,
                 icon = i_icons$journal,
                 style = i_icon_style
               ),
               h5(tags$i(tags$b(as.character(data_i$n_journals))),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family)),
               h5(tags$i(tags$b('Journals & Books')),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family))),
        column(2,br(),
               # icon number of names
               actionButton(
                 inputId = ns("i_dummy3"),
                 label = NULL,
                 icon = i_icons$author,
                 style = i_icon_style
               ),
               h5(tags$i(tags$b(as.character(data_i$n_gnames))),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family)),
               h5(tags$i(tags$b('Labeled Given Names')),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family))),
        column(2, br(),
               # icon covered years
               actionButton(
                 inputId = ns("i_dummy4"),
                 label = NULL,
                 icon = i_icons$hourglass,
                 style = i_icon_style
               ),
               h5(
                 tags$i(
                   tags$b(
                     paste0(
                       as.character(min(data_i$years)),
                       ' - ',
                       as.character(max(data_i$years)))
                   )),
                 style = paste0('color:', theme$i_font_color,
                                '; font-family:',
                                theme$font_family)),
               h5(tags$i(tags$b('Covered Years')),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family))),
        column(2, br(),
               # icon number of research fields
               actionButton(
                 inputId = ns("i_dummy5"),
                 label = NULL,
                 icon = i_icons$search,
                 style = i_icon_style
               ),
               h5(
                 tags$i(
                   tags$b(as.character(data_i$n_fields))),
                 style = paste0('color:', theme$i_font_color,
                                '; font-family:',
                                theme$font_family)),
               h5(tags$i(tags$b('Research Fields')),
                  style = paste0('color:', theme$i_font_color,
                                 '; font-family:',
                                 theme$font_family))),
        column(1)
      ),
      fluidRow(
        column(1, div(style = 'height:10vh')),
        column(10, align = 'center',
               # global unput: decision threshold
               div(class = 'threshold_container',
               radioGroupButtons(
                 inputId = ns("decision_threshold"),
                 label = 'Choose Decision Threshold:',
                 choices = c('0.6' = 6,
                             '0.7' = 7,
                             '0.75' = 75),
                 selected = 6,
                 status = "threshold"))),
        column(1))
    )
    
  )
}


########## section I SERVER function

section_I_server <- function(input, output, session) {
  ns <- session$ns
  
  # return reactive decision threshold for global accessability
  threshold <- reactive({input$decision_threshold})
  return(threshold)
}
