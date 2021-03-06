#test App

library(shiny)
library(shinythemes)
library(leaflet)
library(shinyjs)
library(graphics)
library(rgdal)

shinyApp(

#UI functions  
  ui = fluidPage(
    ########################   
    
    #application theme
    theme = shinytheme("flatly"),
    
    # Application title
    titlePanel("Tree Species Distribution Explorer"),
    
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
                           "Sassafrass" = "sassafrass",
                           "Texas Hercules Club" = "hercules",
                           "Baldcypress" = "cypress",
                           "Florida Torreya Pine" = "torreya",
                           "American Elm" = "elm",
                           "Joshua Tree" = "joshua",
                           "Poison Sumac" = "sumac"                    
                         ),
                         selected = "sassafrass"
             ),#end options
             
             
             #data source
             tags$a(href = "http://esp.cr.usgs.gov/data/little/", "Data Source: U.S. Geological Survey", style = "color:#000080")
             
      ),#end column
      
      
      #column 2
      column(4,
             #color chooser
             colourInput("col", label = h3("Choose Display Options"), "008000", palette = "limited"),
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
    
    ########################   
  ),#end fluid page
  
  
  
#server functions  
  server = function(input, output) {
  ########################  
    
  #read shape file in current directory. 
  #all shape file component files must be present
  #shape<-readOGR(dsn = 'C:/path',layer = 'shapefileName')
  shapeSassafrass <-readOGR(dsn = 'shapeFiles/sassalbi',layer = 'sassalbi')
  shapeHercules   <-readOGR(dsn = 'shapeFiles/zanthirs',layer = 'zanthirs')
  shapeCypress    <-readOGR(dsn = 'shapeFiles/taxodist',layer = 'taxodist')
  shapeTorreya    <-readOGR(dsn = 'shapeFiles/torrtaxi',layer = 'torrtaxi')
  shapeElm        <-readOGR(dsn = 'shapeFiles/ulmuamer',layer = 'ulmuamer')
  shapeJoshua     <-readOGR(dsn = 'shapeFiles/yuccbrev',layer = 'yuccbrev')
  shapeSumac      <-readOGR(dsn = 'shapeFiles/toxivern',layer = 'toxivern')
  
  #set up the output plot
  output$plot <- renderLeaflet({
    
    
    #access the button to make this code execute when button is pushed
    input$mapButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
      
      #get user-selected color
      iCol<-input$col 
      
      #get user-selected opacity
      iAlpha<-input$alpha
      
      
      #get user-selected option
      dataSelected<-input$speciesCheck
      print(dataSelected)
      
      if(dataSelected=="sassafrass"){
        output$data <- renderText({paste("Distribution of Sassafrass (Sassafrass albidum)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeSassafrass), weight=2, color=iCol, fillOpacity = iAlpha)
      }
      
      else if(dataSelected=="hercules"){
        output$data <- renderText({paste("Distribution of Texas Hercules club (Zanthoxylum hirsutum)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeHercules), weight=2, color=iCol, fillOpacity = iAlpha)
      }
      
      else if(dataSelected=="cypress"){
        output$data <- renderText({paste("Distribution of Baldcypress (Taxodium distichum)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeCypress), weight=2, color=iCol, fillOpacity = iAlpha)
      }
      
      else if(dataSelected=="torreya"){
        output$data <- renderText({paste("Distribution of Florida Torreya Pine (Torreya taxifolia)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeTorreya), weight=2, color=iCol, fillOpacity = iAlpha)
      }
      
      else if(dataSelected=="elm"){
        output$data <- renderText({paste("Distribution of American Elm (Ulmus americana)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeElm), weight=2, color=iCol, fillOpacity = iAlpha)
      }
      
      else if(dataSelected=="joshua"){
        output$data <- renderText({paste("Distribution of Joshua Tree (Yucca brevifolia)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeJoshua), weight=2, color=iCol, fillOpacity = iAlpha)
      }
      
      else if(dataSelected=="sumac"){
        output$data <- renderText({paste("Distribution of Poison Sumac (Toxicodendron vernix)")})
        leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeSumac), weight=2, color=iCol, fillOpacity = iAlpha)
      }      
      
    })#end isolation for button
    
    
  }) #end render plot
    
    
    
    
    
  ########################   
  },#end server

#app options
  options = list(height = 600, width = 500)
)#end app