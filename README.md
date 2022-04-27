**Materials**

- [**App Link**](https://reason.shinyapps.io/esg_data_app/)

- **Code (see files above)**

- **Pre-Work:**
  - **Data (run the EDA code)**
    - Look through and run the EDA file to get a sense of the data
  - **Shiny (check out the following code and documentation)**
    - Open up the utilities folder (we're only utilizing the data_card() function)
    - [conditionalPanel](https://shiny.rstudio.com/reference/shiny/1.6.0/conditionalPanel.html)
    - pickerInput
  - **echarts4r (inspect the chart code)**
    - While the R version [website](https://echarts4r.john-coene.com/) contains good documentation, a lot of the inputs in the current app were modified based on interpreting the JavaScript [documentation](https://echarts.apache.org/en/option.html#title) in R.
    
  - ***Challenge #1:***
    - Add or alter one of the views
      - Ideas: (1) Change the density plots to bar plots that compare total or average ESG scores
      - Generate pie charts of the indices by sector
  - ***Challenge #2:***
    - Add some brief explanatory text to guide the user and identify a few key insights. A couple sentences will do. You can use observations about how the title is formatted to position/align text.
    - Shiny tags documentation
  - ***CSS Challenge:***
    - Go to [Google Fonts](https://fonts.google.com/) and select your favorite font and replace &#39;Open Sans&#39; in the style.css file. Does it show up in the app?
