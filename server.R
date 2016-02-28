# ---
# title: "Armchair Quarterback Assistant - Football Play Predictor"
# author: "C. Daniels"
# date: "January 29,2016"
# course: "Developing Data Products"
# project: "Course Project"
# file: server.R
# ----
library(shiny)
library(stats)
#library(AppliedPredictiveModeling)
library(e1071)
#library(ElemStatLearn)
library(caret)
library(randomForest)
#library(lmtest)
library(stringr)
library(dplyr)
TRN  <- "data/Football-Scenarios-DFE-832307.csv"
#read data 
trnData <-read.csv(TRN, na.strings= "?", skip= 0, nrows= -1, sep=",")
colList = c("antecedent", "orig_antecedent") 
trnData <- (trnData[colList]) 
trnData$orig_antecedent = as.character(trnData$orig_antecedent)
trnData$antecedent = as.character(trnData$antecedent)
trnData1 <- subset(trnData, nchar(orig_antecedent) > 125)
trnData1 <- subset(trnData1, antecedent !="Don't know / it depends")
##trnData1 <- trnData1[1:400,] 
x =lapply(trnData1$orig_antecedent,function(x) strsplit(x, "[.]"))
trnData1$SP1 = sapply(x, function(x) str_trim(x[[1]][1]))
trnData1$SP2 = sapply(x, function(x) str_trim(x[[1]][2]))
trnData1$SP3 = sapply(x, function(x) str_trim(x[[1]][3]))
trnData1$SP4 = sapply(x, function(x) str_trim(x[[1]][4]))
trnData1$antecedent = as.factor(trnData1$antecedent)
trnData1$SP1 = as.factor(trnData1$SP1)
trnData1$SP2 = as.factor(trnData1$SP2)
trnData1$SP3 = as.factor(trnData1$SP3)
trnData1$SP4 = as.factor(trnData1$SP4)
#subset columns down  to new factor variables 
colList = c("antecedent", "SP1", "SP2", "SP3", "SP4") 
trnData1 <- (trnData1[colList]) 
str(trnData1)
trn = trnData1
set.seed(4355) #Set a seed for reproducibility 
#subset trn into 2 groups: trnG1 and trnG2
trnIdx <- createDataPartition(trn$antecedent, p = .8, list=FALSE)
trnG1 = trn[trnIdx,]
trnG2 = trn[-trnIdx,]
#"./data/cbdmodelRF.rds"
if(file.exists("data/cbdmodelRF.rds")) {
   modelRF <- readRDS("data/cbdmodelRF.rds")
} else {
    ## (re)fit the model
    modelRF <- train(antecedent ~., method="rf",  data=trnG1, prox=TRUE) 
    saveRDS(modelRF, "data/cbdmodelRF.rds")
}

predRF <- predict(modelRF, trnG2)
accRF <- (confusionMatrix(predRF, trnG2$antecedent)$overall[1])
accRF <-paste(round(accRF*100,digits=2),"%",sep="")
#
L1 <- levels(trnG1$SP1)
L2 <- levels(trnG1$SP2)
L3 <- levels(trnG1$SP3)
L4 <- levels(trnG1$SP4)
Lguess <- levels(trnData1$antecedent)


shinyServer(
    function(input, output, session) {
     updateSelectInput( session, "downdist", choices = L1)
     updateSelectInput( session, "loc", choices = L2)
     updateSelectInput( session, "time", choices = L3)
     updateSelectInput( session, "score", choices = L4)
     updateRadioButtons(session, "guess", choices = Lguess) 
     output$odowndist <- renderPrint({input$downdist})
     output$oloc <- renderPrint({input$loc})
     output$otime <- renderPrint({input$time})
     output$oscore <- renderPrint({input$score})
     output$osituation <- renderPrint({
         input$goButton
         isolate(HTML(paste(input$downdist, ".", "</br>" , 
                            input$loc, ".", "</br>" ,
                            input$time, ".", "</br>",
                            input$score, sep="")))
     })
     output$oguess <- renderPrint({
         input$goButton
         isolate(f(input$downdist, input$loc, input$time, input$score))
          })
     output$omatch <- renderUI({
         input$goButton
         isolate(f1(input$guess))})
     
     f <- function(downdist, loc, time, score) {
     tst = data.frame("SP1" = downdist, "SP2" = loc, "SP3"=time, "SP4"=score)
     as.character(predict(modelRF, tst))
     }
     f1 <- function(guess) {
         newguess = f(input$downdist, input$loc, input$time, input$score)
         if (guess == newguess) {
             return ("Congratulations you agree with the experts!")}
         else {
             return (HTML(paste("While it may be best to", toupper(guess), ", our model says it's time to",
                                "<b>", toupper(newguess), "</b>", "! <br/> <br/>",
                           "Note: Our model accuracy is only",
                           accRF,
                           "...so I wouldn't bet on it!",sep=" " )) )}
     }
     
    }
    )
