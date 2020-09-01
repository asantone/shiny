library(shiny)
library(graphics)

# Define server logic 
shinyServer(function(input, output) {

  #set up the output plot
  output$plot <- renderPlot({
        
    #get input values
    iones    <-input$ones
    itwos    <-input$twos
    ithrees  <-input$threes
    ifours   <-input$fours
    ifives   <-input$fives
    isixes   <-input$sixes
    isevens  <-input$sevens
    ieights  <-input$eights
    inines   <-input$nines
      
    #get color input selection
    iDotColor <-input$dotColor
    
    #get color input selection
    iDotSize <-input$dotSize
    
    #create one-dimensional arrays of the values
    mones   <- matrix(1, 1, iones)
    mtwos   <- matrix(2, 1, itwos)
    mthrees <- matrix(3, 1, ithrees)
    mfours  <- matrix(4, 1, ifours)
    mfives  <- matrix(5, 1, ifives)
    msixes  <- matrix(6, 1, isixes)
    msevens <- matrix(7, 1, isevens)
    meights <- matrix(8, 1, ieights)
    mnines  <- matrix(9, 1, inines)

    #create a vector using all values in sequence
    myList<-c(mones,mtwos,mthrees,mfours,mfives,msixes,msevens,meights,mnines)
  
    #create a stripchart using the vector
    #set as stacked, with symbol 19, set labels, colors, sizes, and axis limits. suppress x axis labels on this plot
    stripchart(myList, method="stack", pch=19, main="Dot Plot", col=iDotColor, offset=0.5, xlab="Values", ylab="Count", cex=iDotSize, ylim = c(0, 10), xaxt='n') 
    #add x axis labels and force labels for each value
    axis(1, at = 1:9, cex.axis=1.5)

    #render the list on screen to see the data also
    output$data <- renderText({ 
      paste(myList)
    })
    
    
  }) #end render plot
  
  
  
  
})