Creating a simple web application in R with Shiny
=====================================================

This repository contains instructions and code for creating a simple RStudio Shiny application that shows sources of nitrogen pollution of the Chesapeake Bay.

An instance of this application can be found here: https://si-carpentries-brown-bag.shinyapps.io/chesapeake-bay/

This material was presented at the Smithsonian Carpentries Brown Bag on December 5, 2019.

Terminology
---------------

**Shiny** is an R package that creates the code for interactive web applications. Official documentation for getting started with Shiny can be found here: https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/. 

**rsconnect** is an R package that deploys Shiny apps on shinyapps.io.

**shinyapps.io** is a website that hosts applications created with Shiny. Shiny apps can be hosted on shinyapps.io or elsewhere. Documentation for deploying an app on shinyapps.io can be found here: https://shiny.rstudio.com/articles/shinyapps.html

Set up RStudio
------------------

We will be working in RStudio for this demonstration. Shiny is developed by RStudio, and RStudio provides some nice tools to create Shiny apps easily.

### Install required packages

In the RStudio Console, install the `shiny` and `rsconnect` packages.

~~~
install.packages(c("shiny", "rsconnect"))
~~~

We will be using rsconnect interactively in the Console, so import it with 

~~~
library(rsconnect)
~~~

Additionally, we will be cleaning data and producing a graph using the `tidyverse` and `scales` packages. If you do not already have these, install them as well.

~~~
install.packages(c("tidyverse", "scales"))
~~~

### Set up project and `app.R` file

Create a new project using File > New Project. Choose the option to create a New Directory, and for Project Type, choose **New Project**. (There is an option to create a new Shiny Web Application, which creates a default application. For this demonstration, we'll be creating our application from scratch instead.)

The **Directory name** you enter will end up being incorporated into the URL of your app, so choose carefully!

Once your project has been created, create a new R Script file (File > New File > R Script) and save it with the name `app.R`. This file will contain all the code for our application.

Configure shinyapps.io
--------------------------

shinyapps.io (https://www.shinyapps.io/) is a website produced by RStudio that provides free hosting for Shiny applications.

**Don't use shinyapps.io with sensitive Smithsonian data!** The Smithsonian hosts its own server for Shiny apps, with improved security and protections. If you would like more details, please contact SI-DataScience.

### Create a shinyapps.io account

You can sign up for a free Shiny account at https://www.shinyapps.io/admin/#/signup. 

After supplying your email and password, shinyapps will ask you to select an account name. This will be incorporated into the URL for your application, so choose wisely!

### Connect your Shiny application to shinyapps.io

Once you have entered an account name, you will be taken to a new page containing *Getting Started* directions. 

We already completed *Step 1 - Install rsconnect* in the *Set up RStudio* section above.

*Step 2 - Authorize Account* provides code to connect your application to shinyapps.io. Use the *Copy to clipboard* button to copy and paste this text into your RStudio Console, then run this command.

It should look something like this:

~~~
rsconnect::setAccountInfo(name='<account name>',
                          token='<alphanumeric string>',
                          secret='<alphanumeric string>')
~~~

If you need to find this authorization information again in the future, it can be found under Account >> Tokens. Click the *Show* button next to the existing token.

Ignore *Step 3 - Deploy* for now. We'll deploy once we create our app!

Create Shiny application
----------------------------

We will now write the code for our application in the `app.R` file we previously created. As we go through this demo, continue to add code to this file.

### Import required packages

Our first step will be to import the packages we need for our application. 

~~~
library(shiny)
library(tidyverse)
library(scales)
~~~

`shiny` is used to turn our R code into HTML+CSS to encode a website. `tidyverse` provides several packages for data manipulation, as well as ggplot for plotting. `scales` provides additional tools for formatting ggplot figures.

### Download data file

The dataset we are using for this application is a dataset showing the amount of nitrogen added to the Chesapeake Bay over a ~10 year timespan. Pollution sources are identified by county, basin, and the pollution source (e.g. agricultural, septic, wastewater). Details about this data source can be found here: https://opendata.maryland.gov/Energy-and-Environment/Chesapeake-Bay-Pollution-Loads-Nitrogen/rsrj-4w3t

We will next add code that downloads the data as a CSV file, if it does not already exist.

~~~
if(!file.exists("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")) {
    download.file("https://opendata.maryland.gov/api/views/rsrj-4w3t/rows.csv?accessType=DOWNLOAD", 
                  destfile = "Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")
}
~~~

`file.exists()` checks whether the file exists or not. `download.file` downloads the file from the specified url and saves it as `Chesapeake_Bay_Pollution_Loads_Nitrogen.csv`.

### Import and clean data

Next, we will import the data from the CSV file into R. 

~~~
ndata <- read_csv("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")
~~~

Note, this is the `dplyr::read_csv()` function, NOT the built-in `read.csv()` function. 

If you look at the CSV file, you will see that the data are currently stored in a "wide" format that does not adhere to the principles of [tidy data](https://vita.had.co.nz/papers/tidy-data.pdf). The current format makes it hard for us to calculate totals by different factors like county, pollution source, or year. We will use the `gather()` function to reshape our data, moving the results columns associated with each year into a new column, `Year`, and extracting the date.

~~~
ndata <- read_csv("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv") %>%
    gather(key = 'Year', value = 'Total_N_lb', -(`Land-River Segment`:`Source Sector`)) %>%
    mutate(Year = str_extract(Year, "\\d{4}"))
~~~

`str_extract()` uses regular expressions to extract sequences of characters from strings. We are using it here to retrieve four digit segments and set those as the Years. Don't forget to add the `%>%` operator after each step!

Finally, our reshaped data include some extraneous results. We have results for 1985, which is outside our time period of interest. We also have results for 2017 and 2025, which are target goals rather than actual measurements. We'll add a `filter()` clause to filter our data by year.

~~~
ndata <- read_csv("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv") %>%
    gather(key = 'Year', value = 'Total_N_lb', -(`Land-River Segment`:`Source Sector`)) %>%
    mutate(Year = str_extract(Year, "\\d{4}")) %>%
    filter(Year >= 2007, Year <= 2016)
~~~

We have now installed all requisite packages, and our data are clean and tidy. Your `app.R` file should currently look like this:

~~~
library(shiny)
library(tidyverse)
library(scales)

if(!file.exists("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")) {
    download.file("https://opendata.maryland.gov/api/views/rsrj-4w3t/rows.csv?accessType=DOWNLOAD", 
                  destfile = "Chesapeake_Bay_Pollution_Loads_Nitrogen.csv")
}

ndata <- read_csv("Chesapeake_Bay_Pollution_Loads_Nitrogen.csv") %>%
    gather(key = 'Year', value = 'Total_N_lb', -(`Land-River Segment`:`Source Sector`)) %>%
    mutate(Year = str_extract(Year, "\\d{4}")) %>%
    filter(Year >= 2007, Year <= 2016)
~~~

### Create the application UI

Shiny applications have two required components: a `ui` object that stores the structure of the application, and a `server` function that stores the logic of the application. These components talk back and forth to each other, creating an interactive application.

The UI is created with a series of nested functions, each roughly corresponding to an HTML element. Our general structure will be a container for all our elements, a box for our title, a sidebar for our controls, and a main window showing our graph.

For this demo, we will be creating a `fluidPage()`, which allows elements to move around when the window is resized.

~~~
ui <- fluidPage()
~~~

Next, we will add our `titlePanel`, containing the application title, nested inside our fluidPage.

~~~
ui <- fluidPage(
	titlePanel("Chesapeake Bay Pollution Data (Nitrogen), 2007-2016")
)
~~~

After that, we will add `sidebarLayout()`, a function that tells Shiny we would like a layout for our page that includes a sidebar and a main window.

~~~
ui <- fluidPage(
	titlePanel("Chesapeake Bay Pollution Data (Nitrogen), 2007-2016"),
	sidebarLayout()
)
~~~

Don't forget commas! Multiple elements inside e.g. fluidPage need to be separated with commas.

Now, we want to add the `sidebarPanel()` and `mainPanel()` elements to our layout. We can use the `width` argument in these panels to set the proportional width each one takes up. Widths need to sum to 12 for all panels. 

~~~
ui <- fluidPage(
	titlePanel("Chesapeake Bay Pollution Data (Nitrogen), 2007-2016"),
	sidebarLayout(
		sidebarPanel(width = 3),
		mainPanel(width = 9)
	)
)
~~~

Now that we've established the overall layout of our application, we can add content to our sidebar and main panels.

#### sidebarPanel()

We will add content to our sidebar by continuing to nest functions inside the `sidebarPanel()` function. Many of the functions Shiny contains are functions that create specific HTML elements. A detailed list can be found [here](https://shiny.rstudio.com/articles/tag-glossary.html).

First, we will add some text to the sidebar, as a brief explanation of the application. 



#### mainPanel()



Reactivity: https://shiny.rstudio.com/articles/reactivity-overview.html




