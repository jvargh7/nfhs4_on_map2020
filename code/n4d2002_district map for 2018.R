library(sp)
library(rgdal)
library(tmap)
path_shape_files <- "C:/Cloud/OneDrive - Emory University/data/India Shapefiles/INDIA_2018_DISTRICTS-master"
shape_df <-  readOGR(paste0(path_shape_files))

(tm_shape(shape_df,ext=1.2) + 
    tm_borders()) %>% 
  tmap_save(.,paste0(path_shape_files,"/DISTRICTS_2018.png"),height=2300/300)


shape_df@data %>% 
  saveRDS(.,paste0(path_shape_files,"/DISTRICTS_2018_data.RDS"))
shape_df@data %>% 
  write.csv(.,paste0(path_shape_files,"/DISTRICTS_2018_data.csv"),row.names = FALSE)
