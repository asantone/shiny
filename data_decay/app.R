# ==============================================================================
# PROJECT   : Data Decay & Revenue Leakage Analytics Simulation
# AUTHOR    : Adam Santone, PhD
# DATE      : March 19, 2026
# VERSION   : 1.0.0
# ------------------------------------------------------------------------------
# PURPOSE   : A strategic B2B decision-support tool designed to visualize 
#             "Value Erosion Dynamics" and the financial impact of 
#             Firmographic Data Obsolescence within enterprise environments.
#
# LICENSE   : MIT License | Copyright (c) 2026 Adam Santone, PhD
#             Permission is hereby granted, free of charge, provided that the 
#             above copyright notice and this permission notice are included 
#             in all copies or substantial portions of the Software.
# ==============================================================================

library(shiny)
library(ggplot2)
library(gridExtra)
library(bslib)
library(viridis)
library(magrittr)
library(scales)
library(dplyr)

# Custom Labeling Function for Financial Data
format_wealth <- function(x) {
  ifelse(abs(x) >= 1000, 
         paste0("$", format(round(x/1000, 2), nsmall = 2), "B"), 
         paste0("$", round(x, 0), "M"))
}

ui <- page_navbar(
  theme = bs_theme(
    version = 5,
    bootswatch = "slate",
    primary = "#377eb8",   
    base_font = font_google("Inter")
  ) %>% 
    bs_add_rules("
      .navbar.navbar-static-top, .navbar {
        background-color: #272b30 !important; 
        background-image: none !important;    
        box-shadow: none !important;          
        border-bottom: 1px solid #3e444c !important; 
      }
      .navbar-brand {
        text-shadow: none !important;
        -webkit-text-shadow: none !important;
        color: #ffffff !important;
        font-weight: 400 !important;
        pointer-events: none;
      }
      .nav-link {
        text-shadow: none !important;
        border: none !important; 
        color: #999999 !important;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 0.5px;
      }
      .nav-link.active {
        color: #00E1FF !important;
        font-weight: 500 !important;
        background-color: transparent !important;
        border-bottom: 2px solid #00E1FF !important;
      }
      .navbar-nav .nav-item:first-child { margin-left: 30px !important; }
      
      h4 {
        font-size: 0.95rem !important;
        margin-top: 5px !important;    
        margin-bottom: 10px !important;
        text-transform: uppercase;     
        letter-spacing: 1px;
        color: #00E1FF !important;
        font-weight: 700;
        border-bottom: 1px solid #3e444c;
        padding-bottom: 5px;
      }
      
      .control-label { font-size: 0.9rem !important; color: #ced4da; }
      .card-header {
        color: #00E1FF !important;
        font-weight: 400 !important;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem !important;
        background-color: #32383e !important; 
        background-image: none !important;    
        border-bottom: 1px solid #3e444c !important;
        padding: 10px 15px !important;
      }
      .card p {
        color: #eeeeee !important;
        font-size: 0.95rem !important;
        line-height: 1.6 !important;
        margin-bottom: 15px !important;
      }
      blockquote {
        color: #00E1FF !important;
        font-family: monospace;
        background-color: #1c1e22;
        padding: 10px;
        border-radius: 5px;
        border-left: 3px solid #00E1FF;
      }
      strong {
        color: #00E1FF !important;   /* Makes bold text the same 'Success Green' as your Big Number */
        font-weight: 400 !important;
        letter-spacing: 0.3px;
      }
      /* Styling the 'Fill' (the part of the bar that is selected) */
.irs--shiny .irs-bar {
  background: #00E1FF !important;
  border-top: 1px solid #00E1FF !important;
  border-bottom: 1px solid #00E1FF !important;
}

/* Styling the 'Handle' (the circle you grab) */
.irs--shiny .irs-single, .irs--shiny .irs-handle {
  background-color: #00E1FF !important;
  border: 1px solid #00E1FF !important;
}

/* Optional: Make the handle glow slightly when hovered */
.irs--shiny .irs-handle:hover {
  box-shadow: 0 0 10px #00E1FF !important;
}
/* Change the text color inside the slider labels to Dark Gray */
.irs--shiny .irs-single, 
.irs--shiny .irs-from, 
.irs--shiny .irs-to, 
.irs--shiny .irs-bar-edge {
  color: #1a1a1a !important;   /* Deep charcoal for maximum legibility */
  background-color: #00E1FF !important; /* Matches your Cyan */
  font-weight: 700 !important;  /* Bold makes the numbers even clearer */
}

/* Ensure the little 'arrow' at the bottom of the label also matches Cyan */
.irs--shiny .irs-single:after, 
.irs--shiny .irs-from:after, 
.irs--shiny .irs-to:after {
  border-top-color: #00E1FF !important;
}
h1 {
  font-size: 3.0rem !important;   /* Increase this number to go even bigger */
  font-weight: 600 !important;
  line-height: 1.0 !important;
  margin: 0 !important;
  letter-spacing: -1px;          /* Tighter tracking looks more 'premium' for big numbers */
  color: #FFFFFF !important;
}
    "),
  
  title = "Data Decay & Revenue Leakage Analytics",
  
  nav_panel(
    title = "Analytics Dashboard",
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        h4("Firmographics"),
        sliderInput("revenue", "Annual Revenue ($M):", min = 1, max = 1000, value = 100, step = 5),
        sliderInput("start_val", "Records (Millions):", min = 1, max = 500, value = 100),

        h4("Value Erosion Dynamics"),
        sliderInput("loss_rate", "Revenue Loss Impact (%):", min = 0, max = 100, value = 15, step = 1),
        sliderInput("annual_decay", "Annual Decay Rate (%):", min = 0, max = 100, value = 30, step = 1),
        
        h4("Strategic Mitigation & Forecast"),
        sliderInput("enrichment", "Enrichment Effectiveness (%):", min = 0, max = 100, value = 95, step = 1),
        sliderInput("months", "Simulation Horizon (Months):", min = 12, max = 60, value = 60, step = 1),
        
        hr(style = "border-top: 1px solid #3e444c; margin-top: 0px;"),
        div(style = "font-size: 0.75rem; color: #6c757d; text-align: center;",
            "Simulation by",
            span("Adam Santone, PhD", style = "color: #00E1FF; font-weight: 400;"))
      ),
      card(
        style = "background-color: #272b30; margin-bottom: 20px; border: none;",
        height = "200px",
        htmlOutput("valueSummary")
      ),
      card(
        full_screen = TRUE,
        style = "background-color: #222222; border: none;",
        plotOutput("combinedPlot", height = "1000px")
      )
    )
  ),
  
  nav_panel(
    title = "Simulation Logic",
    layout_column_wrap(
      width = 1/3, 
      fill = FALSE,
      card(
        card_header("Chart 1: Database Integrity"),
        p(strong("Visualizes Firmographic Health."), "Tracks the erosion of your total addressable market (TAM) over time."),
        p("The ", span("Baseline (Neon Yellow)", style="color:#CCFF00;"), " curve shows natural obsolescence. The ", span("Active Enrichment (Cyan)", style="color:#00E1FF;"), " curve demonstrates how proactive mitigation preserves usable record volume.")
      ),
      card(
        card_header("Chart 2: Revenue Leakage"),
        p(strong("Visualizes Value Erosion."), "Converts data degradation into a direct financial penalty."),
        p("It calculates the ", strong("Revenue Leakage Multiplier"), "—the exact amount of capital vanishing every 30 days. As obsolescence compounds, this monthly penalty accelerates, proving that the cost of inaction is non-linear.")
      ),
      card(
        card_header("Chart 3: Cumulative Protection"),
        p(strong("Visualizes Strategic Yield."), "The financial anchor of the simulation."),
        p("Summing the gap between Baseline and Active curves reveals the ", strong("Total Cumulative Revenue Protection."), " This represents the 'Recovered Revenue' shielded from decay through your enrichment strategy.")
      )
    ),
    hr(style = "border-top: 1px solid #3e444c; margin: 40px 0;"),
    layout_column_wrap(
      width = 1/2,
      fill = FALSE,
      card(
        card_header("The Obsolescence Model"),
        p("We utilize an exponential decay formula to model real-world firmographic degradation:"),
        tags$blockquote("Records(t) = Records(0) * e^(-λt)"),
        p("Lambda (λ) is derived from your 'Obsolescence Rate' to provide a consistent monthly velocity.")
      ),
      card(
        card_header("Revenue Impact Logic"),
        p("Revenue leakage is tied directly to the health of the 'Firmographic Inventory'. As valid records decrease, the 'Leakage Multiplier' is applied to the missing volume, simulating lost sales opportunities and marketing waste.")
      )
    )
  )
)

server <- function(input, output) {
  
  calc_data <- reactive({
    months <- 0:input$months
    lambda_natural <- -log(1 - (input$annual_decay / 100)) / 12
    eff_rate <- (input$annual_decay / 100) * (1 - (input$enrichment / 100))
    lambda_effective <- -log(1 - eff_rate) / 12
    
    natural_rec <- input$start_val * exp(-lambda_natural * months)
    enriched_rec <- input$start_val * exp(-lambda_effective * months)
    max_loss <- input$revenue * (input$loss_rate / 100)
    
    base_loss <- max_loss * (1 - (natural_rec/input$start_val))
    enr_loss <- max_loss * (1 - (enriched_rec/input$start_val))
    cum_prot <- cumsum(base_loss - enr_loss)
    
    data.frame(
      Month = rep(months, 2),
      Records = c(natural_rec, enriched_rec),
      RevLoss = c(base_loss, enr_loss),
      CumProtection = rep(cum_prot, 2),
      Type = rep(c("Baseline (No Action)", "Active Enrichment"), each = length(months))
    )
  })
  
  output$valueSummary <- renderUI({
    df <- calc_data()
    total_saved <- max(df$CumProtection)
    formatted_total <- format_wealth(total_saved)
    
    # Adjusted container to be tighter (min-height: 120px)
    div(style = "min-height: 100px; display: flex; flex-direction: column; justify-content: center; padding-left: 20px; padding-right: 20px;",
        
        # 1. Header (Smaller font: 0.75rem)
        h5(paste0("Total Cumulative Revenue Protection"), 
           style = "color: #FFFFFF; margin-bottom: 5px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; font-size: 0.75rem;"),
        
        # 2. Big Number Row (Reduced Arrow to 1.8rem and H1 to 2.8rem)
        div(style = "display: flex; align-items: center; gap: 12px; margin-bottom: 10px;",
            #span("↗", style = "color: #00E1FF; font-size: 1.8rem; font-weight: bold; line-height: 1;"),
            h1(formatted_total)
        ),
        
        # 3. Compact Legend Row
        div(style = "display: flex; gap: 20px; align-items: center; border-top: 1px solid #3e444c; padding-top: 5px;",
            
            # Cyan Key
            div(style = "display: flex; align-items: center; gap: 6px;",
                div(style = "width: 10px; height: 10px; border-radius: 2px; background-color: #00E1FF;"),
                span("Active Enrichment", style = "color: #00E1FF; font-size: 0.8rem; font-weight: 400; text-transform: uppercase;")
            ),
            
            # Yellow Key
            div(style = "display: flex; align-items: center; gap: 6px;",
                div(style = "width: 10px; height: 10px; border-radius: 2px; background-color: #CCFF00;"),
                span("Baseline Decay", style = "color: #CCFF00; font-size: 0.8rem; font-weight: 400; text-transform: uppercase;")
            )
        )
    )
  })
  
  output$combinedPlot <- renderPlot({
    df <- calc_data()
    
    dark_theme <- theme_minimal(base_size = 16) + 
      theme(
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.background = element_rect(fill = "#222222", color = NA),
        text = element_text(color = "#e0e0e0", family = "Inter"),
        axis.text = element_text(color = "#b0b0b0", size = 12),
        axis.title = element_text(size = 14, face = "bold"),
        panel.grid.major.y = element_line(color = "#333333"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        legend.position = "bottom",
        plot.title = element_text(size = 18, face = "bold", color = "#00E1FF")
      )
    
    # For Chart 1 (Records)
    p1 <- ggplot(df, aes(x = Month, y = Records, color = Type)) +
      geom_line(linewidth = 2) +
      # NEW: Manual color scale
      scale_color_manual(values = c("Baseline (No Action)" = "#CCFF00", 
                                    "Active Enrichment" = "#00E1FF")) +
      dark_theme + labs(title = "Database Integrity (Monthly Records)", y = "Millions") +
      theme(legend.position = "none", axis.title.x = element_blank())
    
    # For Chart 2 (Revenue Leakage)
    p2 <- ggplot(df, aes(x = Month, y = RevLoss, color = Type)) +
      geom_line(linewidth = 2) +
      # NEW: Manual color scale
      scale_color_manual(values = c("Baseline (No Action)" = "#CCFF00", 
                                    "Active Enrichment" = "#00E1FF")) +
      scale_y_continuous(labels = label_dollar(suffix = "M")) +
      dark_theme + labs(title = "Revenue Leakage (Monthly Rate)", y = "Loss Rate") +
      theme(legend.position = "none", axis.title.x = element_blank())
    
    df_cum <- subset(df, Type == "Active Enrichment")
    p3 <- ggplot(df_cum, aes(x = Month, y = CumProtection)) +
      geom_area(fill = "#00E1FF", alpha = 0.2) +
      geom_line(color = "#00E1FF", linewidth = 2) +
      scale_y_continuous(labels = format_wealth) + 
      dark_theme + 
      labs(title = "Total Cumulative Revenue Protection", x = "Months Elapsed", y = "Total Saved")
    
    grid.arrange(p1, p2, p3, ncol = 1)
  }, bg = "#222222")
}

shinyApp(ui = ui, server = server)