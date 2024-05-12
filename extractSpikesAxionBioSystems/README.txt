How to create boxplots for every neuralMetrics file produced by the Neural Metrics Tool from Axion Biosystems:

- Run spikesAxion.m – The code creates a .csv file with all wells in the header, the date the experiment was conducted, and the number of spikes given in the files.

For Boxplots: 
- Load the .csv file in createBoxplots.m and give the starting date (= first day in vitro). You will get a boxplot with the Number of spikes on the y-axis and the days in vitro on the x-axis (saved as .pdf file).

For Bar charts with error bars:

- Run createBarCharts and give the start day as input.

For Bar charts with error bars comparing Bicuculline and Sham control data:

1) Run spikesAxion.m to extract all the NumberofSpikes for the Bicuculline experiment recordings. Creates a .csv file. 
2) Load the .csv file and extract the NumberofSpikes for Bicuculline and Sham control data in two different .csv files. ! Please note: The data expects an exact time interval that needs to be adjusted, same for the wells for the data. The NumberofSpikes are normalized to the data recordings on day 1.
3) Run createBarChartBicu to create Bar charts with error bars for Bicuculline and Sham control data, plotting each next to each other for each recording time.
