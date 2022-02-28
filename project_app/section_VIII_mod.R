# load section functions
source('functions/f_viii_html_specifications.R')
source('functions/f_viii_project_goal.R')
source('functions/f_viii_method.R')
source('functions/f_viii_data.R')
source('functions/f_viii_remarks.R')
source('functions/f_viii_extensions.R')

# initialize section variables
viii_link_button_style <- paste0('
  background-color: ', theme$viii_bg_color, ';
  border: 0px;
  font-size:15px;
  height:20px;
  width:30px;
  vertical-align:bottom;'
)
link_f <- "window.open('https://www.linkedin.com/in/franziska-m%C3%BCller-b73918197/', '_blank')"
link_m <- "window.open('https://www.linkedin.com/in/malik-stromberg-520064146', '_blank')"
link_marketing <- "window.open('https://uni-tuebingen.de/fakultaeten/wirtschafts-und-sozialwissenschaftliche-fakultaet/faecher/fachbereich-wirtschaftswissenschaft/wirtschaftswissenschaft/lehrstuehle/betriebswirtschaftslehre/marketing/marketing/', '_blank')"

# load section data


########## section VIII UI function

section_VIII_ui <- function(id) {
  ns <- NS(id)
  
  pageSection(
    center = T,
    menu = 'maliks3',
    class = 'btnFinalizeProjectInformation',
    # HTML / CSS stuff
    tags$style(HTML(viii_html_specifications(
      font_color = theme$viii_font_color,
      font_family = theme$font_family,
      bg_color = theme$viii_bg_color))),
    # header
    h2('Project Information',
       style = paste0('color:',
                      theme$viii_font_color,
                      '; font-family:"',
                      theme$font_family,
                      '"; ',
                      'align:"left";')),
    div(class = 'viii_paragraph',
        p('This project has been developed as a part of the Master
          program for Data Science in Business and Economics at the
          University of Tuebingen, Germany.')),
    fluidRow(
    column(1),
    column(4,
           align = 'left',
           verticalLayout(
             # paragraph project goal
             div(class = 'viii_paragraph_left',
                 fluidRow(
                   viii_project_goal(
                     font_color = theme$viii_font_color,
                     font_family = theme$font_family))),
             fluidRow(
               # paragraph method
               div(class = 'viii_paragraph_left',
                   viii_method(
                     font_color = theme$viii_font_color,
                     font_family = theme$font_family))
               ))),
    column(2,
           align = 'center',
           # developer information
           div(class = 'viii_paragraph_center',
               br(),
               h3(em('Developed by'), style = paste0('color:',
                                                 theme$viii_font_color)),
               br(),
               h4('Franziska Mueller'),
               em('Tuebingen, Germany'),
               br(),
               actionButton(
                 inputId = ns('viii_linked'), 
                 icon = icon("linkedin"),
                 label = NULL,
                 onclick = link_f,
                 style = viii_link_button_style),
               br(),
               br(),
               h4('Malik Stromberg'),
               em('Tuebingen, Germany'),
               br(),
               actionButton(
                 inputId = ns('viii_linked'), 
                 icon = icon("linkedin"),
                 label = NULL,
                 onclick = link_m,
                 style = viii_link_button_style),
               br(),
               br(),
               h4('Chair of Marketing'),
               em('University of Tuebingen'),
               br(),
               actionButton(
                 inputId = ns('viii_linked'), 
                 icon = icon("university"),
                 label = NULL,
                 onclick = link_marketing,
                 style = viii_link_button_style))
           ),
    column(4,
           align = 'left',
           verticalLayout(
             fluidRow(
               # paragraph data
               div(class = 'viii_paragraph_right',
                   viii_data(
                     font_color = theme$viii_font_color,
                     font_family = theme$font_family))),
             fluidRow(
               # paragraph remarks
               div(class = 'viii_paragraph_right',
                   viii_remarks(
                     font_color = theme$viii_font_color,
                     font_family = theme$font_family))),
             fluidRow(
               # paragraph extensions
               div(class = 'viii_paragraph_right',
                   viii_extensions(
                     font_color = theme$viii_font_color,
                     font_family = theme$font_family)))
             ))
    )
              
  )
}

######### section VIII SERVER function

section_VIII_server <- function(input, output, session) {
  ns <- session$ns
}

