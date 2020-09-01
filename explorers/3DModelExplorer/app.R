#test App

library(shiny)
library(shinythemes)
library(leaflet)
library(shinyjs)
library(graphics)
library(rgdal)
options(rgl.useNULL=TRUE)
library(rgl)
library(shinyRGL)


shinyApp(

#UI functions  
  ui = fluidPage(
    ########################   
    
    #application theme
    theme = shinytheme("flatly"),
    
    # Application title
    titlePanel("3D Model Explorer"),
    
    #create a row for elements
    fluidRow(
      #add one column to the row, width of 6
      column(6,webGLOutput("plot1", height=600)
             
      ),
      #add one column to the row, width of 6
      column(6,webGLOutput("plot2", height=600)
      )
      
      ), #end row
    
    fluidRow(
      column(12,textOutput("data"), height=100)
      
    ),
    
    fluidRow(
      #column 1
      column(3,
             selectInput("speciesCheck", 
                         #radioButtons("speciesCheck",              
                         label = h3("Select a Species"), 
                         choices = list(
                           "Sassafrass" = "sassafrass",
                           "Texas Hercules Club" = "hercules",
                           "Baldcypress" = "cypress",
                           "Florida Torreya Pine" = "torreya",
                           "American Elm" = "elm",
                           "Joshua Tree" = "joshua",
                           "Poison Sumac" = "sumac"                    
                         ),
                         selected = "sassafrass"
             ),#end options
             
             
             #data source
             tags$a(href = "http://esp.cr.usgs.gov/data/little/", "Data Source: U.S. Geological Survey", style = "color:#000080")
             
      ),#end column
      
      
      #column 2
      column(4,
             #color chooser
             colourInput("col", label = h3("Choose Display Options"), "008000", palette = "limited"),
             sliderInput("alpha",
                         "Opacity",
                         min = 0,
                         max = 1,
                         value = 0.6,
                         step = 0.1
             )
             
             
             
      ),#end column
      
      column(3, 
             
             tags$div(class = "header", checked = NA,
                      tags$h3("Plot the Data")
                      
             ),
             
             #action button
             actionButton("mapButton", label = "Map it!")
             
      )#end column
      
    )#end row
    
    ########################   
  ),#end fluid page
  
  
  
#server functions  
  server = function(input, output) {
  ########################  
    
  open3d()
  #comet <- readOBJ(url("http://sci.esa.int/science-e/www/object/doc.cfm?fobjectid=54726"))
  comet2 <- readOBJ("ESA_Rosetta_OSIRIS_67P_SHAP2P.obj")
  other  <- readOBJ("ESA_Rosetta_OSIRIS_67P_SHAP2P.obj")
  
  #set up the output plot
  output$plot1 <- renderWebGL({
    
    shade3d(comet2, col="papayawhip")
    shade3d(other, col="papayawhip")
    
  }) #end render plot
  
  #set up the output plot
  output$plot2 <- renderWebGL({
    
    shade3d(other, col="papayawhip")
    
  }) #end render plot
  
  ########################   
  
  },#end server

#app options
  options = list(height = 600, width = 500)
)#end app