# Install commonly used packages
pacman::p_load(caret, pacman, corrplot, dplyr, plyr, GGally, ggplot2, gridExtra, ggthemes, ggvis, factoextra, FactoMineR, httr, lubridate, plotly, rio, rmarkdown, shiny, stringr, tidyr)

# Set the Working Directory for the session
setwd("C:/Users/david/Google Drive/Data/GitHub/Data-Mining-Project-with-R")

# Load the Telco Customer Churn data set
customer.churn <- read.csv("WA_Fn-UseC_-Telco-Customer-Churn.csv",header = TRUE)

# View the structure of the data frame
str(customer.churn)

# View summary statistics for the uncleaned data set and check for missing values
summary(customer.churn)

# Remove 11 records with missing values in TotalCharges variable
customer.churn <- customer.churn[complete.cases(customer.churn),]
summary(customer.churn)

# Remove Customer ID variable
customer.churn$customerID <- NULL

# Review each categorical variable for cleaning/wrangling
unique(customer.churn$gender)
unique(customer.churn$SeniorCitizen)
unique(customer.churn$Partner)
unique(customer.churn$Dependents)
unique(customer.churn$PhoneService)
unique(customer.churn$MultipleLines)
unique(customer.churn$InternetService)
unique(customer.churn$OnlineSecurity)
unique(customer.churn$OnlineBackup)
unique(customer.churn$DeviceProtection)
unique(customer.churn$TechSupport)
unique(customer.churn$StreamingTV)
unique(customer.churn$StreamingMovies)
unique(customer.churn$Contract)
unique(customer.churn$PaperlessBilling)
unique(customer.churn$PaymentMethod)
unique(customer.churn$Churn)

# Clean the needed categorical values
customer.churn$SeniorCitizen <- as.factor(mapvalues(customer.churn$SeniorCitizen, from = c("1", "0"), to = c("Yes", "No")))
customer.churn$MultipleLines <- as.factor(mapvalues(customer.churn$MultipleLines, from = c("No phone service"), to = c("No")))
customer.churn$OnlineSecurity <- as.factor(mapvalues(customer.churn$OnlineSecurity, from = c("No internet service"), to = c("No")))
customer.churn$OnlineBackup <- as.factor(mapvalues(customer.churn$OnlineBackup, from = c("No internet service"), to = c("No")))
customer.churn$DeviceProtection <- as.factor(mapvalues(customer.churn$DeviceProtection, from = c("No internet service"), to = c("No")))
customer.churn$TechSupport <- as.factor(mapvalues(customer.churn$TechSupport, from = c("No internet service"), to = c("No")))
customer.churn$StreamingTV <- as.factor(mapvalues(customer.churn$StreamingTV, from = c("No internet service"), to = c("No")))
customer.churn$StreamingMovies <- as.factor(mapvalues(customer.churn$StreamingMovies, from = c("No internet service"), to = c("No")))

unique(customer.churn$SeniorCitizen)
unique(customer.churn$MultipleLines)
unique(customer.churn$OnlineSecurity)
unique(customer.churn$OnlineBackup)
unique(customer.churn$DeviceProtection)
unique(customer.churn$TechSupport)
unique(customer.churn$StreamingTV)
unique(customer.churn$StreamingMovies)

# Convert tenure variable into years factor
Tenure.Years <- function(tenure) {
  if (tenure >= 0 & tenure <= 12) 
    return("First Year")
  else if (tenure > 12 & tenure <= 24)
    return("Second Year")
  else if (tenure > 24 & tenure <= 36)
    return("Third Year")
  else if (tenure > 36 & tenure <= 48)
    return("Fourth Year")
  else if (tenure > 48 & tenure <= 60)
    return("Fifth Year")
  else (tenure >60)
    return("Sixth Year or More")
}

# Apply function to new variable and delete old tenure variable
customer.churn$Tenure.Years <- sapply(customer.churn$tenure, Tenure.Years)
customer.churn$Tenure.Years <- as.factor(customer.churn$Tenure.Years)
unique(customer.churn$Tenure.Years)

# Order the Tenure Factor
customer.churn$Tenure.Years <- ordered(customer.churn$Tenure.Years, levels =c("First Year", "Second Year", "Third Year", "Fourth Year", "Fifth Year", "Sixth Year or More"))

# Remove old tenure variable
customer.churn$tenure <- NULL

# Convert the rest of the character variables to factors
customer.churn$gender <- as.factor(customer.churn$gender)
customer.churn$Partner <- as.factor(customer.churn$Partner)
customer.churn$Dependents <- as.factor(customer.churn$Dependents)
customer.churn$PhoneService <- as.factor(customer.churn$PhoneService)
customer.churn$InternetService <- as.factor(customer.churn$InternetService)
customer.churn$Contract <- as.factor(customer.churn$Contract)
customer.churn$PaperlessBilling <- as.factor(customer.churn$PaperlessBilling)
customer.churn$PaymentMethod <- as.factor(customer.churn$PaymentMethod)
customer.churn$Churn <- as.factor(customer.churn$Churn)

View(customer.churn)

# Export the cleaned data set to XLSX using rio package
export(customer.churn, "cleaned_customer_churn.xlsx")



# Initial Distribution Charts
B1 <- ggplot(customer.churn, aes(x = gender)) + ggtitle("Gender") +
      geom_bar(aes(y = (..count..)/sum(..count..))) +
      scale_y_continuous(labels = scales::percent) + 
  ylab("Relative Frequency")

B2 <- ggplot(customer.churn, aes(x = SeniorCitizen)) + ggtitle("Senior Citizen") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B3 <- ggplot(customer.churn, aes(x = Partner)) + ggtitle("Partner") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B4 <- ggplot(customer.churn, aes(x = Dependents)) + ggtitle("Dependents") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B5 <- ggplot(customer.churn, aes(x = PhoneService)) + ggtitle("Phone Service") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B6 <- ggplot(customer.churn, aes(x = MultipleLines)) + ggtitle("Multiple Lines") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B7 <- ggplot(customer.churn, aes(x = InternetService)) + ggtitle("Internet Service") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B8 <- ggplot(customer.churn, aes(x = OnlineSecurity)) + ggtitle("Online Security") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B9 <- ggplot(customer.churn, aes(x = OnlineBackup)) + ggtitle("Online Backup") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B10 <- ggplot(customer.churn, aes(x = DeviceProtection)) + ggtitle("Device Protection") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B11 <- ggplot(customer.churn, aes(x = TechSupport)) + ggtitle("Tech Support") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B12 <- ggplot(customer.churn, aes(x = StreamingTV)) + ggtitle("Streaming TV") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B13 <- ggplot(customer.churn, aes(x = StreamingMovies)) + ggtitle("Streaming Movies") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B14 <- ggplot(customer.churn, aes(x = Contract)) + ggtitle("Contract") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency") + theme(axis.text.x = element_text(angle = 50))

B15 <- ggplot(customer.churn, aes(x = PaperlessBilling)) + ggtitle("Paperless Billing") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

B16 <- ggplot(customer.churn, aes(x = PaymentMethod)) + ggtitle("Payment Method") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency") + theme(axis.text.x = element_text(angle = 50))

B17 <- ggplot(customer.churn, aes(x = Tenure.Years)) + ggtitle("Tenure in Years") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency") + theme(axis.text.x = element_text(angle = 50))

B18 <- ggplot(customer.churn, aes(x = Churn)) + ggtitle("Churn") +
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Relative Frequency")

H1 <- ggplot(customer.churn, aes(x = MonthlyCharges)) + ggtitle("Monthly Charges") +
  geom_histogram()

H2 <- ggplot(customer.churn, aes(x = TotalCharges)) + ggtitle("Total Charges") +
  geom_histogram()

# Align the bar charts into three images and export
png("Bar Plots 1.png")
grid.arrange(B1, B2, B3, B4, B5, B6, B7, B8, B9, ncol=3)
dev.off()

png("Bar Plots 2.png")
grid.arrange(B10, B11, B12, B13, B14, B15, ncol = 3)
dev.off()

png("Bar Plots 3.png")
grid.arrange(B16, B17, B18, ncol = 3)
dev.off()

# Align the histograms into one image and export
png("Histograms.png")
grid.arrange(H1, H2, ncol = 2)
dev.off()

# Correlation matrix and plot for numeric variables
NumericVariables <- data.frame(customer.churn$MonthlyCharges,customer.churn$TotalCharges)
names(NumericVariables)[names(NumericVariables) == "customer.churn.MonthlyCharges"] <- "Monthly.Charges" 
names(NumericVariables)[names(NumericVariables) == "customer.churn.TotalCharges"] <- "Total.Charges"
CM <- cor(NumericVariables)

png("Correlation Matrix.png")
corrplot(CM, method = "number", title = "Correlation Matrix for Monthly and Total Charges",
         mar = c(0,0,2,0))
dev.off()

# Remove Total Charges because of multi-collinearity
customer.churn$TotalCharges <- NULL


### MCA Branch #######

# Multiple Correspondence Analysis to select most important features
require(FactoMineR)
require(factoextra)
MCAchurnMATRIX <- as.matrix(customer.churn)
MCAchurn <- MCA(customer.churn, quanti.sup = 17, quali.sup = 18, graph = FALSE)
print(MCAchurn)

# Plot of MCA
fviz_mca_var(MCAchurn, title = "MCA of Customer Churn", selectmod = "contrib20", repel = TRUE, col.var = "red", col.quanti.sup = "blue", col.quali.sup = "darkgreen")

# Scree plot of MCA
fviz_eig(MCAchurn, addlabels = TRUE)

# Contribution of variable categories
fviz_contrib(MCAchurn, choice = "var", axes = 1, top = 10)
fviz_contrib(MCAchurn, choice = "var", axes = 2, top = 10)
fviz_contrib(MCAchurn, choice = "var", axes = 3, top = 10)
fviz_contrib(MCAchurn, choice = "var", axes = 4, top = 10)

#Export as pngs

## Select Variables ## TESTING
MCAvar <- get_mca_var(MCAchurn)
MCAvar

# Coordinates
head(MCAvar$coord)

# Cos2: quality on the factor map
head(MCAvar$cos2)

# Contributions to the principal components
head(MCAvar$contrib)

# Plot cos2 values with color gradient
fviz_mca_var(MCAchurn, col.var="cos2", gradient.cols = c("#FFFF00", "#FFA500", "#FF0000"), repel = TRUE, ggtheme = theme_minimal())

# Cos2 of variables
fviz_cos2(MCAchurn, choice = "var", axes = 1:4)


### Logistic Regression Branch ###

# Convert Churn to "0" and "1" for logistic regression
customer.churn$Churn <- ifelse(customer.churn$Churn == "Yes", 1, 0)
unique(customer.churn$Churn)

# Partition the data into training and validation sets
Partitions <- createDataPartition(customer.churn$gender, p=0.7, list = FALSE)
set.seed(801)
Train <- customer.churn[Partitions,]
Validate <- customer.churn[-Partitions,]

dim(Train)
dim(Validate)

# Logistic Regression
log.churn <- glm(formula = Churn ~ ., family = "binomial", data = Train)
summary(log.churn)

# Logistic Model with only Significant Features at .01 level
log.churn01 <- glm(formula = Churn ~ Tenure.Years + Contract + PaperlessBilling, family = "binomial", data = Train)
summary(log.churn01)

# Anova
anova(log.churn01, test="Chisq")

# Predictive ability of model on Validation Data
probabilities <- log.churn01 %>% predict(Validate, type = "response")
churn.prediction <- ifelse(probabilities > 0.5, "Churn", "No Churn")
churn.prediction

# Confusion Matrix from Validation Data
churn.actual <- ifelse(Validate$Churn == 1, "Churn", "No Churn")
churn.prediction <- as.factor(churn.prediction)
churn.actual <- as.factor(churn.actual)
confusionMatrix(churn.prediction, churn.actual)

mean(churn.prediction == churn.actual)

# ROC Curve plot
churn.actual <- as.numeric(churn.actual)
churn.prediction <- as.numeric(churn.prediction)

library(pROC)
par(pty = "s")
roc(churn.actual, probabilities, plot = TRUE, legacy.axes = TRUE)



### Clean Up ###

# Clear Packages
p_unload(all)

# Clear Plots, if there are any
dev.off()

# Clear global environment
rm(list = ls())

# Clear Console CTRL+L
cat("\014")
