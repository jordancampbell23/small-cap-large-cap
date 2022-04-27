library(tidyverse)
library(echarts4r)

df <- read_csv("sp500_russell2000.csv")

str(df) # A function that gives an overview of the data type and summary of data

# This ESG data contains 6 columns:
#   - Symmbol (the stock's ticker)
#   - Name (the name of the stock)
#   - Index (name of the index of which the stock belongs)
#   - Sector (the sector: Communication Services, Consumer Discretionary, etc.)
#   - MarketCap (market capitalization)
#   - ESG (Enivronmental, Social, and Corporate Score)...note that this is real data,
#     monotonically transformed to anonymize the source. Higher 


# This data was pulled under the suspicion that small cap stocks (represented by
# Russell 2000) will have lower (worse) ESG scores than 
#
#

df_sp500 <- df |>
  filter(Index == "S&P 500")

df_r2000 <- df |>
  filter(Index == "Russell 2000")

t.test(df_sp500$ESG, df_r2000$ESG)


index_summary <- df |>
  group_by(Index) |>
  summarise(ESG_mean = mean(ESG, na.rm = T),
            ESG_75 = quantile(ESG, 0.75, na.rm = T),
            ESG_median = quantile(ESG, 0.5, na.rm = T),
            ESG_25 = quantile(ESG, 0.25, na.rm = T))



sector_index_summary <- df |>
  group_by(Index, Sector) |>
  summarise(ESG_mean = mean(ESG, na.rm = T),
            ESG_median = median(ESG, na.rm = T))



sector_summary <- df |>
  group_by(Sector) |>
  summarise(ESG_mean = mean(ESG, na.rm = T),
            ESG_median = median(ESG, na.rm = T))





df |>
  group_by(Index) |>
  e_charts(MarketCap) |>
  e_scatter(ESG,
            symbolSize = 6,
            bind = Symbol) |>
  e_x_axis(type = "log") |>
  e_tooltip(
    formatter = htmlwidgets::JS("
      function(params){
        return('<strong>' + params.name + 
                '</strong><br />Market Cap: ' + echarts.format.addCommas(params.value[0].toFixed(0)) + 
                '<br />ESG Rating: ' + (params.value[1]).toFixed(1)) 
                }
    ")
  ) |>
  e_theme_custom("echarts_theme.json") |>
  e_datazoom()




df |>
  group_by(Sector) |>
  e_charts(MarketCap) |>
  e_scatter(ESG,
            symbolSize = 6,
            emphasis = list(focus = "series"),
            bind = Symbol) |>
  e_x_axis(type = "log") |>
  e_tooltip(
    formatter = htmlwidgets::JS("
      function(params){
        return('<strong>' + params.name + 
                '</strong><br />Market Cap: ' + echarts.format.addCommas(params.value[0].toFixed(0)) + 
                '<br />ESG Rating: ' + (params.value[1]).toFixed(1)) 
                }
    ")
  ) |>
  e_legend(orient = 'vertical', left = "1%") |>
  e_theme_custom("echarts_theme.json") |>
  e_datazoom() |>
  e_grid(left = "20%")



df |>
  filter(Sector == "Consumer Staples") |>
  group_by(Index) |>
  e_charts() |>
  e_density(ESG,
            symbol = "none",
        smooth = F) |>
  e_y_axis(axisLabel = list(show = F)) |>
  e_x_axis(name = 'ESG Score', nameLocation = "middle", nameTextStyle = list(
    color = "#333",
    fontSize = 14,
    fontStyle = 'bold',
    padding = c(10, 0, 0, 0))) |>
  e_theme_custom("echarts_theme.json")

