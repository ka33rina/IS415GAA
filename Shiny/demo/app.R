pacman::p_load(shiny, sf, tidyverse, bslib, tmap)

hunan <- st_read(dsn= "data/geospatial", 
                 layer = "Hunan")
data <- read_csv("data/aspatial/Hunan_2012.csv")
hunan_data <- left_join(hunan, data,
                         by = c("County" = "COUNTY"))

ui <- fluidPage(
  titlePanel("Choropleth Mapping"), 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'variable',
                  label = "Mapping Variable",
                  choices = list("Gross Domestic Product, GDP"= "GDP",
                                 "Gross Domestic Product Per Capita"= "GDPPC",
                                 "Output Industry Output" = "GIO",
                                 "Output Value of Agriculture" = "OVA",
                                 "Output value of Service" = "OVS"),
                  selected = "GDPPC"),
      sliderInput(inputId = "classes",
                  label = "Number of classes",
                  min = 5, 
                  max = 10,
                  value = c(6))
    ),
    mainPanel(
      plotOutput("mapPlot",
                 width = "100%",
                 height = 400)
    )
  )
)

server <- function(input, output){
  output$mapPlot <- renderPlot({
    tmap_options(check.and.fix = TRUE)+
      tm_shape(hunan_data)+
      tm_fill(input$variable,
              n=input$classes,
              style = "quantile",
              palette = blues9)+
      tm_borders(lwd = 0.1, alpha = 1)
  })
}

shinyApp(ui = ui, server = server)