library(shiny)
library(graphics)

# turn your functions into r functions 
# variable = ax^2 + bx + c

#set up variables
a <- c(1)
b <- c(1)
c <- c(1)

curve1 <- function(x) 0.5 * x^2 + 5 * x - 10  
curve2 <- function(x) 0.5 * x^2 - 5 * x + 10	

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$plot <- renderPlot({
    
    slide <- input$sliderValue
    
    #make graph square
    par(pty="s")
    
    
    #par(fig=c(0,1,0,1), new=TRUE)
    #layout(matrix(c(1,1,1,1), 2, 2, byrow = TRUE), widths=c(4,1), heights=c(1,4))
    #par(mfrow=c(6,1))
    #par(mar=c(0,5,2,5))
    
    ## Setup up coordinate system (with x==y aspect ratio).
    
    plot(c(-10,10), c(-10,10), type = "n", xlab="x", ylab="y", asp = 1)#end plot
        
    #Grab the plotting region dimensions; use to position text on plot
    rng <- par("usr")
    
    ## the x- and y-axis, and an integer grid in gray
    #center axes
    abline(h=0, v=0, col = "gray60")
    
    #simple grid
    #grid(25, 25, lwd = 1) 
    
    #grid lines
    #abline(h = -1500:1500, v = -1500:1500, col = "lightgray", lty=3)
    
    #draw curve
    
    #update curve with slider values
    curve1 <- function(x) input$a1Value * x^2 + input$b1Value * x + input$c1Value 
    curve2 <- function(x) input$a2Value * x^2 + input$b2Value * x + input$c2Value
    
    curve(curve1, add=TRUE, lty=input$lineType, col = input$color1) 
    curve(curve2, add=TRUE, lty=input$lineType, col = input$color2) 
    
    #on-plot text for curve equations
    text(rng[2]-8,rng[4]-1.5, paste("Y=",input$a1Value,"x^2 + ",input$b1Value,"x +",input$c1Value, sep=" "), col = input$color1, adj = c(1.4,-0.7))
    text(rng[2]-8,rng[4]-1.5, paste("Y=",input$a2Value,"x^2 + ",input$b2Value,"x +",input$c2Value, sep=" "), col = input$color2, adj = c(1.4,1))

 
    
    
    
  })
  
  
  
  
})