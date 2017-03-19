# Workout Grader
Using devices such as *Jawbone Up*, *Nike FuelBand*, and *Fitbit* it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how *much* of a particular activity they do, but they rarely quantify *how well they do it*. In this project, the data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants is used to grade the quality of the workout form. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information around the training set can be found here:
[http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har#related_papers) (see the section on the Weight Lifting Exercise Dataset).

## How to run
```bash
Rscript grader.r [training-CSV-URL] [testing-CSV-URL]

# ... example:
Rscript grader.r "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv" "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
```