# Section iv 

# load section functions
source("./functions/f_iv_plot.R")
source("./functions/f_iv_legend.R")
source("./functions/f_iv_html_table.R")
source("./functions/f_iv_html_specifications.R")

# load section data
data_iv_6 <- readRDS('data/IV_6.rds')
data_iv_7 <- readRDS('data/IV_7.rds')
data_iv_75 <- readRDS('data/IV_75.rds')


# Function section iv User Interface

section_IV_ui <- function(id) {
  ns <- NS(id)
  
  pageSection(
    center = T,
    menu = "comparing_fields",
    class = 'btnFinalizeProjectInformation',
    tags$style(HTML(iv_html_specifications(
      bg_color = theme$iv_bg_color,
      active_color = theme$iv_active_input_color,
      font_family = theme$font_family,
      font_color = theme$iv_font_color
    ))),
    

    # header
    fluidRow(
      h3("Comparing Different Fields"),
      h5("One square represents 1%"),
      style = paste0('color:', theme$iv_font_color)),
    
    # selecting field
    fluidRow(
      # br(),
      # content: dropdown menu selecting field for first plot
      column(2, offset = 2, 
             align = 'center',
             fluidRow(
               div(class = 'pickerinput_iv',
                   pickerInput(
                     inputId = ns('variables_waffle_chart_1'),
                     choices = dictionary_ext,
                     selected = 'all_fields',
                     inline = F,
                     multiple = FALSE,
                     width = '90%',
                     options = list(
                       `live-search` = TRUE,
                       size = 21,
                       style = 'btn-pick')
                     )
             ))
      ),
      
      
      # content: dropdown menu selecting field for second plot
      column(2, 
             align = 'center',
             fluidRow(
               div(class = 'pickerinput_iv',
                   pickerInput(
                     inputId = ns('variables_waffle_chart_2'),
                     choices = dictionary_ext,
                     selected = 'marketing',
                     inline = F,
                     multiple = FALSE,
                     width = '90%',
                     options = list(
                       `live-search` = TRUE,
                       size = 21,
                       style = 'btn-pick')
                     )
             ))
      ),
      
      # content: dropdown menu selecting field for third plot
      column(2, 
             align = 'center',
             fluidRow(
               div(class = 'pickerinput_iv',
                   pickerInput(
                     inputId = ns('variables_waffle_chart_3'),
                     choices = dictionary_ext,
                     selected = 'finance',
                     inline = F,
                     multiple = FALSE,
                     width = '90%',
                     options = list(
                       `live-search` = TRUE,
                       size = 21,
                       style = 'btn-pick')
                     )
             ))
      ),
      
      # content: dropdown menu selecting field for fourth plot
      column(2, 
             align = 'center',
             fluidRow(
               div(class = 'pickerinput_iv',
                   pickerInput(
                     inputId = ns('variables_waffle_chart_4'),
                     choices = dictionary_ext,
                     selected = 'gender_studies',
                     inline = F,
                     multiple = FALSE,
                     width = '90%',
                     options = list(
                       `live-search` = TRUE,
                       size = 21,
                       style = 'btn-pick')
                    )
             ))
      )
    ),
    
    # content: plots inclusive legend
    fluidRow(
      column(8, offset = 2,
             plotOutput(outputId = ns('waffle_charts'), 
                        height = "320px",
             )
      )),
    
    # leave space
    br(),
    
    # content: tables
    fluidRow(column(2, offset = 2,
                    align = 'center',
                    htmlOutput(outputId = ns('table_waffle1'))),
             column(2,
                    align = 'center',
                    htmlOutput(outputId = ns('table_waffle2'))),
             column(2, 
                    align = 'center',
                    htmlOutput(outputId = ns('table_waffle3'))),
             column(2, 
                    align = 'center',
                    htmlOutput(outputId = ns('table_waffle4')))),
    
    # content: checkbox first authors and slider year selection 
    br(),
    fluidRow(column(2),
             
             # checkbox first authors
             column(1, 
                    div(class = "checkbox_iv",
                    checkboxInput(inputId = ns('first_authors_section4'), 
                                  label = 'Just first authors',
                                  value = c(0, 1),
                                  width = '80px')
             )),
             
             # slider input
             column(7, 
                    sliderInput(inputId = ns('year_section4'),
                                label = NULL,
                                min = 1960, 
                                max = 2020,
                                value = 2000,
                                step = 1,
                                width = '100%',
                                ticks = TRUE,
                                sep = ""
                                )
                    )
             
    ))
} 

section_IV_server <- function(input, output, session, threshold){
  ns <- session$ns
  
  # initilize reactive value (choosing threshold)
  iv_value <- reactiveValues(
    data = data_iv_6
  )
  
  #################### Uncomment when merged ##################################
  
  observeEvent(threshold(), {
    iv_value$data <- get(paste0('data_iv_', threshold()))
  }, ignoreInit = F)
  
  #############################################################################
  
  # output: create table (4 in total)
  # check value from checkbox regarding first author for each table individually
  output$table_waffle1 <- renderText({
    if (input$first_authors_section4 == TRUE) {
      first_author_input = 1
    }
    else {
      first_author_input = 0
    }
    table_waffle1 <- html_table_section4(data = iv_value$data, 
                                         dict = dictionary_ext,
                                         field = input$variables_waffle_chart_1,
                                         year_input = input$year_section4,
                                         first_author_input = first_author_input,
                                         content_bg_color = theme$iv_content_bg_color,
                                         font_color = theme$iv_font_color)
  })
  
  output$table_waffle2 <- renderText({
    if (input$first_authors_section4 == TRUE) {
      first_author_input = 1
    }
    else {
      first_author_input = 0
    }
    table_waffle1 <- html_table_section4(data = iv_value$data, 
                                         dict = dictionary_ext,
                                         field = input$variables_waffle_chart_2,
                                         year_input = input$year_section4,
                                         first_author_input = first_author_input,
                                         content_bg_color = theme$iv_content_bg_color,
                                         font_color = theme$iv_font_color)
  })
  
  output$table_waffle3 <- renderText({
    if (input$first_authors_section4 == TRUE) {
      first_author_input = 1
    }
    else {
      first_author_input = 0
    }
    table_waffle1 <- html_table_section4(data = iv_value$data, 
                                         dict = dictionary_ext,
                                         field = input$variables_waffle_chart_3,
                                         year_input = input$year_section4,
                                         first_author_input = first_author_input,
                                         content_bg_color = theme$iv_content_bg_color,
                                         font_color = theme$iv_font_color)
  })
  
  output$table_waffle4 <- renderText({
    if (input$first_authors_section4 == TRUE) {
      first_author_input = 1
    }
    else {
      first_author_input = 0
    }
    table_waffle1 <- html_table_section4(data = iv_value$data, 
                                         dict = dictionary_ext,
                                         field = input$variables_waffle_chart_4,
                                         year_input = input$year_section4,
                                         first_author_input = first_author_input,
                                         content_bg_color = theme$iv_content_bg_color,
                                         font_color = theme$iv_font_color)
  })
  
  
  # output: create plots and combine them with grid.arrange, add extern legend
  output$waffle_charts <- renderPlot({
    
    # check value from checkbox regarding first author
    if (input$first_authors_section4 == TRUE) {
      first_author_input = 1
    }
    else {
      first_author_input = 0
    }
    # create legend
    legend_iv <- iv_get_legend(iv_value$data, 
                               content_bg_color = theme$iv_content_bg_color,
                               graph_colors = theme$iv_graph_colors,
                               font_color = theme$iv_font_color)
    # arrange subplots, add legend
    subplot_section4 <- grid.arrange(
      arrangeGrob(
        plot_geom_waffle_chart(data = iv_value$data,
                               fields = input$variables_waffle_chart_1,
                               year_input = input$year_section4,
                               first_author_input,
                               content_bg_color = theme$iv_content_bg_color,
                               graph_colors = theme$iv_graph_colors
        ),
        plot_geom_waffle_chart(data = iv_value$data,
                               fields = input$variables_waffle_chart_2,
                               year_input = input$year_section4,
                               first_author_input,
                               content_bg_color = theme$iv_content_bg_color,
                               graph_colors = theme$iv_graph_colors),
        plot_geom_waffle_chart(data = iv_value$data,
                               fields = input$variables_waffle_chart_3,
                               year_input = input$year_section4,
                               first_author_input,
                               content_bg_color = theme$iv_content_bg_color,
                               graph_colors = theme$iv_graph_colors),
        plot_geom_waffle_chart(data = iv_value$data,
                               fields = input$variables_waffle_chart_4,
                               year_input = input$year_section4,
                               first_author_input,
                               content_bg_color = theme$iv_content_bg_color,
                               graph_colors = theme$iv_graph_colors),
        ncol = 4),
      legend_iv, nrow = 2, heights = c(10,1)
    )
    
    ggdraw(subplot_section4) + theme(plot.background = element_rect(fill = theme$iv_content_bg_color, 
                                                                    colour = theme$iv_content_bg_color))
    
  })
}
