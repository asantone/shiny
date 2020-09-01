#This code creates a histogram and data set from user-specified die roll settings
#Users can set the weight of each side of a 6-sided die and the number of rolls
#Observers can decide whether the resulting histogram suggests a fair die was used
#Users may wish to conduct their own real-world experiment to create a data set for comparison

library(shiny)
library(shinythemes)

# Define UI for application
shinyUI(fluidPage(
  
  #use a theme to style the app
  #Valid themes are: cerulean, cosmo, flatly, journal, readable, spacelab, united.
  #other Bootstrap themes can go in a www directory and are called like this: theme = "mytheme.css"
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Dice Data Explorer"),

  # Sidebar layout with inputs in the side panel
  sidebarLayout(
    
    #side panel 
    sidebarPanel(width=3,height=10,
      
      #value count slider
      sliderInput("throws",
                  "How many throws?",
                  min = 1,
                  max = 100,
                  value = 50,
                  step = 1
      ),
      #value count slider
      sliderInput("w1",
                  "Side 1: How much weight (probability)?",
                  min = 1,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("w2",
                  "Side 2: How much weight (probability)?",
                  min = 1,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("w3",
                  "Side 3: How much weight (probability)?",
                  min = 1,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("w4",
                  "Side 4: How much weight (probability)?",
                  min = 1,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("w5",
                  "Side 5: How much weight (probability)?",
                  min = 1,
                  max = 10,
                  value = 1,
                  step = 1
      ),
      #value count slider
      sliderInput("w6",
                  "Side 6: How much weight (probability)?",
                  min = 1,
                  max = 10,
                  value = 1,
                  step = 1
      ),
          
      #plot colors
      selectInput("plotColor", "Which color for the plot?", 
                  choices = c("khaki3", "aquamarine4", "hotpink3")
      ),
      
      actionButton("rollButton", label = "Roll it!")
      
    ),#end sideBarLayout      
    
    #main display area
    mainPanel(width = 9, height=10,
              
              #main content
              plotOutput("plot"),
              
              #text area for the data display
              textOutput("data")
  
    )#end main panel
    
  )#end sideBarPanel

)#end FluidPanel
)#end shiny UI