# https://gis.stackexchange.com/questions/323698/counting-points-in-polygons-with-sf-package-of-r
library(sf)

path_nfhs <- "C:/Cloud/OneDrive - Emory University/data/dhs_program/IA/IAGE71FL"
shp_nfhs <-  read_sf(paste0(path_nfhs))

path_2018 <- "C:/Cloud/OneDrive - Emory University/data/India Shapefiles/INDIA_2018_DISTRICTS-master"
shp_2018 <-  read_sf(paste0(path_2018))
psu_2018 <- st_intersects(shp_2018,shp_nfhs)

shp_nfhs_2018 <- map2_dfr(psu_2018,1:719,
                          function(x,y){
                            
                            x_df <- shp_nfhs[x,c("DHSCLUST","ADM1NAME","DHSREGCO","DHSREGNA","URBAN_RURA")];
                            x_df$geometry <- NULL;
                            y_df <- shp_2018[y,c("D_NAME","D_CODE","S_NAME","S_CODE")];
                            y_df$geometry <- NULL;
                            bind_cols(x_df,y_df) %>% 
                              return(.)
                            
                            
                          })

write_csv(shp_nfhs_2018,paste0("data/psu_on_map2018.csv"))

path_2020 <- "C:/Cloud/OneDrive - Emory University/data/India Shapefiles/india_shp_2020-master/district"
shp_2020 <-  read_sf(paste0(path_2020))
psu_2020 <- st_intersects(shp_2020,shp_nfhs)

shp_nfhs_2020 <- map2_dfr(psu_2020,1:735,
                          function(x,y){
                            
                            x_df <- shp_nfhs[x,c("DHSCLUST","ADM1NAME","DHSREGCO","DHSREGNA","URBAN_RURA")];
                            x_df$geometry <- NULL;
                            y_df <- shp_2020[y,c("dtname","stname","stcode11","dtcode11","year_stat",
                                                 "Dist_LGD","State_LGD","JID")];
                            y_df$geometry <- NULL;
                              bind_cols(x_df,y_df) %>% 
                              return(.)
                      
                            
                          })
write_csv(shp_nfhs_2020,paste0("data/psu_on_map2020.csv"))

