library(shiny)
library(graphics)
library(leaflet)
library(rgdal)
library(shinyjs)
library(ggmap)

# Define server logic 
shinyServer(function(input, output) {
  
  #create a vector containing the column names from the data set
  columns <- c("DeployID","County",  "DeployDate","DeploymentName","Description","PrimaryMaterial","Tons","Relief","Depth","Jurisdiction","Coast","LatDM","LongDM","latitudes","longitudes","LocationAccuracy")
  
  #set up a data frame to hold the data and use the column name vector for headers
  data <- read.csv("reefs.csv", col.names = columns, stringsAsFactors = FALSE)
  
  #define variables of interest and describe their input location
  reefID<-data$DeployID
  reefDesc<-data$Description
  reefName<-data$DeploymentName
  reefMat<-data$PrimaryMaterial
  lat<-data$latitudes
  lng<-data$longitudes
  
  #create a data frame with the variables
  dfLeaflet<-data.frame(reefID, reefDesc, reefName, reefMat, lat, lng)
  
  
  
  #set up the output plot
  output$plot <- renderLeaflet({
    
    
    #access the button to make this code execute when button is pushed
    input$mapButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
    
    #get user-selected color
    iCol<-input$col
    
    #get user-selected diameter
    iDiameter<-input$diameter
    
    #get user-selected opacity
    iAlpha<-input$alpha
      
    output$data <- renderText({paste("Artificial Reef Locations")})
    
    #Draw the map, add the appropriate map tiles, and add pop up boxes with text
    leaflet(dfLeaflet) %>% addTiles() %>% addCircleMarkers(popup=dfLeaflet$reefMat, col=iCol, fillOpacity = iAlpha, radius=iDiameter)
    
    
    #leaflet() %>% addTiles() %>% addPolygons(data=subset(shapePurple), weight=2, color=iCol, fillOpacity = iAlpha)
        
    })#end isolation for button
    
    
  }) #end render plot
  
  
  
  
})