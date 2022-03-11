library(sp)
library(rgdal)
library(tmap)
path_shape_files <- "C:/Cloud/OneDrive - Emory University/data/India Shapefiles/india_shp_2020-master"
shape_df <-  readOGR(paste0(path_shape_files,"/district"),"in_district")

(tm_shape(shape_df,ext=1.2) + 
  tm_borders()) %>% 
tmap_save(.,paste0(path_shape_files,"/district/in_district.png"),height=2300/300)


shape_df@data %>% 
  saveRDS(.,paste0(path_shape_files,"/district/in_district_data.RDS"))
shape_df@data %>% 
  write.csv(.,paste0(path_shape_files,"/district/in_district_data.csv"),row.names = FALSE)
