library(shiny)
library(graphics)
library(leaflet)
library(rgdal)
library(shinyjs)

# Define server logic 
shinyServer(function(input, output) {
  
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
  
  
  
  
})