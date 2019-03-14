# load packages
library(tidyverse)
library(ggvis)
library(shiny)
library(readr)
library(RSQLite)

# load data

admitdec <- read_csv("Admissions_DATA.csv")
names(admitdec) <- c("serial","gre","toefl","univ_rate","state_purp","letter_rec","ug_gpa", "research_exp","decision")

function(input, output, session) {
  
# filter admissions_DATA, returning a data frame

    admit <- reactive({
    
    GRE <- input$gre
    TOEFL <- input$toefl
    GPA <- input$ug_gpa
    minSTATE <- input$state_purp[1]
    maxSTATE <- input$state_purp[2]
    minREC <- input$letter_rec[1]
    maxREC <- input$letter_rec[2]
    
# apply filters
    m <- admitdec %>%
      filter(
        gre >= GRE,
        toefl >= TOEFL,
        ug_gpa >= GPA,
        state_purp >= minSTATE,
        state_purp <= maxSTATE,
        letter_rec >= minREC,
        letter_rec <= maxREC
      ) %>%
      arrange(decision)
    
    m <- as.data.frame(m)
    
# add column for final admissions decision
    
    m$admitted <- m$decision
    m$admitted[m$decision == 0] <- "Rejected"
    m$admitted[m$decision == 0.5] <- "Waitlisted"
    m$admitted[m$decision >= 1] <- "Admitted"
    m
  })
  
# reactive expression with the ggvis plot
    
  vis <- reactive({
    
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    admit %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~admitted) %>%
      add_legend("stroke", title = "Admission Decision", values = c("Admitted", "Waitlisted", "Rejected")) %>%
      scale_nominal("stroke", domain = c("Admitted", "Waitlisted", "Rejected"),
                    range = c("limegreen", "orange", "#aaa")) %>%
      set_options(width = 500, height = 500)
  })
  
  vis %>% bind_shiny("plot1")

}