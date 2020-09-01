#This code creates a pair of linear plots from two equations. The equation variables and simple display parameters are user-controlled.
#Users can manipulate the slider controls to change the output and equations. 


library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  #use a theme to style the app
  #Valid themes are: cerulean, cosmo, flatly, journal, readable, spacelab, united.
  #other Bootstrap themes can go in a www directory and are called like this: theme = "mytheme.css"
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Linear Equation Explorer"),

  # Sidebar layout with inputs in the side panel
  sidebarLayout(
    
    #side panel 
    sidebarPanel(width=3,height=10,
      
      #slope slider
      sliderInput("slopeSliderVal1",
                  "Line 1 Slope:",
                  min = -10,
                  max = 10,
                  value = 3,
                  step = 0.1
      ),
                
      
      #intercept slider
      sliderInput("interceptSliderVal1",
                  "Line 1 Intercept:",
                  min = -20,
                  max = 20,
                  value = 2,
                  step = 0.5
      ),
      
      #slope slider
      sliderInput("slopeSliderVal2",
                  "Line 2 Slope:",
                  min = -10,
                  max = 10,
                  value = 0,
                  step = 0.1
      ),
      
      
      #intercept slider
      sliderInput("interceptSliderVal2",
                  "Line 2 Intercept:",
                  min = -20,
                  max = 20,
                  value = 1.5,
                  step = 0.5
      ),
      
      #line width slider
      sliderInput("lineWidth",
                  "Line Width:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1
      ),
      
      #colors
      selectInput("color1", "Line 1 Color:", 
                  choices = c("red", "blue", "black")
      ),
      
      #colors
      selectInput("color2", "Line 2 Color:", 
                  choices = c("blue", "red", "black")
      ),
      
      #line type
      selectInput("lineType", "Line Type:", 
                  choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
      )
      
    ),#end sideBarLayout      
    
    #main display area
    mainPanel(width = 9, height=10,
      
              #Line 1 text
                #h4(textOutput("text1")),
              #Line 2 text
                #h4(textOutput("text2")),
              #Intersection text
                #h4(textOutput("text3")),
              
              #main content
              plotOutput("plot")
      
      
      
    )#end main panel
    
  )#end sideBarPanel

)#end FluidPanel
)#end shiny UI