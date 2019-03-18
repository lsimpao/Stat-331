library(tidyverse)
library(readr)
titanic <- read.csv('https://www.dropbox.com/s/volbfu8onyvjcri/titanic.csv?dl=1')

# Define a server for the Shiny app
function(input, output) {
  
  # Fill in the spot we created for a plot
  output$classPlot <- renderPlot({
    
    titanic %>% 
    filter(Pclass == input$Pclass) %>%
    
    # Render a density plot
    ggplot(aes(x = Fare, fill = Sex)) + 
      geom_density(alpha = 0.5) + 
      xlab("Fare") + 
      ylab("density")
    
  })
}