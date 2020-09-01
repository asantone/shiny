library(shiny)
library(graphics)
library(leaflet)
library(rgdal)

# Define server logic 
shinyServer(function(input, output) {
  
  #read in custom data csv files containing data of interest per state
  customData<-read.csv(file="myVariable.csv")
  
  #get vector of the new values to add from the column of interest in the custom data
  farms1000<-customData$farms1000       #farm number by state
  acresPerFarm<-customData$acresPerFarm #acres per farm
  acresM<-customData$acresM             #acreage per state
  
  # From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
  states <- readOGR(dsn = 'cb_2014_us_state_20m', layer = 'cb_2014_us_state_20m', verbose = FALSE)

  #sort the rows alphabetically
  index<-order(states$NAME)  
  row.names(states)[index]  
  states<-states[index,]

  #add data to new column in data frame
  states$farms1000<-customData$farms1000
  states$acresPerFarm<-customData$acresPerFarm 
  states$acresM<-customData$acresM 

  #set up the output plot
  output$plot <- renderLeaflet({
    
    #access the button to make this code execute when button is pushed
    input$mapButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
    
    #get data selection
    dataSelected<-input$dataSelection
    
    if(dataSelected=="A"){
      dataSelected=states$farms1000
      output$data <- renderText({paste("Farm Count (Thousands) by State")})
    }
    else if(dataSelected=="B"){
      dataSelected=states$acresM
      output$data <- renderText({paste("Farm Acreage (Millions) by State")})
    }
    else if(dataSelected=="C"){
      dataSelected=states$acresPerFarm
      output$data <- renderText({paste("Acreage per Farm by State")})
    }
      
    #get user-selected color
    ipaletteCheck<-input$paletteCheck
    
    #get user-selected color levels
    icolorLevels<-input$colorLevels
    
    #write palette options
    pal<- colorQuantile(input$paletteCheck, dataSelected, n = icolorLevels)
    
    #get user-selected opacity
    iAlpha<-input$alpha
    
    #say where you want the center and zoom level of the map to start
    center<-c(-110,50,3)
      
    #Draw the map, add the appropriate map tiles, and add pop up boxes with text
    map<-leaflet(states) %>% addTiles() %>% setView(center[1], center[2], center[3]) %>%
      addPolygons(data=subset(states), 
                  weight=2, 
                  color = ~pal(dataSelected),
                  fillOpacity = iAlpha,
                  popup = ~sprintf("<strong>%s</strong><br />%g", NAME, dataSelected)
    )
        
    })#end isolation for button
    
  }) #end render plot
  
  
})