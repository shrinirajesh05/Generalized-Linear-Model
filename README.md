# Breast Cancer Survival and Prognostic Factors Analysis

Project Overview:
This study investigates various factors influencing breast cancer outcomes by performing three distinct analyses using a dataset of 2,982 primary breast cancer patients. The main objectives are:

Survival Analysis: To identify factors influencing the time until death.
Mortality Likelihood Analysis: To determine factors responsible for the likelihood of mortality.
Lymph Node Prediction Analysis: To examine predictors of an increase in the number of lymph nodes affected by the tumor.

The study employs three different statistical models:

Cox Proportional Hazard Model for survival analysis.

Logistic Regression for mortality likelihood.

Zero Inflated Negative Binomial (ZINB) Model for predicting the increase in lymph node count.

Dataset:

The dataset consists of 2,982 primary breast cancer patients with variables including:

Age
Tumor Grade
Node Involvement
Recurrence
Hormonal Treatment
Time Until Death
Key Findings

Survival Analysis:

Significant Predictors: Tumor grade and recurrence significantly influenced the time until death.
Mortality Likelihood:

Significant Predictors: Age, grade, node involvement, recurrence, and hormonal treatment were major factors contributing to mortality risk.

Lymph Node Prediction:

Best-Fit Model: The Zero Inflated Negative Binomial (ZINB) model provided the best fit for predicting the number of lymph nodes affected by the tumor.
Statistical Methods
Cox Proportional Hazard Model: Used for survival analysis to estimate the effect of predictors on the time until death.
Logistic Regression: Used to model the likelihood of mortality based on multiple predictors.
Zero Inflated Negative Binomial (ZINB) Model: Applied to predict count data (lymph nodes), accounting for an excess of zero counts (patients with no lymph node involvement).
