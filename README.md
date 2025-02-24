#Practical Assessment
![Standard-Email-Signature---3](https://github.com/user-attachments/assets/39c5018c-8ad5-46cf-b48f-1a6720f7d127)

##First assessment
The whole project uses flight data from the [nycflights13](https://github.com/tidyverse/nycflights13?tab=readme-ov-file) dataset. The data is processed using R and important insights have been derived through data manipulation and visualizations

###Prerequisites
The R script requires the following libraries before running it:
'''code 
install.packages("data.table")
install.packages("ggplot2")
'''
These packages can be downloaded using the following script
'''code 
install.packages(c("data.table", "ggplot2"))
'''

###Dataset
The script uses the following datasets in the **.rda** format:
flights.rda: This has the details on the flight
Planes.rda:This has the aircraft details
weather.rda: This has weather information
airports.rda: This has the airport details
airlines.rds: This has the airline details

###File Paths
I have set the paths according to my location of the datasets in my directory, change it to match yours too:

'''code 
flights_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/flights.rda"
planes_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/planes.rda"
weather_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/weather.rda"
airports_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/airports.rda"
airlines_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/airlines.rda"
'''
###Data Processing
Flights data is first converted into a data table.<br/>
the average delay for each airline is calculated.<br/>
The top 5 destinations with most flights are then identified and shown.<br/>
2 new columns are created:<br/>
  flight_id: Unique identifier for each flight.<br/>
  delayed_15: This boolean shows if a flight is delayed by more than 15 minutes.

The output is saved as an Excel csv file **nycflights_processed.csv **

###Output
![image](https://github.com/user-attachments/assets/1fb814a1-c374-4a5b-900f-fd19de30eaa2)

As seen in the above image, the average departure display is displayed and the top 5 destinations are printed

###Visualizations
####Average Departure Delay per Airline
![image](https://github.com/user-attachments/assets/1cc589db-8479-4dbb-93d3-c9f74f76b021)
"UA" (United Airlines) has an average delay of 12.1 minutes, while "AA" (American Airlines) experiences 8.6 minutes. "B6" (JetBlue) and "VX" (Virgin America) have delays of 13.0 and 12.9 minutes, respectively. "EV" (ExpressJet) and "F9" (Frontier) have the highest delays at around 20 minutes. "US" (US Airways) and "HA" (Hawaiian Airlines) have the lowest delays at 3.8 and 4.9 minutes.

#### Top five flight destinations
![image](https://github.com/user-attachments/assets/01dae61b-7c0d-4685-bc46-bfa37e889b51)

ORD (Chicago O'Hare International Airport) has the highest number of flights (17,283).ATL (Hartsfield-Jackson Atlanta International Airport) follows closely with 17,215 flights.LAX (Los Angeles International Airport) has 16,174 flights. BOS (Boston Logan International Airport) has 15,508 flights. MCO (Orlando International Airport) rounds out the top five with 14,082 flights.





























