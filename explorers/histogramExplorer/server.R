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
      
    #get bin count
    ibins<-input$binCount
    
    #get color input selection
    iplotColor <-input$plotColor
 
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
  
    #calculate mean
    m<-mean(myList)
    
    #display mean
    meanCB<-input$meanCheck
    
    #draw histogram with conditional display for the bin count
    if(ibins=="One") {hist(myList, breaks=1, xlim=c(1,9),ylim=c(1,length(myList)+5),col=iplotColor,xaxt='n', labels=TRUE)}
    if(ibins=="Few") {hist(myList, breaks=3, xlim=c(1,9),ylim=c(1,length(myList)+5),col=iplotColor,xaxt='n', labels=TRUE)}
    if(ibins=="Many"){hist(myList, breaks=7, xlim=c(1,9),ylim=c(1,length(myList)+5),col=iplotColor,xaxt='n', labels=TRUE)}
    
    #add x axis labels and force labels for each value
    axis(1, at = 1:9, cex.axis=1.5)

    #render the mean
    output$mean <- renderText({ 
      if(meanCB==TRUE){
      paste("Rounded mean from the data set below: ",round(m, digits=2))
      }
      #else{"The mean is currently hidden."}
    })
    
    #render the list on screen to see the data also
    output$data <- renderText({ 
      paste(myList)
    })
    
    
  }) #end render plot
  
  
  
  
})