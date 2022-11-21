library(tidyverse)

time <- readr::read_csv('data/nta-subway-weights.csv')
lines <- readr::read_csv('data/nta-subway-transfers.csv')

no_lines <- lines %>%
    dplyr::filter(line_count == 0) %>%
    dplyr::select(trip, line_count) %>%
    dplyr::left_join(time)

tough_trips <- no_lines %>%
    dplyr::filter(S000 > 500) %>%
    dplyr::filter(seconds_in_transit > 1900)


