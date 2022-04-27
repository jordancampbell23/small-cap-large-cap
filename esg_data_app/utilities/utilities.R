# UI
text_card <- function(..., header = NULL) {
  div(
    class = "card",
    style = "margin: 0px;",
    header, 
    div(class = "card-content", ..., style = "background-color: #fff; margin-top: 20px;")
  )
}

data_card <- function(..., header = NULL) {
  div(
    class = "card",
    style = "margin: 0px;",
    header, 
    div(class = "card-content", ..., style = "background-color: #fff; margin-top: 10px;", 
        align = "left")
  )
}


# Server

geom_return <- function(x){
  avg_return <- prod(1+x)^(1/length(x)) - 1
  return(avg_return)
}
