# https://gis.stackexchange.com/questions/323698/counting-points-in-polygons-with-sf-package-of-r
require(sf)
require(purrr)
require(tidyverse)

path_nfhs <- "C:/Cloud/OneDrive - Emory University/data/dhs_program/IA/IAGE71FL"
shp_nfhs <-  read_sf(paste0(path_nfhs))

path_nfhs5 <- "C:/Cloud/OneDrive - Emory University/data/dhs_program/IA/IASHP7C/shps/sdr_subnational_boundaries2.shp"
boundary_nfhs5 <-  read_sf(paste0(path_nfhs5))

boundary_nfhs5 <- boundary_nfhs5 %>% 
  mutate(REGCODE = case_when(REGNAME == "Hamirpur" & OTHREGNA == "Uttar Pradesh" ~ 168,
                             REGNAME == "Bijapur" & OTHREGNA == "Karnataka" ~ 557,
                             REGNAME == "Aurangabad" & OTHREGNA == "Maharashtra" ~ 515,
                             REGNAME == "Balrampur" & OTHREGNA == "Chhattisgarh" ~ 824,
                             REGNAME == "Bilaspur" & OTHREGNA == "Chhattisgarh" ~ 827,
                             REGNAME == "Pratapgarh" & OTHREGNA == "Uttar Pradesh" ~ 173,
                             REGNAME == "Raigarh" & OTHREGNA == "Maharashtra" ~ 520,
                             TRUE ~ REGCODE)) %>% 
  arrange(REGCODE)

psu_nfhs5 <- st_intersects(boundary_nfhs5,shp_nfhs)

shp_nfhs_in_nfhs5 <- map2_dfr(psu_nfhs5,unique(boundary_nfhs5$REGCODE),
                          function(x,y){
                            
                            x_df <- shp_nfhs[x,c("DHSCLUST","ADM1NAME","DHSREGCO","DHSREGNA","URBAN_RURA")];
                            x_df$geometry <- NULL;
                            y_df <- boundary_nfhs5[y,c("REGNAME","OTHREGNA","OTHREGCO","REGCODE","SVYYEAR",
                                                 "REG_ID")];
                            y_df$geometry <- NULL;
                            bind_cols(x_df,y_df) %>% 
                              return(.)
                            
                            
                          }) %>% 
  distinct(DHSCLUST,ADM1NAME,DHSREGCO,DHSREGNA,.keep_all=TRUE)


missing_shp_in_nfhs5 <- anti_join(shp_nfhs %>% 
                                    dplyr::select(one_of("DHSCLUST","DHSREGCO","DHSREGNA")),
                                  shp_nfhs_in_nfhs5,
                                  by=c("DHSCLUST","DHSREGCO","DHSREGNA")) %>% 
  left_join(shp_nfhs_in_nfhs5 %>% 
              distinct_at(vars(one_of("DHSREGCO","DHSREGNA")),.keep_all=TRUE) %>% 
              dplyr::select(-DHSCLUST),
            by = c("DHSREGCO","DHSREGNA")) %>% 
  mutate(flag = "Imputed SHP NFHS5 data")


missing_shp_in_nfhs5$geometry <- NULL

bind_rows(shp_nfhs_in_nfhs5,
          missing_shp_in_nfhs5) %>% 
  
  write_csv(.,paste0("data/psu_on_mapnfhs5.csv"))

