# DevelopingDataProducts
Coursera Data Science DDP project
title: "Armchair Quarterback Assistant - Football Play Predictor"
author: "C. Daniels"
date: "January 29,2016"
course: "Developing Data Products"
project: "Course Project"
file: server.R/ui.R (this is a shiny R project)

## Help Text
To use this app: 1. Select situation parameters on the sidebar panel. 2. Choose what you think is the best type of play to call in the selected situation. 3. Click Go! and check Result on the main panel to see if you agree with the Experts!

## Background
Data Source 
http://www.crowdflower.com/data-for-everyone/Football-Scenarios-DFE-832307.csv

Football Strategy
Contributors were presented a football scenario and asked to note what the best coaching decision would be. An scenario: "It is third down and 3. The ball is on your opponent's 20 yard line. There are five seconds left. You are down by 4." The decisions presented were punt, pass, run, kick a field goal, kneel down, or don't know. There are thousands of such scenarios in this job.

Added: December 8, 2015 by CrowdFlower | Data Rows: 3,731

## Processing
I took this data set and decomposed the big string into 4 separate scenario items.
Down and Distance
Where's the ball
Time Left 
Score

I then created a Random Forest model using those field on the antecedent field (recommended play).

From there I created shiny UI apllication that would allow a user to select scenaro items and choose their reccomended play.

I took their input, ran a prediction and returned the Model prediction as well as a comparison of their guess to the model prediction.


This is all for fun as I do not think that the model was that great. It had around a 78%  accuracy, but this app is really about making a reactive application in shiny.


