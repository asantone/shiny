#libraries
library(shiny)
library(igraph)

# Set up the User Interface (UI)
ui <- fluidPage(

    # Title
    titlePanel("Markov Chain Simulation: Gambler's Ruin"),
    
    h4("Background"),  
    p("This simulation describes a gambling game where a gambler starts with an initial amount of money and can win or lose one unit of that money in each round of gambling."),
    
    p('The source of this idea is ', a(href = 'https://scholarworks.uttyler.edu/cgi/viewcontent.cgi?article=1010&context=math_grad', 'Markov Chains and Their Applications', .noWS = "outside"), ', a math thesis presented by Fariha Mahfuz in 2021 at the University of Texas at Tyler.', .noWS = c("after-begin", "before-end")), 
    
    h4("Instructions"),
    p("Using the slider inputs below, select the starting balance, upper limit of winnable currency, number of rounds of gambling, and the probability of winning in each round of gambling."),
    
    h4("Constraints"),
    p("The rules are as follows: the gambler must have at least one dollar and up to one dollar less than the maximum winning amount to continue playing, the game stops when the gambler has
       zero dollars or when the gambler receives the upper limit of currency, one dollar is bet in each round, a winning gamble results in one additional dollar and a losing gamble results in one lost dollar."),

    p("Note: the initial amount of money must be less than the total winning amount because the game will have been won if the values are equal. The slider inputs adjust automatically when the values require adjustment."),
    
    
    #fluidRow(plotOutput("nodes"),style='padding-left:0px; padding-right:0px; padding-top:0px; padding-bottom:0px'),
    
    
    # Sidebar / menu / interactives 
    sidebarLayout(
        sidebarPanel(
          width = 4,
          sliderInput("money_init",
                      "Starting Balance ($):",
                      min = 1,
                      max = 5,
                      value = 1), 
          
          sliderInput("bet_max",
                        "Winning Balance ($):",
                        min = 2,
                        max = 6,
                        value = 3),
          
          sliderInput("gambles",
                      "Rounds of Gambling:",
                      min = 1,
                      max = 50,
                      value = 5),
            
          sliderInput("p_win",
                        "Probability of Winning:",
                        min = 0.01,
                        max = 0.99,
                        value = 0.58),
            
          #black line
          tags$hr(style="border-color: #ACACAC;"),
          
          #node graph
          #div(plotOutput('nodes'), style = 'vertical-align: middle;margin-top: 0px;'),
          plotOutput("nodes", height=50), #height controls plot background area in px -- linked to par mar
         
          
          #black line
          tags$hr(style="border-color: #ACACAC;"),
          
          
          
          #header  
          h4("Settings Summary"),
            
          #table with summary of slider settings
          tableOutput("output_values"),
          
          #black line  
          tags$hr(style="border-color: #ACACAC;"),
          
          #button to trigger the calculations using the slider settings  
          # actionButton("gamble_button","Gamble!",icon("dice"), 
          #              style="color: #fff; 
          #                     background-color: #337ab7; 
          #                     border-color: #2e6da4"),
          
          
          actionButton("gamble_button","Gamble!",icon("dice"), 
                           style="color: #fff; 
                              background-color: #337ab7; 
                              border-color: #2e6da4")
              
          
          
        ), #end sidebarPanel

        # Main panel with outputs and notes
        mainPanel(
          width = 8,
          
          #row 1
          fluidRow(column(6,tableOutput("output_matrix")), 
                   column(4,
                          wellPanel(h4("Transition Matrix"),
                                    p("This matrix describes the nodes and step probabilities in the Markov chain. It is a column stochastic transition matrix where each column sums to a value of one."))
                          )), #end row 1
          
          #dividing line
          hr(style="border-color: #dddddd;"),
          
          #row 2
          fluidRow(column(6,tableOutput("gambler_matrix")), 
                   column(4,
                          wellPanel(h4("Gambler's Vector"),
                                    p("This table describes the gambler's starting money. A \"1\" is present in the vector, shown as a column here, 
                                       at the position correlated with the value of the gambler's starting money. The position of the \"1\" 
                                       changes with the \"Starting Balance\" slider input. The vector length changes with the \"Upper Limit\" slider input."))
                   )), #end row 2
          
          #dividing line
          hr(style="border-color: #dddddd;"),
          
          #row 3
          fluidRow(column(6,tableOutput("result_matrix")), 
                   column(4,
                          wellPanel(h4("Earnings Probability Vector"),
                                    p("The vector resulting from the product of the Transformation matrix and the Gambler's Vector."),
                                    p("Interpretation: The vector contains the probabilities of having each associated amount of money left over. 
                                       A high probability of having 0 dollars suggests a losing strategy. A high probability of having the maximum number dollars suggests a winning strategy.
                                       Try adjusting the starting value while leaving the other slider inputs stable to learn the effect of starting value on final earnings probabilities."))
                          
                   )) #end row 3
       ) #end mainPanel
    )#end sidebarLayout
)#end FluidPage

# Server logic
server <- function(input, output,session) {

  #=========
  #reactives
  #=========
  
  #update slider limit based on other input
  #rules: 
  #bet_max >= money_init
  #money_init <= bet_max - 1
  
  # observe({
  #   if (input$bet_max < input$money_init){
  #     updateSliderInput(session, "bet_max", value = input$money_init)
  #   }
  # })
  
  observe({
    if (input$money_init >= input$bet_max){
      updateSliderInput(session, "money_init", value = input$bet_max - 1)
    }
  })
  
  
  #slider settings
  values <- reactive({
    
    data.frame(
      Name = c("Minimum Bet ($)",
               "Maximum Bet ($)",
               "Probability of winning",
               "Probability of losing",
               "Number of gambles"),
      Value = as.character(c("1",
                             input$bet_max,
                             input$p_win,
                             1-input$p_win,
                             input$gambles)),
      stringsAsFactors = FALSE)
    
  }) 
  
  #transition matrix calculations
  transition_matrix <- reactive({
    
    #probability of winning (taken from slider)
    pW <- input$p_win
    
    #probability of losing
    pL <- 1-pW
    
    #transition matrices
    matrix_values_2 <- c(1, pL, 0,    
                         0, 0,  0, 
                         0, pW, 1)
    matrix_values_3 <- c(1, pL, 0,  0,    
                         0, 0,  pL, 0,    
                         0, pW, 0,  0, 
                         0, 0,  pW, 1)
    matrix_values_4 <- c(1, pL, 0,  0,  0,    
                         0, 0,  pL, 0,  0,    
                         0, pW, 0,  pL, 0,    
                         0, 0,  pW, 0,  0, 
                         0, 0,  0,  pW, 1)
    matrix_values_5 <- c(1, pL, 0,  0,  0,  0,    
                         0, 0,  pL, 0,  0,  0, 
                         0, pW, 0,  pL, 0,  0,
                         0, 0,  pW, 0,  pL, 0,
                         0, 0,  0,  pW, 0,  0,
                         0, 0,  0,  0,  pW, 1)
    matrix_values_6 <- c(1, pL, 0,  0,  0,  0,  0,
                         0, 0,  pL, 0,  0,  0,  0,
                         0, pW, 0,  pL, 0,  0,  0,
                         0, 0,  pW, 0,  pL, 0,  0,
                         0, 0,  0,  pW, 0,  pL, 0,
                         0, 0,  0,  0,  pW, 0,  0,
                         0, 0,  0,  0,  0,  pW, 1)
    
    #transition matrix switching with slider input 
    if (input$bet_max == 6) {
      matrix_values <- matrix_values_6
    } else if (input$bet_max == 5) {
      matrix_values <- matrix_values_5
    } else if (input$bet_max == 4) {
      matrix_values <- matrix_values_4
    } else if (input$bet_max == 3) {
      matrix_values <- matrix_values_3
    } else if (input$bet_max == 2){
      matrix_values <- matrix_values_2
    }
    
    #create the matrix using the vector of matrix values and input settings
    m = matrix(matrix_values, input$bet_max+1, input$bet_max+1, byrow=TRUE)
    
    #update the row and column names so they display as 0...n
    rownames(m) = seq(0,input$bet_max)
    colnames(m) = seq(0,input$bet_max)
    
    #output the correct matrix with updated names
    return(m)
  })
  
  #one-hot vector describing the starting currency value
  gamblers_matrix <- reactive({ 
    
    #set all values to zero and length to the max bet + 1
    m_g<-rep(0,input$bet_max+1)
    
    #edit one value in the vector to a value of 1
    m_g[input$money_init+1]<-1
    
    #output the vector
    return(m_g)
    
    })
  
  #Button to trigger the gambling calculations
  gamble_action <- eventReactive(input$gamble_button, {
    
    #runif(input$gambles)
    
    #function to get the dot product of two matrices n times
    gamble <- function(m1,m2,n) {
      
      #for loop to cycle this calculation
      for (x in 1:n) {
        output = m2 %*% m1 
        m1 <- output
      }
      
      
      a <- seq(0,input$bet_max)  
      b <- output
      result <- data.frame(a,b)
      names(result)<-c("$", "Probabilities")

      return(result)
      
    }
    
    gamble(gamblers_matrix(),transition_matrix(),input$gambles)
 
  })
  
  node_graph <- eventReactive(input$bet_max, {
    # set.seed(10)
    # data <- matrix(sample(0:2, 9, replace=TRUE), nrow=3)
    # colnames(data) = rownames(data) = LETTERS[1:3]
    # 
    # # build the graph object
    # network <- graph_from_adjacency_matrix(data)
    # 
    # # plot it
    # plot(network,
    #      layout = layout_on_grid,
    #      vertex.size=15,
    #      vertex.label.dist=0.0,
    #      vertex.color="#eeeeee",
    #      edge.arrow.size=0.5)
    
    
    #===
    nodes <- paste((0:input$bet_max))
    x <- seq(0:input$bet_max)
    y <- rep(0,input$bet_max+1)

    if (input$bet_max == 6) {
      
      from <- c(0,1,1,2,2,3,3,4,4,5,5,6)
      to   <- c(0,0,2,1,3,2,4,3,5,4,6,6)
      
    } else if (input$bet_max == 5) {
      
      from <- c(0,1,1,2,2,3,3,4,4,5)
      to   <- c(0,0,2,1,3,2,4,3,5,5)
      
    } else if (input$bet_max == 4) {
      
      from <- c(0,1,1,2,2,3,3,4)
      to   <- c(0,0,2,1,3,2,4,4)
      
    } else if (input$bet_max == 3) {
      
      from <- c(0,1,1,2,2,3)
      to   <- c(0,0,2,1,3,3)
      
    } else if (input$bet_max == 2){
      
      from <- c(0,1,1,2)
      to   <- c(0,0,2,2)
      
    }
    
    NodeList <- data.frame(nodes, x ,y)
    EdgeList <- data.frame(from, to)
    a<- graph_from_data_frame(vertices = NodeList, d= EdgeList, directed = TRUE)
    
    #par(mar=c(0,0,0,0),bg="#ddddff")
    
    #bottom, left, top and right
    
    oldMargins<-par("mar")
    #par(mar=c(12,1,1,1),bg="#ddddff")
    par(mar=c(0,0,0,0),bg="#f5f5f5")
    plot(a,
         edge.loop.angle=c(3*pi/3,rep(0,2*(input$bet_max+1)-2),6*pi/3),
         edge.arrow.size=0.7, 
         margin=c(0.07,0,-1.85,0), #margins control "zoom" effect here (very sensitive)
         vertex.color="#337AB7", #vertex/node fill color
         edge.color="#2e6da4",
         vertex.label.color="#ffffff",
         vertex.label.cex=1.2,
         vertex.label.family = "arial",
         vertex.label.font = 2 
         ) 
    
    #plot(a,edge.loop.angle=c(3*pi/3,rep(0,2*(input$bet_max+1)-2),6*pi/3),edge.arrow.size=0.7)
    par(mar=oldMargins)
    
    #===
    
    
    
  })

  #=======
  #outputs
  #=======
  
  #display the slider setting values 
  output$output_values <- renderTable({
    values()
  })
  
  #display the transition matrix
  output$output_matrix <- renderTable({
    transition_matrix()
  }, rownames=TRUE, spacing=c("xs"))
  
  #display the gambler's one-hot vector of starting currency
  output$gambler_matrix <- renderTable({
   a <- seq(0,input$bet_max)  
   b <- gamblers_matrix()
   c <- data.frame(a,b)
   names(c)<-c("$", "Gambler's Vector")
   c
  })
  
  #the main output information
  output$result_matrix <- renderTable({
    
    #run the gambling calculation loop 
    gamble_action()
  })
  
  output$nodes <- renderPlot({
    
    #run the gambling calculation loop 
    node_graph()
    
  })
  

} #end server

# Run the application 
shinyApp(ui = ui, server = server)
