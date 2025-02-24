# install.packages("ambiorix")
# remotes::install_local("C:/Users/brian/Downloads/ambiorix-master")


# Load required libraries
library(data.table)
library(jsonlite)
library(mongolite)
library(ambiorix)

# Set MongoDB connection
mongo_url <- "mongodb://localhost:27017/"
db_name <- "flightsDB"
collection_name <- "flights"

flights_collection <- mongo(collection = collection_name, db = db_name, url = mongo_url)

# Load flight data from .rda files
load("C:/Users/brian/Downloads/nycflights13-main/nycflights13-main/data/flights.rda")
flights_dt <- as.data.table(flights)

# Data Transformations
flights_dt[, avg_dep_delay := mean(dep_delay, na.rm = TRUE), by = carrier]  # Avg departure delay per airline
top_5_dest <- flights_dt[, .N, by = dest][order(-N)][1:5]  # Top 5 destinations
flights_dt[, flight_id := .I]  # Unique ID for each flight
flights_dt[, delayed := dep_delay > 15]  # Flag for flights delayed > 15 minutes

# Store processed data in MongoDB
flights_collection$insert(flights_dt)

# Define API using Ambiorix
app <- ambiorix::Ambiorix$new()

# POST /flight - Create new flight entry
app$handle("POST", "/flight", function(req, res) {
  flight_data <- fromJSON(req$body)
  flights_collection$insert(flight_data)
  res$json(list(message = "Flight added successfully", flight = flight_data))
})

# GET /flight/:id - Get flight by ID
app$handle("GET", "/flight/:id", function(req, res) {
  flight_id <- as.integer(req$params$id)
  flight <- flights_collection$find(paste0('{"flight_id":', flight_id, '}'))
  res$json(if (nrow(flight) > 0) flight else list(error = "Flight not found"))
})

# GET /check-delay/:id - Check if a flight is delayed
app$handle("GET", "/check-delay/:id", function(req, res) {
  flight_id <- as.integer(req$params$id)
  flight <- flights_collection$find(paste0('{"flight_id":', flight_id, '}'))
  if (nrow(flight) > 0) {
    res$json(list(flight_id = flight_id, delayed = flight$delayed))
  } else {
    res$json(list(error = "Flight not found"))
  }
})

# GET /avg-dep-delay - Get average departure delay per airline
app$handle("GET", "/avg-dep-delay", function(req, res) {
  airline <- req$query$id
  query <- if (!is.null(airline)) paste0('{"carrier": "', airline, '"}') else "{}"
  avg_delays <- flights_collection$find(query, fields = '{"carrier":1, "avg_dep_delay":1, "_id":0}')
  res$json(avg_delays)
})

# GET /top-destinations/:n - Get top N destinations
app$handle("GET", "/top-destinations/:n", function(req, res) {
  n <- as.integer(req$params$n)
  top_destinations <- flights_dt[, .N, by = dest][order(-N)][1:n]
  res$json(top_destinations)
})

# PUT /flights/:id - Update flight details
app$handle("PUT", "/flights/:id", function(req, res) {
  flight_id <- as.integer(req$params$id)
  updated_data <- fromJSON(req$body)
  flights_collection$update(paste0('{"flight_id":', flight_id, '}'), paste0('{"$set":', toJSON(updated_data, auto_unbox = TRUE), '}'))
  res$json(list(message = "Flight updated successfully", flight_id = flight_id))
})

# DELETE /:id - Delete a flight
app$handle("DELETE", "/:id", function(req, res) {
  flight_id <- as.integer(req$params$id)
  flights_collection$remove(paste0('{"flight_id":', flight_id, '}'))
  res$json(list(message = "Flight deleted successfully", flight_id = flight_id))
})

# Run the API server on port 8000
app$start(8000)
