# Section iii 

# load section functions
source("./functions/f_iii_bargraph.R")
source("./functions/f_iii_html_specifications.R")

# load section data
data_iii_6 <- readRDS('data/III_6.rds')
data_iii_7 <- readRDS('data/III_7.rds')
data_iii_75 <- readRDS('data/III_75.rds')


# Function section iv User Interface

section_III_ui <- function(id) {
  ns <- NS(id)
  
  pageSection(
    center = T,
    menu = "gender_distribution_overview",
    class = 'btnFinalizeProjectInformation',
    tags$style(HTML(iii_html_specifications(
      active_input_color = theme$iii_active_input_color,
      inactive_input_color = theme$iii_inactive_input_color,
      text_input_color = theme$iii_text_input_color,
      bg_color = theme$iii_bg_color,
      font_family = theme$font_family))),
    
    # header
    fluidRow(
      h3("Gender Distribution Overview")),
    
    # selecting field
    fluidRow(
      br(),
      
      # content: checkbox first authors
      column(
        1,
        offset = 4,
        div(class = "checkbox_iii", 
            checkboxInput(
          inputId = ns('first_authors_section3'),
          label = "Just first authors",
          value = c(0, 1),
          width = "80px"
        )
            )
        
      ),
      
      # content: selecting field
      column(2,
             align = 'center',
             fluidRow(
               div(class = 'pickerinput_iii',
                   pickerInput(
                     inputId = ns('var_sect3'),
                     choices = dictionary_ext,
                     selected = 'all_fields',
                     inline = F,
                     multiple = FALSE,
                     width = '100%',
                     options = list(
                       `live-search` = TRUE,
                       size = 21,
                       style = 'btn-picklight'
                     )
               ))
             ))
      ),
    
    # content: plot
    fluidRow(column(
      8,
      offset = 2,
      plotlyOutput(outputId = ns('plot_iii'))),
      column(2)
    )
  )
}


section_III_server <- function(input, output, session, threshold){
  ns <- session$ns
  
  # initilize reactive value (choosing threshold)
  iii_value <- reactiveValues(
    data = data_iii_6
  )
  
  #################### Uncomment when merged ##################################
  
  observeEvent(threshold(), {
    iii_value$data <- get(paste0('data_iii_', threshold()))
  }, ignoreInit = F)
  
  #############################################################################
  
    # output: create plot
    output$plot_iii <- renderPlotly({
      
      # check value from checkbox regarding first author
      if (input$first_authors_section3 == TRUE) {
        first_author_input = 1
      }
      else {
        first_author_input = 0
      }
      
      # create plot
      plot_iii <- iii_barplot(
        data = iii_value$data,
        field_input = input$var_sect3,
        first_authors_input = first_author_input,
        content_bg_color = theme$iii_content_bg_color,
        active_input_color = theme$iii_active_input_color,
        inactive_input_color = theme$iii_inactive_input_color,
        graph_colors = theme$iii_graph_colors,
        font_color = theme$iii_font_color,
        font_family = theme$font_family
      )
    })

}