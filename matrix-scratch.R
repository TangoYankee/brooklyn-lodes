library(tidyverse)
library(igraph)

subway <- readr::read_csv('./data/nta-subway-weights.csv')

subway_edges <- subway %>%
  select(nta_one, nta_two, seconds_in_transit)

subway_connections = matrix(0, nrow(subway), nrow(subway))

el <- cbind(a=1:5, b=5:1, c=c(3,1,2,1,1)) 
mat = matrix(0, 5, 5)
mat[el[,1:2]] <- el[,3]

subway_matrix <- matrix(0, nrow(subway), nrow(subway))

subway_frame <- data.frame(from=subway$nta_one, to=subway$nta_two, weight=1/subway$seconds_in_transit)
subway_graph <- igraph::graph.data.frame(subway_frame)
subway_matrix <- igraph::as_adjacency_matrix(subway_graph, attr = "weight")
