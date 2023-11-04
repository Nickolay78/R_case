# Підключення бібліотек
library (leaflet)
library (sf)
library (htmlwidgets)

# Отримання геоданих
shape_data <- st_read("Shape_files/ukr_admbnda_adm1_sspe_20230201.shp")

# Приведення назв регіонів у базі географічних даних 
# у відповідність із назвами у базі статистичних даних
shape_data$ADM1_UA <- replace(shape_data$ADM1_UA, 
  shape_data$ADM1_UA == "Автономна Республіка Крим", "АР Крим")

# Об'єднання географічної та статистичної баз даних за назвою регіону
shape_data<-shape_data %>% left_join(data, by = c( "ADM1_UA"="Region" ))

# Отримання даних для шарів картограми (по роках)
shape_data_2022 <- shape_data %>% filter(Year == 2022)
shape_data_2021 <- shape_data %>% filter(Year == 2021)

# Функція для визначення кольорів регіональних полігонів 
# залежно від кількості облікованих проваджень
pal_d<-colorBin(palette =  c('#006837','#a6d96a','#ffffbf','#fdae61','#a50026'), 
                domain = shape_data$ACC, bins = 5)

#Побудова картограми
map<-leaflet()%>%addTiles()%>%
  addPolygons(data=shape_data_2021,group = "2021",
              weight=1,fillOpacity = 0.6,
              color = pal_d (shape_data_2021$ACC),
              popup = ~paste0("<b>", ADM1_UA, "</b>", 
                  "<br/>","Кількість облікованих проваджень у 2021 році:", ACC),
              highlight = highlightOptions(weight = 3, color = "white"))%>%
  addPolygons(data=shape_data_2022,group = "2022",
              weight=1,fillOpacity = 0.6,
              color = pal_d (shape_data_2022$ACC),
              popup = ~paste0("<b>", ADM1_UA, "</b>", 
                  "<br/>","Кількість облікованих проваджень у 2022 році:", ACC),
              highlight = highlightOptions(weight = 3, color = "white"))%>%
  addLayersControl(baseGroups = c("2021","2022"), )

# Виведення картограми у вікно Viewer
map

# Збереження картограми у файл *.html
saveWidget (map, "map.html")
