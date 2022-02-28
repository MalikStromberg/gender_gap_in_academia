# load section functions
source('functions/f_ii_html_specifications.R')
source('functions/f_ii_plotly.R')

# create section variables


# read section data
data_ii <- readRDS('data/II.rds')


########## section II UI function

section_II_ui <- function(id) {
  ns <- NS(id)
  
  pageSection(
    center = T,
    menu = 'data_overview',
    class = 'btnFinalizeProjectInformation',
    # HTML / CSS stuff
    tags$style(HTML(ii_html_specifications(
      font_color = theme$ii_font_color,
      font_family = theme$font_family,
      active_color = theme$ii_active_input_color,
      inactive_color = theme$ii_inactive_input_color,
      bg_color = theme$ii_bg_color
      ))),
    verticalLayout(
      # header
      fluidRow(
        h3('Data Overview',
           style = paste0('color:',
                          theme$ii_font_color,
                          '; font-family:',
                          theme$font_family))),
      fluidRow(align = 'center',
               div(class = 'picker_input',
                   div(class = 'ii_label',
                       # input: select field
                       pickerInput(
                         inputId = ns('ii_field'),
                         choices = dictionary_ext,
                         selected = 'all_fields',
                         label = 'Choose Research Field:',
                         inline = F,
                         width = '300px',
                         options = list(
                           `live-search` = TRUE,
                           size = 'auto',
                           style = 'btn-pick'
                           ),
                         choicesOpt = list(
                             content = "
                             <div style='font-weight: bold'>All Fields</div>
                              ")
                     )))),
      fluidRow(
        column(1),
        column(5,
               align = 'center',
               div(class = 'ii_left',
                   # output: number of publications
                   plotlyOutput(ns('ii_plot_publications'),
                                height = '35vh'))),
        column(5,
               align = 'center',
               div(class = 'ii_right',
                   # output: number of journals
                   plotlyOutput(ns('ii_plot_journals'),
                                height = '35vh')))
        ),
      br(),
      fluidRow(
        column(1),
        column(5,
               div(class = 'ii_left',
                   # output: average number of authors per
                   # publication
                   plotlyOutput(ns('ii_plot_avg_authors'),
                                height = '35vh'))),
        column(5,
               div(class = 'ii_right',
                   # output: density graph of H-Index
                   plotlyOutput(ns('ii_plot_impact'),
                                height = '35vh')))
        )
      )
    )
}


############# section II SERVER function

section_II_server <- function(input, output, session) {
  ns <- session$ns
  
  ########### initialize reactive values
  #############################################################################
  
  ii_values <- reactiveValues(
    plots = c()
  )
  
  ########## user interactions
  #############################################################################
  
  # update plots if user chooses a new research field
  observeEvent(input$ii_field, {
    ii_values$plots <- ii_plotly(
      data = data_ii,
      selected_field = input$ii_field,
      colors = theme$ii_graph_colors,
      font_family = theme$font_family,
      font_size = theme$font_size,
      font_color = theme$ii_font_color,
      bg_color = theme$ii_content_bg_color,
      error_color = theme$ii_bg_color)
  }, ignoreInit = F)
  
  ########### outputs
  #############################################################################
  
  # output: number of publications
  output$ii_plot_publications <- renderPlotly({
    ii_values$plots$plot_publications
  })
  
  # output: number of journals
  output$ii_plot_journals <- renderPlotly({
    ii_values$plots$plot_journals
  })
  
  # output: average number of authors per publication
  output$ii_plot_avg_authors <- renderPlotly({
    ii_values$plots$plot_avg_authors
  })
  
  # output: density graph for H-Index
  output$ii_plot_impact <- renderPlotly({
    ii_values$plots$plot_impact
  })
}

