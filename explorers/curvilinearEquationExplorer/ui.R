#this code allows users to explore curvilinear functions by manipulating the variables for 
#a simple basic function. Users can see two lines in two colors of their choice. 
#Equations are printed on the graph so users can see the mathematical and graphical versions
#of the equations simulatneously

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  #use a theme to style the app
  #Valid themes are: cerulean, cosmo, flatly, journal, readable, spacelab, united.
  #other Bootstrap themes can go in a www directory and are called like this: theme = "mytheme.css"
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Curvilinear Equation Explorer"),

  # Sidebar layout with inputs in the side panel
  sidebarLayout(
    
    #side panel 
    sidebarPanel(
      
      #slider
      sliderInput("a1Value",
                  "A1:",
                  min = -10,
                  max = 10,
                  value = 0.2,
                  step = 0.1
      ),
      #slider
      sliderInput("b1Value",
                  "B1:",
                  min = -10,
                  max = 10,
                  value = 1,
                  step = 0.1
      ),
      #slider
      sliderInput("c1Value",
                  "C1:",
                  min = -10,
                  max = 10,
                  value = -3,
                  step = 0.1
      ),
      #slider
      sliderInput("a2Value",
                  "A2:",
                  min = -10,
                  max = 10,
                  value = 0.2,
                  step = 0.1
      ),
      #slider
      sliderInput("b2Value",
                  "B2:",
                  min = -10,
                  max = 10,
                  value = 1,
                  step = 0.1
      ),
      #slider
      sliderInput("c2Value",
                  "C2:",
                  min = -10,
                  max = 10,
                  value = 2,
                  step = 0.1
      ),
      
      #colors
      selectInput("color1", "Curve 1 Color:", 
                  choices = c("blue", "red", "black")
      ),
      
      selectInput("color2", "Curve 2 Color:", 
                  choices = c("red", "blue", "black")
      ),
      
      #line type
      selectInput("lineType", "Line Type:", 
                  choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
      )
      
    ),#end sideBarLayout      
    
    #main display area
    mainPanel(

              
              #main content
              plotOutput("plot")
      
      
      
    )#end main panel
    
  )#end sideBarPanel

)#end FluidPanel
)#end shiny UI