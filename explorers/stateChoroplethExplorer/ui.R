#This code creates a choropleth from user-specified data

library(shiny)
library(shinythemes)
library(leaflet)

#User Interface layout
shinyUI(fluidPage(
  #application theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("State Data Explorer"),
  
  #create a row for elements
  fluidRow(
    #add one column to the row, width of 12  (full width)
    column(12,leafletOutput("plot", height=600)
           )),
  
  fluidRow(
    column(12,textOutput("data"), height=100)
    
    ),
       
  fluidRow(
    #column 1
    column(2,
         
         #data source
         tags$a(href = "http://www.census.gov/compendia/statab/cats/agriculture/farms_and_farmland.html", "Source: United States Census Bureau", style = "color:#000080"),
         
         #Data options 
         selectInput("dataSelection", label = h3("Select a Data Set"), 
                choices = list("Farm Number (Thousands) by State" = "A", "Farm Acreage (Millions) by State" = "B", "Acreage per Farm by State" = "C"), selected = "A")
    
    ),#end column
    
    
    #column 2
    column(3,
           #color chooser
           selectInput("paletteCheck", 
                       label = h3("Select a Color Palette"), 
                       choices = list(
                         "Greys" = "Greys",
                         "Reds" = "Reds",
                         "Blues" = "Blues",
                         "Greens" = "Greens",
                         "Oranges" = "Oranges",
                         "Purples" = "Purples"
                       ),
                       selected = "Greens"
           ),#end options
           
           sliderInput("colorLevels",
                       "Color Levels",
                       min = 2,
                       max = 8,
                       value = 8,
                       step = 1
           ),
           
           sliderInput("alpha",
                       "Opacity",
                       min = 0,
                       max = 1,
                       value = 0.6,
                       step = 0.1
           )         
           
           
    ),#end column
    
    column(3, 
           
           tags$div(class = "header", checked = NA,
                    tags$h3("Plot the Data")
                    
           ),
           
           #action button
           actionButton("mapButton", label = "Map it!")
           
           )#end column
    
   )#end row
  

))#end page
