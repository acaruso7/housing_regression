proc import datafile = 'C:\dev\python\BIA 652 Multi\Project\CV Model\clean_data.csv'
 out = work.clean_data
 dbms = CSV
 ;
run;


PROC STANDARD DATA=clean_data
              MEAN=0 STD=1 /*makes mean 0 and sd 1 by normalizing the data to these parameters*/
             OUT=out_z;
  			VAR bedrooms bathrooms sqft_living sqft_lot sqft_basement yr_built 
					condition grade zipcode_cluster;
RUN;


title "Principal Component Analysis"; 
title2 " ";
proc princomp   data=out_z  out=pca;
   var bedrooms bathrooms sqft_living sqft_lot sqft_basement yr_built condition grade zipcode_cluster ;
run;


/*After running PCA, export the data as a CSV so it can be read back into Python and split into training and test sets*/
proc export data=pca
   outfile='C:/dev/python/BIA 652 Multi/Project/CV Model/clean_pca.csv'
   dbms=csv
   replace;
run;


/*Import the cleaned training data and run a regression*/
proc import datafile = 'C:\dev\python\BIA 652 Multi\Project\CV Model\train.csv'
 out = work.train
 dbms = CSV
 ;
run;


title 'Initial Regression with Principal Components and Categoricals';
proc reg data=train PLOTS(MAXPOINTS=30000) plots=(CooksD RStudentByLeverage DFFITS);
	model price = prin1 - prin4 prin6 prin7 prin9 view_1 view_2 view_3 waterfront_1 renovated / STB dwProb VIF;
	OUTPUT OUT=influence
		h=lev cookd=cooksd  dffits=dffits;
	/*removed view 4 from model due to high correlation with waterfront_1*/
	/*removed prin5 from model due to statistical insignificance*/
	/*removed prin8 due to statistical insignificance*/
quit;


/*Export the influence statistics for the above regression, so influential points can be removed from the training data using Python*/
proc export data=influence
   outfile='C:/dev/python/BIA 652 Multi/Project/CV Model/influence.csv'
   dbms=csv
   replace;
run;



/* Import cleaned training data, with influential points removed - use this for the final regression model */
proc import datafile = 'C:\dev\python\BIA 652 Multi\Project\CV Model\train_no_influentials.csv'
 out = work.train_no_influentials
 dbms = CSV
 ;
run;


title 'Final Regression with Influential Observations Removed';
proc reg data=train_no_influentials PLOTS(MAXPOINTS=30000) outest = model_params;
	model price = prin1 - prin4 prin6 prin7 prin9 view_2 view_3 waterfront_1 / STB dwProb VIF;
	/* removed view_1 and renovated due to statistical insignificance */
quit;


/*export model parameters to CSV so they can be used in Python to make predictions on test data*/
proc export data=model_params
   outfile='C:/dev/python/BIA 652 Multi/Project/CV Model/model_params.csv'
   dbms=csv
   replace;
run;


