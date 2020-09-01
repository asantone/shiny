#test App

library(shiny)
library(shinythemes)
library(shinyjs)
library(graphics)
library(networkD3)

shinyApp(

#UI functions  
  ui = fluidPage(
    ########################   
    
    #application theme
    theme = shinytheme("cosmo"),
    
    # Application title
    titlePanel("Species Interaction Network Explorer"),
    
    #create a row for elements
    fluidRow(
      #add one column to the row, width of 12  (full width)
      column(12,forceNetworkOutput("plot", height=600)
      )),
    
    fluidRow(
      column(12,textOutput("data"), height=100)
      
    ),
    
    fluidRow(
      #column
      column(3,
             tags$div(class = "header", checked = NA,
                      tags$h3("Visual Options")
                      
             ),
             #color chooser
             colourInput("colP", label = ("Producer Color"), "008000", palette = "limited", allowedCols = c("#FF0000", "#FF00FF")),
             colourInput("colC", label = ("Consumer Color"), "008000", palette = "limited"),
             colourInput("colD", label = ("Decomposer Color"), "008000", palette = "limited"),
             colourInput("colL", label = ("Line Color"), "B3B3B3", palette = "limited", showColour = "background"),
             sliderInput("alpha",
                         "Graph Opacity",
                         min = 0,
                         max = 1,
                         value = 0.8,
                         step = 0.1
             ),
             sliderInput("radius",
                         "Node Size",
                         min = 1,
                         max = 100,
                         value = 30,
                         step = 1
             )
             
             
      ),#end column
      #column
      column(3,
             tags$div(class = "header", checked = NA,
                      tags$h3("Graph Properties")
                      
             ),
             sliderInput("charge",
                         "Node Repulsion",
                         min = -1000,
                         max = 0,
                         value = -100,
                         step = 1
             ),
             sliderInput("distance",
                         "Node Distance",
                         min = 0,
                         max = 500,
                         value = 300,
                         step = 1
             )
      ),#end column
  
      column(3, 
             
             tags$div(class = "header", checked = NA,
                      tags$h3("Plot the Network Graph")
             ),
             
             #action button
             actionButton("renderButton", label = "Plot it!")
      )#end column
    )#end row
    
    ########################   
  ),#end fluid page
  
#server functions  
  server = function(input, output) {
  ########################  
    
  #read data
  forceDataNodes<-read.csv("forceDataNodes.csv")
  forceDataLinks<-read.csv("forceDataLinks.csv")
  
  #set up the output plot
  output$plot <- renderForceNetwork({
    
    
    #access the button to make this code execute when button is pushed
    input$renderButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
      
      #get user-selected options
      iColP<-input$colP 
      iColC<-input$colC 
      iColD<-input$colD
      iColL<-input$colL 
      iAlpha<-input$alpha
      iDistance<-input$distance
      iCharge<-input$charge
      iRadius<-input$radius
      
      #draw a force network graph
      forceNetwork(
        Nodes = forceDataNodes, #read from CSV file
        Links = forceDataLinks, #read from CSV file
        Source = "Source", #read from CSV header of your choosing, any custom name
        Target="Target",   #read from CSV header of your choosing, any custom name
        Value="Value",     #read from CSV header of your choosing, any custom name
        NodeID = "NodeID", #read from CSV header of your choosing, any custom name
        Group="Group",     #read from CSV header of your choosing, any custom name
        Nodesize = "NodeSize",
        radiusCalculation = iRadius,#set the radius of the nodes 
        colourScale = "d3.scale.category10().range(['#c1d645', '#d14359', '#2d7c87'])", #set the color palette for each value of the domain
        linkDistance = iDistance, #user can change this to other values to separate the nodes
        linkWidth = "function(d) { return Math.sqrt(d.value); }", #this formula is default value
        charge = iCharge, #negative is repulsion; positive is attraction; -120 is a good normal value
        linkColour = iColL, #any hexadecimal color value (0 to F for each of the 6 positions)
        opacity = iAlpha, #any value between 0 and 1, decimals ok
        legend=TRUE,
        zoom=TRUE
      )#end force network
    })#end isolation for button
  }) #end render plot
  ########################   
  },#end server

#app options
  options = list(height = 400, width = 800)
)#end app