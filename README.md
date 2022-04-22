# OC Covid Project

This project uses public data from [OC Health Care Agency](https://occovid19.ochealthinfo.com/coronavirus-in-oc) to visualize covid cases for Orange County, CA. 

# Data 

The data comes from COVID-19 Cases in Schools in this [page](https://occovid19.ochealthinfo.com/coronavirus-in-oc). The period covers from 2020-08-16 to 2022-04-09.

# Basic Data Visualization   

First, I plot the raw data for each table. 

![](figure/fig1_table1.png)

![](figure/fig2_table2.png)


# Loess Model

From the plots above, we observe that covid cases during Thanksgiving and Christmas were unusually low. They were lower because people travelled to other areas to spend holidays. We can use the loess model to do some smooth predictions. 

# Data Visualization: Recorded vs Predicted Covid Cases 

Now we can plot raw data vs predicted data. We can see that the covid cases during holidays are higher than recorded.

![](figure/fig3_loess_all.png)

![](figure/fig4_loess_separate.png)


