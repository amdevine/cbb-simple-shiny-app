library(tidyverse)
library(data.table)
library(shiny)

# Downloads data if needed, then reads it into object ndata
if(!file.exists("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")) {
    download.file("https://opendata.maryland.gov/api/views/rsrj-4w3t/rows.csv?accessType=DOWNLOAD", 
                  destfile = "Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")
}
ndata <- fread("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")

# Reshape n_data into a tidy format
ndata <- ndata %>%
    gather(key = 'Year', value = 'Total_N_lb', -(`Land-River Segment`:`Source Sector`)) %>%
    mutate(Year = as.numeric(str_extract(Year, "\\d{4}")))

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Chesapeake Bay Pollution Data (Nitrogen)"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          radioButtons("groupvar", "View summary by",
                       c("County" = "County",
                         "Tributary basin" = "Tributary Basin",
                         "Source type" = "Source Sector",
                         "Year" = "Year"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("nitrogen_plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$nitrogen_plot <- renderPlot({
      
      # generate dataset based on grouping variable selected
      ndata_grouped <- ndata %>% 
          select(!!as.name(input$groupvar), Total_N_lb) %>%
          group_by(!!as.name(input$groupvar)) %>%
          summarise(total_nitrogen = sum(Total_N_lb, na.rm = TRUE)) %>%
          ungroup() %>%
          arrange(desc(total_nitrogen))
      
      print(input$groupvar)
      print(head(ndata_grouped))
      
      # draw bar plot based on grouping variable
      ggplot(ndata_grouped, aes(x = !!as.name(input$groupvar), y = total_nitrogen)) +
          geom_col()
          
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

