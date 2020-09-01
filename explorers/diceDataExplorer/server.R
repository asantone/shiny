library(shiny)
library(graphics)



# Define server logic 
shinyServer(function(input, output) {

  #set up the output plot
  output$plot <- renderPlot({
    
    #access the button to make this code execute when button is pushed
    input$rollButton
    
    #use isolate to wrap the code that will be dependent on the button push
    isolate({
      
      #this code will execute with the button push input
      #get number of throws
      ithrows<-input$throws
      
      #get weight values for each die side
      iw1<-input$w1
      iw2<-input$w2
      iw3<-input$w3
      iw4<-input$w4
      iw5<-input$w5
      iw6<-input$w6
      
      #get color choice
      iplotColor<-input$plotColor
      
      #run sample simulation
      sim <- sample(1:6, ithrows, replace = TRUE, prob = c(iw1,iw2,iw3,iw4,iw5,iw6))
      
      #plot histogram
      simPlot<-hist(sim, breaks=0.5:6.5, col=iplotColor, main="Frequency Distribution of Rolled Die Values", xlab="Value", ylab="Frequency")
      plot(simPlot, add=TRUE)
      
      #plot density 
      #xfit<-seq(min(sim),max(sim),length=40) 
      #yfit<-dnorm(xfit,mean=mean(sim),sd=sd(sim)) 
      #yfit <- yfit*diff(simPlot$mids[1:2])*length(sim) 
      #lines(xfit, yfit, col="blue", lwd=2)
      
      
      #render the list on screen to see the data also
      output$data <- renderText({ 
        #paste(table(sim))
        paste(sim)
      })#end text output
      
    })#end code isolation
    
      
  }) #end render plot
  
  
  
  
})