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
----------------------------

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

Customize your Shiny app with your own data and visualizations
------------------------------------------------------------------

Dataset: https://opendata.maryland.gov/Energy-and-Environment/Chesapeake-Bay-Pollution-Loads-Nitrogen/rsrj-4w3t

Delete comments at the top on lines 1-8.

Import `dplyr` and `ggplot2`.

~~~
library(dplyr)
library(ggplot2)
~~~

Reactivity: https://shiny.rstudio.com/articles/reactivity-overview.html




