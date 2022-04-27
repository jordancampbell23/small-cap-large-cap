library(shiny)
library(tidyverse)
library(echarts4r)
library(shinycssloaders)
library(shinyWidgets)

source("utilities/utilities.R")
options(spinner.color = "#ff6633", spinner.size = 1, spinner.type = 8)

df <- read_csv("sp500_russell2000.csv")
sector_choices <- df$Sector |> unique()


ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  fluidRow(
    style = "margin: 0; height: 40%",
    column(
      width = 12,
      style = "height: 100%; padding-top: 0px",
      
      
      div(
        align = "center",
        style = "font-family: 'Open Sans', sans-serif; font-weight: 800;",
        radioGroupButtons(
          inputId = "chart_display",
          label = "",
          choices = c("Index - Scatter",
                      "Sectors - Scatter",
                      "Index - Density"),
          checkIcon = list(yes = icon("ok", lib = "glyphicon"))
        )),
      
      data_card(
        style = "margin: 0",
        conditionalPanel(
          condition = "input.chart_display == 'Index - Scatter'",
          fluidRow(
            column(3),
            column(6,
                   align = "center",
                   h1("Index - Scatter")
            ),
            column(3)
          ),
          shinycssloaders::withSpinner(echarts4rOutput("chart_1", height = "75vh"))
        ),
        conditionalPanel(
          condition = "input.chart_display == 'Sectors - Scatter'",
          fluidRow(
            column(3),
            column(6,
                   align = "center",
                   h1("Sectors - Scatter")
            ),
            column(3)
          ),
          shinycssloaders::withSpinner(echarts4rOutput("chart_2", height = "75vh"))
        ),
        conditionalPanel(
          condition = "input.chart_display == 'Index - Density'",
          fluidRow(
            column(3),
            column(6,
                   align = "center",
                   h1("Index - Density")
                   ),
            column(3,
                   align = "right",
                   div(
                     style = "margin: 5px;",
                   pickerInput("sector_filter",
                               choices = sector_choices,
                               selected = "Consumer Staples",
                               multiple = T,
                               options = list(`actions-box` = TRUE),
                   )
                   ))
          ),
          shinycssloaders::withSpinner(echarts4rOutput("chart_3", height = "75vh"))
        ))
      
    )
  )
  
  
  
)

server <- function(input, output, session) {
  
  
  output$chart_1 <- echarts4r::renderEcharts4r({
    
    df |>
      group_by(Index) |>
      e_charts(MarketCap) |>
      e_scatter(ESG,
                symbolSize = 6,
                bind = Symbol) |>
      e_x_axis(type = "log", formatter = htmlwidgets::JS("function (value) {return '$' +echarts.format.addCommas(value / 1000000) + ' M'}")) |>
      e_tooltip(
        formatter = htmlwidgets::JS("
      function(params){
        return('<strong>' + params.name + 
                '</strong><br />Market Cap: $' + echarts.format.addCommas(params.value[0].toFixed(0)) + 
                '<br />ESG Rating: ' + (params.value[1]).toFixed(1)) 
                }
    ")
      ) |>
      e_theme_custom("echarts_theme.json")
    
    
  })
  
  output$chart_2 <- echarts4r::renderEcharts4r({
    
    
    
    df |>
      group_by(Sector) |>
      e_charts(MarketCap) |>
      e_scatter(ESG,
                symbolSize = 8,
                emphasis = list(focus = "series"),
                bind = Symbol) |>
      e_x_axis(type = "log", formatter = htmlwidgets::JS("function (value) {return '$' +echarts.format.addCommas(value / 1000000) + ' M'}")) |>
      e_tooltip(
        formatter = htmlwidgets::JS("
      function(params){
        return('<strong>' + params.name + 
                '</strong><br />Market Cap: $' + echarts.format.addCommas(params.value[0].toFixed(0)) + 
                '<br />ESG Rating: ' + (params.value[1]).toFixed(1)) 
                }
    ")
      ) |>
      e_legend(orient = 'vertical', left = "1%", top = "10%") |>
      e_theme_custom("echarts_theme.json") |>
      e_grid(left = "20%")
    
    
  })
  
  output$chart_3 <- echarts4r::renderEcharts4r({
    
    
    df |>
      filter(Sector %in% input$sector_filter) |>
      group_by(Index) |>
      e_charts() |>
      e_density(ESG,
                symbol = "none",
                smooth = F) |>
      e_y_axis(axisLabel = list(show = F)) |>
      e_x_axis(name = 'ESG Score',
               nameLocation = "middle",
               min = 0,
               max = 100,
               nameTextStyle = list(
        color = "#333",
        fontSize = 14,
        fontStyle = 'bold',
        padding = c(10, 0, 0, 0))) |>
      e_theme_custom("echarts_theme.json")
    
    
  })
  
  
}

shinyApp(ui, server)


