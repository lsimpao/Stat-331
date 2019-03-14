# load packages
library(tidyverse)
library(ggvis)
library(shiny)
library(readr)
library(RSQLite)

# load data
admitdec <- read_csv("Admissions_DATA.csv")
names(admitdec) <- c("serial","gre","toefl","univ_rate","state_purp","letter_rec","ug_gpa", "research_exp","decision")

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Admissions Prediction"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filter"),
             sliderInput("gre", "Minimum GRE Score",
                         290, 340, 290, step = 5),
             sliderInput("toefl", "Minimum TOEFL Score",
                         92, 120, 92, step = 2),
             sliderInput("ug_gpa", "Minimum GPA",
                         6.8, 9.92, 6.8, step = 0.2),
             sliderInput("state_purp", "Statement of Purpose Rating", 1, 5, value = c(1, 5),
                         step = 0.5),
             sliderInput("letter_rec", "Letter of Recommendation Rating",
                         1, 5, c(1, 5), step = 0.5)
           ),
           wellPanel(
             selectInput(inputId = "xvar", 
                         label = "X-axis variable", 
                         choices = c("GRE Score" = "gre",  
                                     "TOEFL Score" = "toefl", 
                                     "Undergraduate GPA" =  "ug_gpa"),
                         selected = "gre"),
             selectInput(inputId = "yvar", 
                         label = "Y-axis variable", 
                         choices = c("GRE Score" = "gre", 
                                     "TOEFL Score" = "toefl", 
                                     "Undergraduate GPA" =  "ug_gpa"), 
                         selected = "toefl")
           )
    ),
    column(9,
           ggvisOutput("plot1")
    )
  )
)