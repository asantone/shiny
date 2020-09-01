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
  #myShape<-readOGR(".","american_crocodile-critical_habitat")
  shapePurple     <-readOGR(dsn = 'shapeFiles/Elliptoideus_sloatianus',layer = 'FCH_multiple_GA_FL_AL_20071115')
  shapeLoggerhead <-readOGR(dsn = 'shapeFiles/Caretta_caretta',layer = 'FCH_Caretta_caretta_20140710')
  #shapeCroc       <-readOGR(dsn = 'shapeFiles/Crocodylus_acutus',layer = 'american_crocodile-critical_habitat')
  shapeSalamander <-readOGR(dsn = 'shapeFiles/Ambystoma_cingulatum',layer = 'FCH_Ambystoma_cingulatum_20090210')
  shapeManatee    <-readOGR(dsn = 'shapeFiles/Trichechus_manatus',layer = 'ManateeCopy')
  #shapeKite       <-readOGR(dsn = 'shapeFiles/Rostrhamus_sociabilis_plumbeus',layer = 'everglades_snail_kite-critical_habitat')
  shapeGrass      <-readOGR(dsn = 'shapeFiles/Halophila_johnsonii',layer = 'john_sgrass_CH_FL_2003_po')
  
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
        
        if(dataSelected=="purple"){
          output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for the Purple Bankclimber, a type of freshwater mussel.")})
          leaflet() %>% addTiles() %>% addPolygons(data=subset(shapePurple), weight=2, color=iCol, fillOpacity = iAlpha)
        }
        
        else if(dataSelected=="loggerhead"){
          output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for the Loggerhead Sea Turtle.")})
          leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeLoggerhead), weight=2, color=iCol, fillOpacity = iAlpha)
        }
        
        #not functional    
        #else if(dataSelected=="croc"){
        #output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for the American Crocodile.")})
        #leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeCroc), weight=2, color=iCol, fillOpacity = iAlpha)
        #}
        
        else if(dataSelected=="salamander"){
          output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for the Frosted Flatwoods Salamander.")})
          leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeSalamander), weight=2, color=iCol, fillOpacity = iAlpha)
        }
        
        else if(dataSelected=="manatee"){
          output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for the West Indian Manatee.")})
          leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeManatee), weight=2, color=iCol, fillOpacity = iAlpha)
        }
        
        #not functional  
        #else if(dataSelected=="kite"){
        #  output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for the Everglade Snail Kite.")})
        #  leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeKite), weight=2, color=iCol, fillOpacity = iAlpha)
        #}
        
        else if(dataSelected=="grass"){
          output$data <- renderText({paste("U.S. Fish & Wildlife Service Critical habitat for Johnson's Seagrass.")})
          leaflet() %>% addTiles() %>% addPolygons(data=subset(shapeGrass), weight=2, color=iCol, fillOpacity = iAlpha)
        }
      
    
    })#end isolation for button
    
    
  }) #end render plot
  
  
  
  
})