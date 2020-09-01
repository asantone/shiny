#This code displays artificial reef locations in Florida

library(shiny)
library(shinythemes)
library(leaflet)
library(shinyjs)

#User Interface layout
shinyUI(fluidPage(
  #application theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Artificial Reef Distribution Explorer"),
  
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
       tags$a(href = "http://myfwc.com/conservation/saltwater/artificial-reefs/", "Source: Florida Fish and Wildlife Conservation Commission", style = "color:#000080")
       
             ),#end column
    
    
    #column 2
    column(4,
           #color chooser
           colourInput("col", label = h3("Choose Display Options"), "000080", palette = "limited"),
           sliderInput("alpha",
                       "Opacity",
                       min = 0,
                       max = 1,
                       value = 0.8,
                       step = 0.1
           ),
           sliderInput("diameter",
                       "Point Diameter",
                       min = 0,
                       max = 20,
                       value = 5,
                       step = 1
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
  

  
  
  
##    )#end column
##  )#end row
))#end page






