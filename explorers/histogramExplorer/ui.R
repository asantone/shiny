#This code creates an interactive histogram from user-specified data

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  #use a theme to style the app
  #Valid themes are: cerulean, cosmo, flatly, journal, readable, spacelab, united.
  #other Bootstrap themes can go in a www directory and are called like this: theme = "mytheme.css"
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Histogram Explorer"),

  # Sidebar layout with inputs in the side panel
  sidebarLayout(
    
    #side panel 
    sidebarPanel(width=3,height=10,
      
      #value count slider
      sliderInput("ones",
                  "How many ones?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("twos",
                  "How many twos?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("threes",
                  "How many threes?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("fours",
                  "How many fours?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("fives",
                  "How many fives?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("sixes",
                  "How many sixes?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("sevens",
                  "How many sevens?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("eights",
                  "How many eights?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("nines",
                  "How many nines?",
                  min = 0,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      
      #checkbox for displaying the mean or not
      checkboxInput("meanCheck", "Display the mean?", value = TRUE),
      
      #select bin count
      selectInput("binCount", "How many bins?", 
                  choices = c("Many", "Few", "One")
      ),
    
      #plot colors
      selectInput("plotColor", "Which color?", 
                  choices = c("Red", "Blue", "Black")
      )
      
    ),#end sideBarLayout      
    
    #main display area
    mainPanel(width = 9, height=10,
              
              #main content
              plotOutput("plot"),
              
              #text area for the data display
              textOutput("mean"),
              
              #text area for the data display
              textOutput("data")
  
    )#end main panel
    
  )#end sideBarPanel

)#end FluidPanel
)#end shiny UI