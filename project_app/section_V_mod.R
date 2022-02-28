
# load section functions
source('functions/f_v_plotly_gender_gap.R')
source('functions/f_v_table.R')
source('functions/f_v_html_specifications.R')


# load section data
data_v_6 <- readRDS('data/V_6.rds')
data_v_7 <- readRDS('data/V_7.rds')
data_v_75 <- readRDS('data/V_75.rds')


############# section V UI function

section_V_ui <- function(id) {
  ns <- NS(id)
  
  pageSection(
    center = T,
    menu = "female_male_ratio",
    class = 'btnFinalizeProjectInformation',
    # styling
    tags$style(HTML(v_html_specifications(
      bg_color = theme$v_bg_color,
      active_color = theme$v_active_input_color,
      inactive_color = theme$v_inactive_input_color,
      font_family = theme$font_family,
      font_color = theme$v_font_color,
      font_size = theme$font_size
    ))),
    
    fluidRow(
      # header
      h3('Comparison Between Research Fields Over Time',
         style = paste0('color:', theme$v_font_color)),
      br()),
    fluidRow(
      # leave space
      column(1),
      # content: plot
      column(10,
             div(class = 'v_plot',
                 plotlyOutput(ns('v_gender_gap'),
                              height = '40vh'))
      ),
      # leave space
      column(1)),
    fluidRow(
      # leave space
      column(1),
      # content: table all authors
      column(5, align = 'center',
             div(class = 'v_left_table',
                 htmlOutput(ns('v_table_all_gap')))),
      # content: table first authors
      column(5, align = 'center',
             div(class = 'v_right_table',
                 htmlOutput(ns('v_table_first_gap'))))
    ),
    fluidRow(
      # leave space
      column(1),
      # input: select fields to show in graph
      column(10,
             checkboxGroupButtons(
               inputId = ns('v_variables_gap'),
               choices = dictionary,
               selected = c('marketing',
                            'finance',
                            'economics_and_econometrics'),
               individual = T,
               direction = 'vertical',
               status = 'unchecked',
               justified = T
             ),
             # warning message for reaching the maximum number of fields
             em(htmlOutput(ns('v_warning'))))
    )
  )
}


############### section V SERVER function

section_V_server <- function(input, output, session, threshold) {
  ns <- session$ns
  
  ############# initilize reactive values
  #############################################################################
  
  v_values <- reactiveValues(
    click = 2000,
    data = data_v_6
  )
  
  ############ user interactions
  #############################################################################
  
  # if user chooses new decision threshold
  observeEvent(threshold(), {
    v_values$data <- get(paste0('data_v_', threshold()))
  }, ignoreInit = F)

  # extract click data if clicked
  observeEvent(
    event_data('plotly_click', source = 'V')$x, {
      v_values$click <- isolate(event_data('plotly_click', source = 'V')$x)
    },
    ignoreInit = T, ignoreNULL = T
  )
  
  # adjust click data if no research field has been selected
  observeEvent(
    input$v_variables_gap, {
      if (is.null(input$v_variables_gap)) {
        v_values$click <- NULL
      }
    },
    ignoreInit = T, ignoreNULL = F
  )
  
  # reactive input: selected research fields; reaching maximum
  observeEvent(
    input$v_variables_gap, {
      if (length(input$v_variables_gap) >= 4){
        # adapt input: research fields
        updateCheckboxGroupButtons(
          session,
          inputId = 'v_variables_gap',
          disabledChoices = unname(
            dictionary[!(dictionary %in% input$v_variables_gap)]))
        # output: create warning message
        output$v_warning <- renderText({
          'You reached the maximum number of selected fields.'
        })
      } else {
        # adapt input: research fields
        updateCheckboxGroupButtons(
          session,
          inputId = 'v_variables_gap',
          disabledChoices = NULL)
        # output: create warning message
        output$v_warning <- renderText({
          'You can choose up to 4 research fields.'
        })
      }
    }, ignoreInit = F)
  
  
  ############# outputs
  #############################################################################
  
  # output: create plot with subplots
  output$v_gender_gap <- renderPlotly({
    subplot(list(
      v_plotly_gender_gap(
        data = v_values$data %>% filter(first_authors == 0),
        fields = input$v_variables_gap,
        click = v_values$click,
        legend = F,
        font_family = theme$font_family,
        font_size = theme$font_size,
        bg_color = theme$v_content_bg_color,
        font_color = theme$v_font_color,
        graph_colors = theme$v_graph_colors),
      v_plotly_gender_gap(
        data = v_values$data %>% filter(first_authors == 1),
        fields = input$v_variables_gap,
        click = v_values$click,
        legend = F,
        font_family = theme$font_family,
        font_size = theme$font_size,
        bg_color = theme$v_content_bg_color,
        font_color = theme$v_font_color,
        graph_colors = theme$v_graph_colors)
    ), shareY = T, titleX = T, titleY = T)
  })
  
  # output: create table for all authors
  output$v_table_all_gap <- renderText({
    v_table(
      data = v_values$data %>% filter(first_authors == 0),
      fields = input$v_variables_gap,
      click = v_values$click,
      dict = dictionary,
      font_size = theme$font_size + 2,
      bg_color = theme$v_content_bg_color,
      font_color = theme$v_font_color)
  })
  
  # output: create table for first authors
  output$v_table_first_gap <- renderText({
    v_table(
      data = v_values$data %>% filter(first_authors == 1),
      fields = input$v_variables_gap,
      click = v_values$click,
      dict = dictionary,
      font_size = theme$font_size + 2,
      bg_color = theme$v_content_bg_color,
      font_color = theme$v_font_color)
  })
}
