#This code displays the path of the Rory Wilson in the custom-built KROS kayak. 
#Wilson's journey took place over ~6 weeks in 2012 as he successfully traveled solo and unaided from San Diego, CA to Honolulu, HI

#load libraries
library(shiny)
library(shinythemes)
library(leaflet)
library(shinyjs)
library(graphics)
library(rgdal)
library(ggmap)

shinyApp(

#UI functions  
  #User Interface layout
  shinyUI(fluidPage(
    #application theme
    theme = shinytheme("flatly"),
    
    # Application title
    titlePanel("KROS 2012 Path Explorer"),
    tags$a(href = "https://www.facebook.com/pages/KROS/486852238006122", "KROS on Facebook", style = "color:#000080"),
    tags$p("Representing Kites, Rowing, Ocean, and Solar, the KROS journey was a solo kayak passage of the Pacific Ocean by Rory Wilson. 
           Wilson both rowed and sailed, under kite-harnessed wind power, across the ocean for approximately six weeks in 2012."),
    
    #create a row for elements
    fluidRow(
      #add one column to the row, width of 12  (full width)
      column(12,leafletOutput("plot", height=600)
      )),
    
    fluidRow(
      #column(12,textOutput("data"), height=50)
      
    ),
    
    fluidRow(
      #column 1
      #column(2,
      #
      #   #data source
      ##   tags$a(href = "https://www.facebook.com/pages/KROS/486852238006122", "KROS on Facebook", style = "color:#000080")
      #   
      #        ),#end column
      
      
      #column 2
      column(2,
             #color chooser
             colourInput("pointCol", label = h4("Point Options"), "FF0080", palette = "limited"),
             sliderInput("pointAlpha",
                         "Opacity",
                         min = 0,
                         max = 1,
                         value = 0.8,
                         step = 0.1
             ),
             sliderInput("diameter",
                         "Point Diameter",
                         min = 0,
                         max = 15,
                         value = 3,
                         step = 1
             )
             
             
             
      ),#end column
      
      #column 
      column(2,
             #color chooser
             colourInput("lineCol", label = h4("Line Options"), "FFFFFF", palette = "limited"),
             sliderInput("lineAlpha",
                         "Opacity",
                         min = 0,
                         max = 1,
                         value = 0.8,
                         step = 0.1
             ),
             sliderInput("lineWidth",
                         "Line Width",
                         min = 0,
                         max = 10,
                         value = 3,
                         step = 0.1
             )           
             
      ),#end column
      
      
      column(3, 
             
             tags$div(class = "header", checked = NA,
                      tags$h4("Plot the Data")
                      
             ),
             
             #action button
             actionButton("mapButton", label = "Map it!")
             
      )#end column
      
    )#end row
    
    
    
    
    
    ##    )#end column
    ##  )#end row
    )),#end page
  
  
#server functions  
# Define server logic 
shinyServer(function(input, output) {
  
  #create a vector containing the column names from the data set
  columns <- c("day","latitude","longitude","date","distance","distanceTotal","bearing")
  
  #set up a data frame to hold the data and use the column name vector for headers
  data <- read.csv("krosData.csv", col.names = columns, stringsAsFactors = FALSE)
  
  #define variables of interest and describe their input location
  krosDay<-data$day
  lat<-data$latitude
  lng<-data$longitude
  krosDate<-data$date
  krosDist<-data$distance
  krosDistTot<-data$distanceTotal
  krosBearing<-data$bearing
  
  #create a data frame with the variables
  #dfLeaflet<-data.frame(reefID, reefDesc, reefName, reefMat, lat, lng)
  dfLeaflet<-data.frame(krosDay, lat, lng, krosDate, krosDist, krosDistTot, krosBearing)
  
  #set up the output plot
  output$plot <- renderLeaflet({
    
    
    #access the button to make this code execute when button is pushed
    input$mapButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
      
      #get user-selected point color
      ipointCol<-input$pointCol
      
      #get user-selected line color
      ilineCol<-input$lineCol
      
      #get user-selected diameter
      iDiameter<-input$diameter
      
      #get user-selected point opacity
      ipointAlpha<-input$pointAlpha
      
      #get user-selected line opacity
      ilineAlpha<-input$lineAlpha
      
      #get user-selected line width
      ilineWidth<-input$lineWidth
      
      output$data <- renderText({paste("KROS Waypoints, 2012")})
      
      #Draw the map, add the appropriate map tiles, and add pop up boxes with text
      leaflet(dfLeaflet) %>% 
        #addTiles() %>% 
        addProviderTiles("Stamen.Watercolor") %>%
        addPolylines(data=dfLeaflet[dfLeaflet$krosDist<=2700,], ~lng, ~lat, color=~ilineCol, opacity=ilineAlpha, weight=ilineWidth) %>% 
        #addCircleMarkers(popup=dfLeaflet$krosDate, col=ipointCol, fillOpacity = ipointAlpha, radius=iDiameter)
        
        addCircleMarkers(col=ipointCol, fillOpacity = ipointAlpha, radius=iDiameter,
                         popup=~sprintf("<b>KROS Data for Waypoint %s</b><br /> 
                                        
                                        Date: %s<br />                            
                                        Latitude: %3.2f<br/>
                                        Longitude: %3.2f<br/>
                                        Distance: %s nmi<br/>
                                        Distance Total: %s nmi<br/>
                                        Bearing: %s degrees",
                                        krosDay, 
                                        krosDate,
                                        lat,
                                        lng,
                                        krosDist,
                                        krosDistTot,
                                        krosBearing
                         ))
      
      
    })#end isolation for button
    
    
  }) #end render plot
  
  
  
  
}),

#app options
  options = list(height = 800, width = 1000)
)#end app