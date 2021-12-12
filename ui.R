library(shiny)
library(shinythemes)
library(shinyWidgets)
# Read the dataset set
df <- read.csv("occupancy.csv", header = TRUE)




ui <- fluidPage(
  theme = shinytheme("cerulean"),
  setBackgroundImage(
    src = "https://i.ibb.co/z8WR9q9/Untitled-design.png"
  ),
  
  navbarPage(
    # theme = "cerulean",  # <--- To use a theme,
    "Building Occupancy Detection",
    tabPanel("Home", style="color:white; font-size:18px", 
    fluidRow(
      column(8, align="center", offset = 2,
      HTML(
        "
     
        <section class='banner'>
        <h2 class='parallax'>Occupancy prediction using sensor data</h2>
        </section>
          "
        )
      )
    ),
    
    fluidRow(
      column(8, align="center", offset = 2,
             HTML(
               "
     
        <section class='banner'>
        <p class='parallax_description'>A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond. A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.A career path pinpoints your next job, the job
        after that, and beyond.</p>
        </section>
          "
             ),
             tags$head(tags$style(
               type="text/css",
               "#img img {max-width: 80%; width: 80%; height: auto; padding: 20px}"
             )),
             uiOutput("img")
             
             
      )
    )
    ),
    tabPanel(
      "Occupancy Prediction",
      sidebarPanel(
        HTML("<h3>Input Sensor Parameters</h3>"),
        sliderInput(
          "temperature",
          label = "Temperature",
          value = 19.6,
          min = min(df$Temperature),
          max = round(max(df$Temperature, digits = 4))
        ),
        sliderInput(
          "humidity",
          label = "Humidity",
          value = 19.4,
          min = min(df$Humidity),
          max = max(df$Humidity)
        ),
        sliderInput(
          "light",
          label = "Light",
          value = 260,
          min = min(df$Light),
          max = max(df$Light)
        ),
        sliderInput(
          "co2",
          label = "CO2",
          value = 1033,
          min = min(df$CO2),
          max = max(df$CO2)
        ),
        sliderInput(
          "humidityRatio",
          label = "Humidity Ratio",
          value = 0.00492,
          min = round(min(df$HumidityRatio), digits = 4),
          max = round(max(df$HumidityRatio), digits = 4)
        ),
        selectInput(
          "period",
          label = "Period of Day:",
          choices = list(
            "daytime" = "daytime",
            "eveningtime" = "eveningtime",
            "lateevening" = "lateevening",
            "earlydaytime" = "earlydaytime"
          ),
          selected = "Rainy"
        ),
        
        actionButton("submitbutton", "Make Prediction", class = "btn btn-primary")
      ),
      # sidebarPanel
      mainPanel(
        tags$label(h4('Prediction From Sensor Parameters')),
        # Status/Output Text Box
        
        verbatimTextOutput('contents'),
        
        tags$label(style="background-color:white",tableOutput('tabledata')),
        # Prediction results table
        htmlOutput(style="background-color:white ; padding:13px;", "explain")
        #tags$label(h4('Accuracy Scores with different k-values')),
        #verbatimTextOutput('plotcontents'),
        #plotOutput(outputId = "knnplot")
        
        
        
      ) # mainPanel
      
    ),
    # Navbar 1, tabPanel
    tabPanel(
      "Data Exploration",
      sidebarPanel(
        # Input: Slider for the number of bins ----
        sliderInput(
          inputId = "bins",
          label = "The histogram plot for the temperature variable can be observed on the right. Using the slider, the number of bins can be adjusted.
                                It seems to follow a normal distribution. However, it has a tail which indicates the possible presence of outliers.",
          min = 1,
          max = 50,
          value = 30,
          step = 2
        )
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(# Output: Histogram ----
                plotOutput(outputId = "distPlot"), style='background-color:white;
                     '),
      sidebarPanel(
        "The pie plot is used to visualize the percentage of observations for each of the time periods.
                    For instance, in the entire dataset used, the earlydaytime and lateevening had 26.26% observations recorded.
                    The least was daytime, with 22.04% observation records"
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(# Output: Histogram ----
                plotOutput(outputId = "piePlot"), style='background-color:white;
                     margin-top: 10px; margin-bottom: 10px'),
      sidebarPanel(
        "Furthermore, the time period distribution for the two classes(occupied and not occupied) can be observed in the barplot.
                    Starting with the first bar, there were more occupancy during the daytime. The second bar goes on to show that in the earlydaytime,
                    very few  offices are occupied. For the eveningtime represented by the third bar, more offices were begining to get be unoccupied.
                    Then in the lateevening as shown in the fourth bar, all offices are empty as most people don't work at that time."
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(# Output: Histogram ----
                plotOutput(outputId = "daytime"), style='background-color:white;
                     margin-bottom: 10px'),
      sidebarPanel(
        "The correllation plot, is used to show the relationship between the data variables.
                    The Light has a strong positive correlation with Occupancy class variable, followed by temperature and CO2.
                    On the other hand, the Humidity variable has no correlation with the Occupancy class variable.
                    This can give a hint on the variables that will be more important during the model training and classification of observations."
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(# Output: Histogram ----
                plotOutput(outputId = "corr"), style='background-color:white;
                      margin-bottom: 50px')
    )#,
    #tabPanel("Navbar 3", "This panel is intentionally left blank")
    
  ), # navbarPage
  tags$head(
    HTML(
      "
          <script>
          var socket_timeout_interval
          var n = 0
          $(document).on('shiny:connected', function(event) {
          socket_timeout_interval = setInterval(function(){
          Shiny.onInputChange('count', n++)
          }, 15000)
          });
          $(document).on('shiny:disconnected', function(event) {
          clearInterval(socket_timeout_interval)
          });
          </script>
          "
    )
  ),textOutput("keepAlive")
  
) # fluidPage


