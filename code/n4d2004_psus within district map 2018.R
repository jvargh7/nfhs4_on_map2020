# https://gis.stackexchange.com/questions/323698/counting-points-in-polygons-with-sf-package-of-r
require(sf)
require(purrr)
require(tidyverse)


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


missing_shp_nfhs <- anti_join(shp_nfhs %>% 
                                dplyr::select(one_of("DHSCLUST","ADM1NAME","DHSREGCO","DHSREGNA")),
                              shp_nfhs_2018,
                              by=c("DHSCLUST","ADM1NAME","DHSREGCO","DHSREGNA")) %>% 
  left_join(shp_nfhs_2018 %>% 
              distinct_at(vars(one_of("ADM1NAME","DHSREGCO","DHSREGNA")),.keep_all=TRUE) %>% 
              dplyr::select(-DHSCLUST),
            by = c("ADM1NAME","DHSREGCO","DHSREGNA")) %>% 
  mutate(flag = "Imputed SHP 2018 data")


missing_shp_nfhs$geometry <- NULL

bind_rows(shp_nfhs_2018,
          missing_shp_nfhs) %>% 
  
  write_csv(.,paste0("data/psu_on_map2018.csv"))


