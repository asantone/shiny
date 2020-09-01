#test App

library(shiny)
library(shinythemes)
#library(leaflet)
#library(shinyjs)
library(graphics)
#library(rgdal)

shinyApp(
  
  
  

#UI functions  
  ui = fluidPage(
    sidebarLayout(
      sidebarPanel(
        #drop menu for planet
        selectInput("planetSelection", 

                    label = h3("Select a Planet"), 
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
        ),#end options
        #launch velocity
        sliderInput("velocity", "Launch Velocity (m/s)", 1, 100, 1),
        #launch angle
        sliderInput("angle", "Launch Angle (degrees)", 0, 90, 45),
        #evaluation counts
        sliderInput("count", "Number of Plot Points", 0, 90, 1),
        ),
      mainPanel(plotOutput("plot"))
    )
  ),
  
  
  
#server functions  
  server = function(input, output) {

    
    
    v=10
    theta=15
    evalCount=50
    g= 9.8 #default
    
    
    #get launch velocity, launch angle, planet selection, and evaluation count
    #v<-input$velocity
    #theta<-input$angle
    #planet<-input$planetSelection
    #evalCount<-input$count
    
    #v=10
    #theta=15
    #evalCount=50
    
    
    #set acceleration due to gravity
    
    #if(planet==mercury){g=3.61}
    #else if(planet==venus){g=8.83}
    #else if(planet==earth){g=9.8}
    #else if(planet==mars){g=3.75}
    #else if(planet==jupiter){g=26.0}
    #else if(planet==saturn){g=11.2}
    #else if(planet==uranus){g=10.5}
    #else if(planet==neptune){g=13.3}
    #else if(planet==pluto){g=0.61}
    
    
    
    
    #convert launch angle to radians
    thetaRad = theta*(pi/180)
    
    #set up components of velocity
    vx=v*cos(thetaRad)              # horizontal initial velocity (m/s)
    vy=v*sin(thetaRad)              # vertical initial velocity (m/s)
    
    #Find the time we hit ground
    tg=2*vy/g
    
    #solve for max height
    maxH= (vy^2)/(2*g)
    paddingY=maxH/100
    plotY=maxH+paddingY
    
    #solve for max range
    maxR = (2*vx*vy)/g
    paddingX=testVar/100
    plotX=testVar+paddingX
    
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
    
    
    output$plot <- renderPlot( 
      
      print("yay")

      

      
      #plot the trajectory as discrete X,y points
      #plot using max range and height with a little padding (plots will look similar while axes change)
      #plot(x,y, xlab="x(ft)", ylab="y(ft)", main="Projectile Trajectory", col="blue", pch=19, xlim=c(0,plotX), ylim=c(0,plotY))
      
      #plot using defined height and range values for axes. plots will look different while axes remain constant
     # plot(x,y,xlab="x(ft)", ylab="y(ft)",main="Projectile Trajectory", 
     #      col=topo.colors(100),pch=19,xlim=c(0,1000),ylim=c(0,500)
     #      )
      
      
      
      
    )
  },

#app options
  options = list(height = 600, width = 500)
)#end app