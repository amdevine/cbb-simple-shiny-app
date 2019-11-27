Creating a simple web application in R with Shiny
=====================================================

This repository contains instructions and code for creating a simple RStudio Shiny application. This material was presented at the Smithsonian Carpentries Brown Bag on December 5, 2019.

Terminology
---------------

**Shiny** is an R package that creates the code for interactive web applications. Official documentation for getting started with Shiny can be found here: https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/. 

**rsconnect** is an R package that deploys Shiny apps on shinyapps.io.

**shinyapps.io** is a website that hosts the applications created by Shiny. Shiny apps can be hosted on shinyapps.io or elsewhere. 

Set up RStudio
------------------

We will be working in RStudio for this demonstration. Shiny is developed by RStudio, and RStudio provides some nice tools to create Shiny apps easily.

In the RStudio Console, install the `shiny` and `rsconnect` packages.

~~~
install.packages(c("shiny", "rsconnect"))
~~~

Next, create a new Shiny application. This can be done with **File -> New Project... -> New Directory -> Shiny Web Application**. Your Directory name will be included in the URL of your application, so choose your directory name wisely!

Once the new application has been created, you will see a new file opened in your Source window called `app.R`. This file currently contains a demo Shiny application. In a bit, we will edit this file to create our own application.

Configure shinyapps.io
----------------------------

shinyapps.io (https://www.shinyapps.io/) is a website produced by RStudio that provides free hosting for Shiny applications.

**Don't use shinyapps.io with sensitive Smithsonian data!** The Smithsonian hosts its own server for Shiny apps, with improved security and protections. If you would like more details, please contact SI-DataScience.

### Create a shinyapps.io account

You can sign up for a free Shiny account at https://www.shinyapps.io/admin/#/signup. 

After supplying your email and password, Shinyapps will ask you to select an account name. This will be the URL subdomain people use to access your app, so choose wisely!

### Connect your Shiny application to shinyapps.io

Once you have selected an account name, you will be taken to a new page containing *Getting Started* directions. 

We already completed *Step 1 - Install rsconnect* in the *Set up RStudio* section above.

*Step 2 - Authorize Account* provides code to connect your application to shinyapps.io. Use the *Copy to clipboard* button to copy and paste this text into your RStudio Console, then run this command.

*Step 3 - Deploy* allows you to deploy a demo application to shinyapps.io. In your RStudio Console, run the following commands:

~~~
library(rsconnect)
deployApp()
~~~

Once this command finishes executing, you should be able to see your demo Shiny app available on shinyapps.io!

e.g. https://si-carpentries-brown-bag.shinyapps.io/chesapeake-bay/

Customize your Shiny app with your own data and visualizations
------------------------------------------------------------------

Dataset: https://opendata.maryland.gov/Energy-and-Environment/Chesapeake-Bay-Pollution-Loads-Nitrogen/rsrj-4w3t

Delete comments at the top on lines 1-8.

Import `dplyr` and `ggplot2`.

~~~
library(dplyr)
library(ggplot2)
~~~





