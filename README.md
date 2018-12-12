# housing_regression
A multiple linear regression model to predict house prices in King County, Washington

This project originates from a graduate course in Multivariate Statistics. Python is used 
largely for data analysis and manipulation, while SAS is used for principal component
analysis and fitting a linear regression model.

The model uses various continuous and categorical features to predict house prices. 
A log transformation was applied to the dependent variable to ensure normality. PCA 
was implemented for the continuous variables to ensure feature independence since 
they were relatively correlated. Influential observations identified from an initial 
SAS regression model were also removed from the training data. This is important 
because there are quite a few outliers in the dataset which skew the best fit plane. 
The resulting model has normally distributed residuals and uniform variance. After 
applying the model to test data, it seems to be well fit since the accuracy metrics 
are similar to those for the training data.
