# Load necessary libraries
library(data.table)
library(ggplot2)

# Define file paths
flights_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/flights.rda"
planes_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/planes.rda"
weather_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/weather.rda"
airports_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/airports.rda"
airlines_path <- "C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/airlines.rda"

# Load .rda files
load(flights_path)
load(planes_path)
load(weather_path)
load(airports_path)
load(airlines_path)

# Convert flights data to data.table
flights_dt <- as.data.table(flights)

# Compute the average departure delay per airline
avg_dep_delay <- flights_dt[, .(avg_dep_delay = mean(dep_delay, na.rm = TRUE)), by = carrier]

# Find top 5 destinations with the most flights
top_5_dest <- flights_dt[, .N, by = dest][order(-N)][1:5]

# Create new columns
flights_dt[, flight_id := .I]  # Unique flight ID
flights_dt[, delayed_15 := dep_delay > 15]  # TRUE if delayed >15 min

# Save processed data as CSV
processed_path <- "C:/Users/brian/Downloads/nycflights_processed.csv"
fwrite(flights_dt, processed_path)

# Print summary
print(avg_dep_delay)
print(top_5_dest)
print(paste("Processed dataset saved to:", processed_path))

# =============================
# 📊 VISUALIZATIONS
# =============================

# Plot 1: Average Departure Delay per Airline
ggplot(avg_dep_delay, aes(x = reorder(carrier, -avg_dep_delay), y = avg_dep_delay, fill = carrier)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Departure Delay per Airline", x = "Airline Carrier", y = "Avg Departure Delay (minutes)") +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()

# Plot 2: Top 5 Destinations with the Most Flights
ggplot(top_5_dest, aes(x = reorder(dest, -N), y = N, fill = dest)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 5 Destinations by Flight Count", x = "Destination", y = "Number of Flights") +
  theme_minimal() +
  theme(legend.position = "none")
