#load libraries
library(shiny)
library(shinythemes)
#library(leaflet)
library(shinyjs)
library(graphics)
#library(rgdal)
#library(ggmap)
library(metricsgraphics)
library(RColorBrewer)

shinyApp(

#UI functions  
  #User Interface layout
  shinyUI(fluidPage(
    #application theme
    theme = shinytheme("flatly"),
    
    #style
    tags$style(type="text/css", "body { background-color: #EEEEEE; }"),
    
    # Application title
    titlePanel("Projectile Motion Explorer"),
    tags$p("Use the controls below to simulate a projectile launch! Through repeated simulations, you can learn how launch angle and velocity affect the trajectory of the projectile. You can even test your launches on different planets with different values for acceleration due to gravity!"),
    
    #create a row for elements
    fluidRow(
      #add one column to the row, width of 12  (full width)
      column(12,plotOutput("plot", height=600)
      #column(12,metricsgraphicsOutput("plot", height=600)
      )),
    
    fluidRow(
       #padding under the plot
       column(12,tags$h3("Projectile Trajectory Plot", align = "center"), height=10)
    #  column(12,textOutput("gVal"), height=25),
    #  column(12,textOutput("maxHeight"), height=25),
    #  column(12,textOutput("maxDistance"), height=25)
    #  
    ),
    
    fluidRow(
      column(3,
             #column contents
             #drop menu for planet
             tags$h4("Select a Planet"),
             selectInput("planetSelection", 
                         
                         label = h4(""), 
                         choices = list(
                           "Mercury" = "mercury", 
                           "Venus" = "venus", 
                           "Earth" = "earth",
                           "Mars" = "mars",
                           "Jupiter" = "jupiter",
                           "Saturn" = "saturn",
                           "Uranus" = "uranus",
                           "Neptune" = "neptune",
                           "Pluto" = "pluto"
                         ),
                         selected = "earth"
             )#end options
             
      ),
      column(3,
             #column contents
             tags$h4("Set Launch Parameters"),
             #launch velocity
             sliderInput("velocity", "Launch Velocity (m/s)", 1, 100, 50),
             #launch angle
             sliderInput("angle", "Launch Angle (degrees)", 0, 90, 45)
      ),
      column(3,
             #column contents
             tags$h4("Set Display Parameters"),
             #evaluation counts
             sliderInput("count", "Number of Plot Points", 2, 200, 50),
             #sliderInput("diameter", "Point Size", 1, 5, 1),
             colourInput("col", label = h3("Choose Display Options"), "008000", palette = "limited")
      ),
      column(3,
             #column contents
             actionButton("launchButton", label = "Launch!"),
             dataTableOutput('dataTable')
      )
      
      
      
      
    
    )#end row
    
    )),#end page
  
  
#server functions  
# Define server logic 
shinyServer(function(input, output) {
  
  #set up the output plot
  output$plot <- renderPlot({
  #output$plot <- renderMetricsgraphics({
    
    
    #access the button to make this code execute when button is pushed
    input$launchButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
      
      #get user-selected point color
      ipointCol<-input$col
      
      #get user-selected diameter
      iDiameter<-input$diameter
      
      #get launch velocity, launch angle, planet selection, and evaluation count
      v<-input$velocity
      theta<-input$angle
      planet<-input$planetSelection
      evalCount<-input$count
      
      #set acceleration due to gravity
      #source: http://nssdc.gsfc.nasa.gov/planetary/factsheet/planet_table_ratio.html
      if(planet=="earth"){g=9.81}
      else if(planet=="mercury"){g=3.7}
      else if(planet=="venus"){g=8.89}
      else if(planet=="mars"){g=3.69}
      else if(planet=="jupiter"){g=23.128}
      else if(planet=="saturn"){g=8.97}
      else if(planet=="uranus"){g=8.71}
      else if(planet=="neptune"){g=10.98}
      else if(planet=="pluto"){g=0.7}
      
      #convert launch angle to radians
      thetaRad = theta*(pi/180)
      
      #set up components of velocity
      vx=v*cos(thetaRad)              # horizontal initial velocity (m/s)
      vy=v*sin(thetaRad)              # vertical initial velocity (m/s)
      
      #Find the time we hit ground
      tg=2*vy/g
      
      #solve for max height
      maxH= (vy^2)/(2*g)
      
      #y padding for plot if needed
      paddingY=maxH/100
      plotY=maxH+paddingY
      
      #solve for max range
      maxR = (2*vx*vy)/g
      
      #x padding for plot if needed
      paddingX=maxR/100
      plotX=maxR+paddingX
      
      #average vertical speed
      avgYspeed=vy/2
      
      #time of flight
      flightTime = (2*vy)/g
      
      #make time array out of data
      t = seq(0,tg,length=evalCount)
      
      #vertical component
      y=vy*t-.5*g*t^2
      
      #horizontal component
      x=vx*t
      
      #write data
      #add data to a dataframe
      df<-data.frame(g, round(maxH, digits=2), round(maxR, digits=2))
      #rename the columns
      colnames(df) <- c("Acceleration (m/s/s)", "Maximum Height (m)", "Maximum Distance (m)")
      
      #output$gVal <- renderText({paste("Acceleration (g): ", g,"m/s/s")})
      #output$maxHeight <- renderText({paste("Maximum Height: ", round(maxH, digits=2),"m")})
      #output$maxDistance <- renderText({paste("Final Distance: ", round(maxR, digits=2),"m")})
      
      #write the data to a simple data table
      output$dataTable = renderDataTable(df,options = list(info=0,searching = FALSE, pageLength = 1, searchable=FALSE, paging=FALSE))
      
      #plot the data points
      plot(x,y,xlab="Distance (m)", ylab="Height (m)", 
          col=ipointCol,pch=19,xlim=c(0,1100),ylim=c(0,300)
          )
      
      
      #metricsgraphics version
      #create data frame of coordinates
        #coordinates<-data.frame(round(x, digits=2),round(y, digits=2))
          #colnames(coordinates) <- c("Distance", "Height")
      #print(coordinates)
      #plot with metricsgraphics
        #mjs_plot(coordinates, x=Distance, y=Height) %>% 
        #mjs_point(color_type="category",
        #        color_accessor = Distance,
        #        color_range = c("blue", "red", "green"),  
        #        x_rug = TRUE,
        #        y_rug = TRUE
        #        )   %>%
        #mjs_labs(x="Distance (m)", y="Height (m)")
      
      
      
    })#end isolation for button
    
    
  }) #end render plot
  
  
  
  
}),

#app options
  options = list(height = 800, width = 1000)
)#end app