How to create boxplots for every neuralMetrics file produced by the Neural Metrics Tool from Axion Biosystems:

- Run spikesAxion.m – The code creates a .csv file with all wells in the header, the date the experiment was conducted, and the number of spikes given in the files.

For Lineplots:
- Run code createLinePlot.m (Input should be the created file from spikesAxion.m)

For Boxplots: 
- Load the .csv file in createBoxplots.m and give the starting date (= first day in vitro). You will get a boxplot with the Number of spikes on the y-axis and the days in vitro on the x-axis (saved as .pdf file).
