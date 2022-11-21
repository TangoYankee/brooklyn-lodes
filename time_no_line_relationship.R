library(tidyverse)
library(sf)

time <- readr::read_csv('data/nta-subway-weights.csv')
lines <- readr::read_csv('data/nta-subway-transfers.csv')

no_lines <- lines %>%
    dplyr::filter(line_count == 0) %>%
    dplyr::select(trip, line_count) %>%
    dplyr::left_join(time)

tough_trips <- no_lines %>%
    dplyr::filter(S000 > 500) %>%
    dplyr::filter(seconds_in_transit > 1900)

bk_name <- "Brooklyn"
bk_county_code <- "047"
bk_parks <- "BK99"

nyc_nta_borders <- sf::st_read('./data/nyc_2010_nta_borders.geojson')
bk_nta_borders <- nyc_nta_borders %>%
  filter(BoroName == bk_name & NTACode != bk_parks) %>%
  select(c("NTACode"))

tough_nta_borders <- bk_nta_borders %>%
    dplyr::filter(NTACode %in% tough_trips$nta_one | NTACode %in% tough_trips$nta_two) %>%
    dplyr::select("NTACode")

tough_nta_centers <- tough_nta_borders %>%
    dplyr::mutate(geometry = sf::st_point_on_surface(geometry))

tough_nta_lines <- tough_trips %>%
    dplyr::left_join(tough_nta_centers, c("nta_one" = "NTACode")) %>%
    dplyr::rename(nta_one_point = geometry) %>%
    dplyr::left_join(tough_nta_centers, c("nta_two" = "NTACode")) %>%
    dplyr::rename(nta_two_point = geometry) %>%
    dplyr::mutate(geometry = st_union(nta_one_point, nta_two_point)) %>%
    dplyr::mutate(geometry = st_cast(geometry, "LINESTRING")) %>%
    dplyr::select(-c(nta_one_point, nta_two_point)) %>%
    sf::st_as_sf()

tmap::tm_shape(bk_nta_borders) +
    tmap::tm_polygons(
        col = "#e4e4e4"
    ) +
    tmap::tm_shape(tough_nta_borders) +
    tmap::tm_polygons(
        col = "#f84949"
    ) + 
    tmap::tm_shape(tough_nta_lines) +
    tmap::tm_lines(
        col = "#212427",
        lwd = "S000"
    )
