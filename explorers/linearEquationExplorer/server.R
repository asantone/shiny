library(shiny)
library(graphics)


#line 1
slopeValue1 <- c(3) #slope 
xValue1 <- c(0) #default x
interceptValue1 <- c(4) #intercept 
yValue1 <- slopeValue1*xValue1+interceptValue1 #equation for y

#line 2
slopeValue2 <- c(5) #slope 
xValue2 <- c(0) #default x
interceptValue2 <- c(2) #intercept 
yValue2 <- slopeValue2*xValue2+interceptValue2 #equation for y


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$plot <- renderPlot({
        
    #slope value changes with slider input
    slopeValue1 <- input$slopeSliderVal1 #line 1
    slopeValue2 <- input$slopeSliderVal2 #line 2
    
    #intercept value changes with slider input
    interceptValue1 <- input$interceptSliderVal1 #line 1
    interceptValue2 <- input$interceptSliderVal2 #line 2
    
    ## Setup up coordinate system (with x==y aspect ratio).
    
    plot(c(-10,10), c(-10,10), type = "n", xlab="x", ylab="y", asp = 1)#end plot
    
    #Grab the plotting region dimensions; use to position text on plot
    rng <- par("usr")
    
    ## the x- and y-axis, and an integer grid in gray
    #center axes
    abline(h=0, v=0, col = "gray60")
    
    #grid lines
    abline(h = -100:100, v = -100:100, col = "lightgray", lty=3)
    
    #draw line 1
    abline(a = interceptValue1, b = slopeValue1, col = input$color1, lty = input$lineType, lwd = input$lineWidth)
    #on-plot text for line 1
    text(rng[2]-8,rng[4]-1.5, paste("Y=",slopeValue1,"x + ",interceptValue1, sep=" "), col = input$color1, adj = c(0,-.1))

    #draw line 2
    abline(a = interceptValue2, b = slopeValue2, col = input$color2, lty = input$lineType, lwd = input$lineWidth)
    #on-plot text for line 2
    text(rng[2]-8,rng[4]-3.5, paste("Y=",slopeValue2,"x + ",interceptValue2, sep=" "), col = input$color2, adj = c(0, -.1))
    
    
    
    #print equation 
    output$text1 <-renderText({
      text1<-paste(
        "Line 1: Y=",slopeValue1,"x + ",interceptValue1,sep=" ")#end paste
    })
    #print equation 
    output$text2 <-renderText({
      text2<-paste(
        "Line 2: Y=",slopeValue2,"x + ",interceptValue2,sep=" ")#end paste
    })
    
    
    #get intersection
    coeffMatrix <- matrix(c(slopeValue1, 1,slopeValue2,1), nrow=2, ncol=2, byrow=TRUE)
    zeroCheck<-c(slopeValue2-slopeValue1)
    #print(zeroCheck)
    if((zeroCheck!=0)){
          rhsMatrix <- matrix(c(interceptValue1, interceptValue2), nrow=2, ncol=1, byrow=TRUE)
          inverse<-solve(coeffMatrix)
          result<-inverse %*% rhsMatrix
          #print(result[1])
          #print(result[2])
          
          #print intersection on plot
          text(
            rng[1]+1,
            rng[4]-1.5, 
            paste(
            "Intersection: (",
            round(result[1]%*%-1,digits = 1),
            ", ",
            round(result[2],
            digits = 1),
            ")",
            sep=" "),
            col = "black",
            adj = c(0, -.1))
          
          output$text3 <-renderText({
             text3<-paste(
             "Intersection: (",round(result[1]%*%-1,digits = 1),", ",round(result[2], digits = 1),")",sep=" ")#end paste
          })
    }
    else{
          
      #print intersection on plot
      text(
        rng[1]+1,
        rng[4]-1.5, 
        paste("Parallel"),
        col = "black",
        adj = c(0, -.1)
      )
      
      output$text3 <-renderText({
             text3<-paste("Parallel lines, no intersection!")#end paste
          })
    }
    
    
    
    
  })
  
  
  
  
})