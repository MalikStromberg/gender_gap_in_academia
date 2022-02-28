# load section functions
source('functions/f_vii_html_specifications.R')
source('functions/f_vii_plot_data.R')
source('functions/f_vii_reset_plot_data.R')
source('functions/f_vii_plotly_impact.R')
source('functions/f_vii_table.R')
source('functions/f_vii_reset_table_data.R')
source('functions/f_vii_table_data_short.R')
source('functions/f_vii_update_table_page_choice.R')
source('functions/f_vii_script.R')
source('functions/f_vii_create_choices.R')

# initialize section variables
vii_button_style <- paste0(
  'background-color: ', theme$vii_active_input_color, ';
  color: ', theme$vii_bg_color, ';
  border: 0px;
  font-size: 11px;
  margin: 5px;,
  width: 12px;')

# read section data
data_vii_6 <- readRDS('data/VI_6.rds')
data_vii_7 <- readRDS('data/VI_7.rds')
data_vii_75 <- readRDS('data/VI_75.rds')
data_vii_dict_6 <- readRDS('data/VI_dict_6.rds')
data_vii_dict_7 <- readRDS('data/VI_dict_7.rds')
data_vii_dict_75 <- readRDS('data/VI_dict_75.rds')


########### section VII UI function

section_VII_ui <- function(id) {
  ns <- NS(id)
  window_size_id <- ns('window_size')
  
  pageSection(
    center = T,
    menu = 'maliks3',
    class = 'btnFinalizeProjectInformation',
    tags$head(tags$script(vii_script(id = window_size_id))),
    tags$style(HTML(vii_html_specifications(
      bg_color = theme$vii_bg_color,
      inactive_color = theme$vii_inactive_input_color,
      active_color = theme$vii_active_input_color,
      font_color = theme$vii_font_color,
      font_family = theme$font_family,
      text_input_color = theme$vii_text_input_color,
      text_input_font_color = theme$vii_text_input_font_color,
      font_size = theme$font_size
      ))),
    fluidRow(
      # header
      h3('Impact Factor and Gender Gap',
         style = paste0('color:', theme$vii_font_color))),
    fluidRow(
      column(1),
      column(3,
             align = 'center',
             fluidRow(
               div(class = 'picker_input',
                   div(class = 'vii_label',
                       # input: select field
                       pickerInput(
                         inputId = ns('vii_field'),
                         choices = dictionary_ext,
                         selected = 'all_fields',
                         label = 'Choose Research Field:',
                         inline = F,
                         width = '300px',
                         options = list(
                           `live-search` = TRUE,
                           size = 21,
                           style = 'btn-pick'),
                         choicesOpt = list(
                         content = "
                         <div style='font-weight: bold'>All Fields</div>
                         "))
               ))
             )
      ),
      column(2,
             align = 'center',
             fluidRow(
               div(class = 'vii_left',
                   div(class = 'vii_label',
                       # input: index to consider
                       radioGroupButtons(
                         inputId = ns("vii_plot_index"),
                         label = 'Impact Index:',
                         choices = c("SJR-Index" = 'sjr', 
                                     "H-Index" = 'h_index'),
                         selected = 'sjr',
                         status = "radio"
                         )
                    ))
                )
              ),
      column(5,
             align = 'center',
             br(),
             div(class = 'vii_center',
                 div(class = 'vii_right',
                     # input: term to search for in journal title in table
                     textInput(ns('vii_table_search'),
                               label = " ",
                               value = "",
                               width = NULL,
                               placeholder = 'Search Journals')
                  ))
              ),
      column(1)
      ),
    fluidRow(
      column(1),
      column(1,
             h5('Weights:',
             style = paste0('padding:10px;color:',
                            theme$vii_font_color))
             ),
       column(2,
              align = 'center',
              splitLayout(
                # input: weight for group 1 (upper)
                numericInput(ns('vii_weight1'),
                             '',
                             value = 1),
                # input: weight for group 2 (medium)
                numericInput(ns('vii_weight2'),
                             '',
                             value = 1),
                # input: weight for group 3 (lower)
                numericInput(ns('vii_weight3'),
                             '',
                             value = 1)
                )
                ),
        column(2,
               fluidRow(
                 div(class = 'vii_left',
                     div(class = 'vii_label',
                         # input: index to consider
                         radioGroupButtons(
                           inputId = ns("vii_weighting"),
                           label = 'Weighting:',
                           choices = c("Only Quantile" = 'quantile', 
                                       "With Impact" = 'index'),
                           selected = 'quantile',
                           status = "radio"
                           )
                      ))
                )),
        column(5,
               align = 'center',
               div(class = 'picker_input',
               div(class = 'vii_right',
                   # input: select graph for which data is displayed
                   pickerInput(
                     inputId = ns('vii_graph'),
                     choices = 'All',
                     selected = 'All',
                     inline = T,
                     width = '500px',
                     options = list(
                       style = 'btn-pick'))
                    ))
                ),
        column(1)
        ),
    fluidRow(
      column(1),
      column(1,
             h5('Quantiles:',
                style = paste0('padding:10px; color:',
                               theme$vii_font_color))
                ),
      column(2,
             align = 'center',
             # input: quantiles for groups separation
             sliderInput(
               ns('vii_quantile'),
               label = NULL,
               min = 0,
               max = 100,
               value = c(25, 50),
               width = '100%')
              ),
      column(2,
             align = 'center',
             br(),
             div(class = 'vii_left',
                 # input: action button for adding a trace with selected
                 # parameters
                 actionButton(ns('vii_add_trace'),
                              'Add Trace',
                              style = vii_button_style),
                 # input: action button to reset the graph
                 actionButton(ns('vii_clear'),
                              'Clear All',
                              style = vii_button_style))
              ),
      column(5,
             align = 'center',
             div(class = 'vii_right',
                 # choose year for which data is displayed
                 sliderInput(
                   ns('vii_year'),
                   label = NULL,
                   min = 1999,
                   max = 2019,
                   step = 1,
                   value = 2009,
                   width = '100%',
                   sep = '')
                  )
              )
        ),
    fluidRow(
      column(1),
      column(5,
             div(class = 'vii_left',
                 # output: plot with selected graphs
                 plotlyOutput(ns('vii_impact_plot'),
                              height = '50vh')
                 )
      ),
      column(5,
             align = 'center',
             div(class = 'vii_right_table',
             # output: table with data for selected graph and year
             htmlOutput(ns('vii_table'))
             ),
             # input: page number of table
             radioGroupButtons(
               inputId = ns("vii_page"),
               label = NULL,
               choices = 1,
               selected = 1,
               status = "page")
             ),
      column(1)
    )
  )
}


########## section VII SERVER function

section_VII_server <- function(input, output, session, threshold) {
  ns <- session$ns
  
  ########## initialize reactive values
  #############################################################################
  
  vii_values <- reactiveValues(
    data = data_vii_6,
    data_dict = data_vii_dict_6,
    plot = c(),
    table = c(),
    add_data = c(),
    table_short = c(),
    weights = c(),
    existing_labels = c(),
    table_choices = c(),
    click_year = 2009,
    table_rows = 12)
  
  ########## user interactions
  #############################################################################
  
  # if user chooses new decision threshold
  observeEvent(threshold(), {
    vii_values$data <- get(paste0('data_vii_', threshold()))
    vii_values$data_dict <- get(paste0('data_vii_dict_', threshold()))
  }, ignoreInit = F)
  
  # actions to execute, if user chooses to clear the graph
  observeEvent({input$vii_clear
    threshold()}, {
    # reset plot
    vii_values$plot <- isolate(
      vii_reset_plot_data(
        data = vii_values$data,
        dict = vii_values$data_dict))
    
    # adjust graphs to choose for table data
    updatePickerInput(session,
                      'vii_graph',
                      choices = 'All',
                      selected = 'All')
    
    updateTextInput(session,
                    'vii_table_search',
                    value = "")
    
    # reset table
    vii_values$table <- isolate(
      vii_reset_table_data(
        data = vii_values$data,
        dict = vii_values$data_dict))
  }, ignoreInit = F, ignoreNULL = F)
  
  # actions to execute, if the user chooses to add a plot trace
  observeEvent(input$vii_add_trace, {
    # make sure that user is not able to choose NA as weight1
    if (is.na(input$vii_weight1)) {
      updateNumericInput(session,
                         'vii_weight1',
                         value = 0)
    }
    
    # make sure that user is not able to choose NA as weight2
    if (is.na(input$vii_weight2)) {
      updateNumericInput(session,
                         'vii_weight2',
                         value = 0)
    }
    
    # make sure that user is not able to choose NA as weight3
    if (is.na(input$vii_weight3)) {
      updateNumericInput(session,
                         'vii_weight3',
                         value = 0)
    }
    
    # extract class weights
    vii_values$weights <- c(ifelse(is.na(input$vii_weight1),
                                   0,
                                   input$vii_weight1),
                            ifelse(is.na(input$vii_weight2),
                                   0,
                                   input$vii_weight2),
                            ifelse(is.na(input$vii_weight3),
                                   0,
                                   input$vii_weight3))

    # check if weights are valid
    if (any(as.numeric(vii_values$weights) != 0)) {
      # extract existing trace labels
      vii_values$existing_labels <- unique(vii_values$plot$label)
      # extract data for new trace
      vii_values$add_data <- isolate(
        vii_plot_data(
          data = vii_values$data,
          dict = vii_values$data_dict,
          new_trace = input$vii_quantile,
          selected_field = input$vii_field,
          index = input$vii_plot_index,
          weights = vii_values$weights,
          weighting = input$vii_weighting,
          existing_labels = vii_values$existing_labels))
      # add new data to existing plot data
      vii_values$plot <- bind_rows(vii_values$plot,
                                   vii_values$add_data$plot)
      # add data to existing table data
      vii_values$table <- bind_rows(vii_values$table,
                                    vii_values$add_data$table)
      # adjust graphs to choose for showing table data
      updatePickerInput(session,
                        'vii_graph',
                        choices = vii_values$plot$table_choices %>% unique(),
                        selected = input$vii_graph)
    }
  }, ignoreInit = T)
  
  # actions to execute, if user selects a year by clicking on the plot
  observeEvent(event_data('plotly_click', source = 'VII')$x, {
    # adjust selected year for table data
    updateSliderInput(session,
                      'vii_year',
                      min = 1999,
                      max = 2019,
                      value = event_data('plotly_click', source = 'VII')$x[1])
  }, ignoreInit = T)
  
  # actions to execute, if user selects a year by picker input
  observeEvent(input$vii_year, {
    vii_values$click_year <- input$vii_year
  }, ignoreInit = T)
  
  # actions to execute if table data is changed
  # year selection, graph selection, journal search, table page
  observeEvent({input$vii_year
    input$vii_graph
    input$vii_table_search
    input$vii_page
    input$window_size}, {
      
      # table resizing based on window size
      if (as.numeric(input$window_size[1]) >= 2500) {
        vii_values$table_rows <- max(round(
          (((as.numeric(input$window_size[2]) * 0.029) - 10)),
          0),
          1)
      } else if (as.numeric(input$window_size[1]) >= 1850) {
        vii_values$table_rows <- max(round(
          (((as.numeric(input$window_size[2]) * 0.025) - 7)),
          0),
          1)
      } else if (as.numeric(input$window_size[1]) >= 1650) {
        vii_values$table_rows <- max(round(
          (((as.numeric(input$window_size[2]) * 0.02) - 6)),
          0),
          1)
      } else {
        vii_values$table_rows <- max(round(
          (((as.numeric(input$window_size[2]) * 0.025) - 8)),
          0),
          1)
      }
      
      # update displayed table rows
      vii_values$table_short <- vii_table_data_short(
        data = vii_values$table,
        inp_year = as.numeric(vii_values$click_year),
        inp_graph = input$vii_graph,
        query = input$vii_table_search,
        nrows = vii_values$table_rows,
        page = as.numeric(input$vii_page))
      # update choices for table pages
      table_page <- vii_update_table_page_choice(
        table_nobs = vii_values$table_short$nobs,
        selected_page = as.numeric(input$vii_page),
        n_items = 15,
        nrows = vii_values$table_rows
      )
      # update input interface for table pages
      updateRadioGroupButtons(session,
                              inputId = 'vii_page',
                              choices = table_page$choices$choices,
                              status = 'page',
                              selected = table_page$selected,
                              disabledChoices = table_page$choices$disabled)
      
    })
  
  ########### outputs
  #############################################################################
  
  # output: plot with all user added traces
  output$vii_impact_plot <- renderPlotly({
    vii_plotly_impact(data = vii_values$plot,
                      click = as.numeric(vii_values$click_year),
                      font_family = theme$font_family,
                      font_size = theme$font_size,
                      bg_color = theme$vii_content_bg_color,
                      paper_bg_color = theme$vii_bg_color,
                      font_color = theme$vii_font_color,
                      graph_colors = theme$vii_graph_colors)
  })
  
  # output: table with selected year and trace
  output$vii_table <- renderText({
    vii_table(data = vii_values$table_short,
              bg_color = theme$vii_content_bg_color,
              font_color = theme$vii_font_color,
              font_size = theme$font_size + 1)
  })
}


