library(tidyverse)
library(scales)
library(shiny)

# Download data if file does not already exist
if(!file.exists("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")) {
    download.file("https://opendata.maryland.gov/api/views/rsrj-4w3t/rows.csv?accessType=DOWNLOAD", 
                  destfile = "Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")
}


# Read and reshape data into a tidy format
ndata <- read_csv("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv") %>%
    gather(key = 'Year', value = 'Total_N_lb', -(`Land-River Segment`:`Source Sector`)) %>%
    mutate(Year = str_extract(Year, "\\d{4}")) %>%
    filter(Year >= 2007, Year <= 2016)


# Define UI for application
ui <- fluidPage(
   
   # Application title
   titlePanel("Chesapeake Bay Pollution Data (Nitrogen), 2007-2016"),
   
   # Specifies Shiny layout sidebarLayout - 1 sidebar panel, 1 main panel
   sidebarLayout(
      
      # Sidebar with text and display options
      sidebarPanel(
          width = 3,
          p(paste("Data represent nitrogen pollution (pounds) from contributing sources",
                  "in the Chesapeake Bay watershed from 2007 to 2016.", 
                  "More information can be found at the link below.")),
          a(href="https://opendata.maryland.gov/Energy-and-Environment/Chesapeake-Bay-Pollution-Loads-Nitrogen/rsrj-4w3t", 
            "Maryland Open Data Portal: Chesapeake Bay Pollution Loads - Nitrogen"),
          hr(),
          radioButtons("groupvar", "Show totals by",
                       c("County" = "County",
                         "Tributary basin" = "Tributary Basin",
                         "Major basin" = "Major Basin",
                         "Source type" = "Source Sector",
                         "Year" = "Year"))
      ),
      
      # Show graph nitrogen_plot (defined in server function)
      mainPanel(
         width = 9,
         plotOutput("nitrogen_plot", height = "800px")
      )
   )
)

# Define server logic required to draw graph
server <- function(input, output) {
   
   output$nitrogen_plot <- renderPlot({
         
      # generate dataset based on grouping variable selected
      ndata_grouped <- ndata %>% 
         select(!!as.name(input$groupvar), Total_N_lb) %>%
         group_by(!!as.name(input$groupvar)) %>%
         summarise(total_nitrogen = sum(Total_N_lb, na.rm = TRUE))
         
      # draw bar plot based on grouping variable
      ggplot(ndata_grouped, aes(x = !!as.name(input$groupvar), y = total_nitrogen)) +
         geom_col(fill = "darkslategray4") +
         scale_x_discrete(labels = wrap_format(15)) +
         scale_y_continuous(name = "Total nitrogen (lbs)", 
                            labels = unit_format(unit = "M", scale = 10e-7)) +
         theme_minimal() +
         theme(text = element_text(size = 20),
               axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
               legend.position = "none")
   })
}

# Run the application! 
shinyApp(ui = ui, server = server)

