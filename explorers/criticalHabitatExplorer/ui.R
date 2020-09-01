#This code creates a species distribution from government shape file data

library(shiny)
library(shinythemes)
library(leaflet)
library(shinyjs)

#User Interface layout
shinyUI(fluidPage(
  #application theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Species Distribution Explorer"),
  
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
    column(3,
       selectInput("speciesCheck", 
       #radioButtons("speciesCheck",              
                    label = h3("Select a Species"), 
                    choices = list(
                                   "Purple Bankclimber" = "purple", 
                                   "Loggerhead Sea Turtle" = "loggerhead", 
                                  #"American Crocodile" = "croc",
                                   "Frosted Flatwoods Salamander" = "salamander",
                                   "West Indian Manatee" = "manatee",
                                  #"Everglade Snail Kite" = "kite",
                                   "Johnson's Seagrass" = "grass"
                                   ),
                     selected = "purple"
                     ),#end options
       
      
       #data source
       tags$a(href = "http://ecos.fws.gov/crithab/html/politicalFrameset.html", "Data Source: US FWS", style = "color:#000080")
       
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






