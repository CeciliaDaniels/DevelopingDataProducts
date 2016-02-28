# ---
# title: "Armchair Quarterback Assistant - Football Play Predictor"
# author: "C. Daniels"
# date: "January 29,2016"
# course: "Developing Data Products"
# project: "Course Project"
# file: UI.R
# ----

library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Armchair Quarterback Assistant"),
    sidebarPanel(
      h4('Select situation parameters'),
      selectInput("downdist", "Down and Distance:", c("It is first down and 10")),
      selectInput("loc", "Where's the ball:",  c("The ball is on your 20 yardline")),
      selectInput("time", "Time Left:",  c("It is the first quarter" )),
      selectInput("score", "Score:", c("You are down by 10 points" )),
      h4('Choose your next play and click GO!'),
      radioButtons("guess", "Next play:", c("Kick a field goal")),
      actionButton("goButton", "GO!")
            ),
mainPanel(
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"),
    helpText('To use this app: 1. Select situation parameters on the sidebar panel.',
              '2. Choose what you think is the best type of play to call',
              'in the selected situation. 3. Click Go! and check Result on the ',
              'main panel to see if you agree with the Experts!'
              ),
    
    h4('Most recent selections.'),
    helpText("Note: This updates when you change situation parameters."),
    verbatimTextOutput("odowndist"),
    verbatimTextOutput("oloc"),
    verbatimTextOutput("otime"),
    verbatimTextOutput("oscore"),
    h4('Last prediction.'),
    helpText("Note: This updates when you click GO!"),
    h4('Situation:'),
    htmlOutput("osituation"),
    h4('Model prediction based on "Expert" opinion:'),
    verbatimTextOutput("oguess"),
    h4('Result:'),
    htmlOutput("omatch")
    )
))

