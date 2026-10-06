library(tidyverse)
library(tidymodels)
library(skimr)
install.packages("dlookr")
library(dlookr)
library(broom)
library(kableExtra)
install.packages("readxl")
install.packages("xlsx")
library("xlsx")
library(readxl)
install.packages("stringr")
library(stringr)
library("corrplot")
library("psych")
install.packages("psych")
install.packages("corrplot")
install.packages("gridExtra")
install.packages("scales")
install.packages("rpart.plot")
install.packages("vip")
install.packages("tictoc")
install.packages("doParallel")
install.packages("kknn")
install.packages("ranger")
install.packages("finetune")
install.packages("Boruta")
install.packages("DALEXtra")
library(ggthemes)
library(hrbrthemes)
library("gridExtra")
library("scales")
library(DALEXtra)
library(Boruta)
library("finetune")
library("ranger")
library("kknn")
library("doParallel")
library(tictoc)
library(rpart.plot)
library(vip)

rcomen <- read_xlsx("./Datasets Valoraciones productos/DS0043 - REFERENCIAS - RESEÑAS_DETALLE COMENTARIOS_Table.xlsx")
rven <- read_xlsx("./Datasets Valoraciones productos/DS0043 - REFERENCIAS - RESEÑAS_REFERENCIAS - VALORACIÓN CLIENTES_Table.xlsx")
ronline2020 <- read_xlsx("./Datasets Valoraciones productos/DS0007- HI Ecommerce 1 de enero 2020  - 30 agosto 2022.xlsx")

print(rcomen)
skim(rcomen) 
skim(rven)
skim(ronline2020)

print(rven)
print(ronline2020)
#PRIMER BOCETO

#datos explicacion

head(rcomen) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(rcomen)

head(rven) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(rven)

head(ronline2020) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(ronline2020)


summary(databoceto$PRECIO)
databoceto2 <-log(databoceto$PRECIO)
summary(databoceto2)
databoceto
#OBJETIVO

#Tras mi experiencia como trabajador de LM Alicante, LM busca una transformación digital de sus
#establecimientos fisicos mediante la reduccion de su stock en tiendas.
#Por ello buscan que sus tiendas sean catalogos paraque luego el consumidor compre en la web, o que 
#el consumidor acuda a la tienda LM para contratar un servicio o un pedido personalizado(ej, mamparas)
#Los cuales dejen un mayor margen de Bº que la simple compra venta de productos(ej.baldosas)

#Existen una problematica en las tiendas LM denominada stock toxico, que son aquellos productos que se
#acumulan en la tienda y son dificiles de vender o tienen algún tipo de desperfecto.
#estos productos suponen un coste monetario a la empresa y tambien de oportunidad.
#por ello el objetivo de este TFG será predecir que producto se venderan con mayor facilidad que otros 
#mediante diversas variables y caracteristicas(comentarios ej) y por lo tanto serán aquellos productos que si deben de estar
#en tienda ya que sera mas dificil que se acumulen y puedan generar stock toxico.

#Para ello vas a limpiar los datos y quedarnos con las variables que nos interesan.
#ADEMAS, estamos en un periodo de transformacion digital y revolucion indutrial donde hay despidos masivos en las 
#grandes empresas como apple microsoft etc, ademas LM quiere ser como un amazon del bricolaje, por lo tanto cada vez
#mas esta dispuesto a llevar a cabo una transofrmacion digital de sus a almacen a ser una especie de show rooms con 
#asesoramiento, a diferencia de sus competidores como Porcelanossa o Gibeller, no se especializan completamente en una
#zona del hogar, pero poco a poco quieren hacer como "PCcomponentes" donde sus "tiendas" sean realmente un lugar para
#comprar al igual que podrias hacer en tu casa con la diferencia que tiene un profesional a tu disposición en caso
#de incertidumbre con el producto a elegir o si tiene algun tipo de reclamación. 
#El grupo ADEO, al cual pertenece LM, tambien es dueño de BricoMat, el cual ha construido una tienda al lado de 
#LM ALICANTE. En una primera instacia podria parecer que se estan haciendo la competencia pero nada mas lejos de la realidad
#Ya que Bricomatt se centra completamente en ser un Almacen al estilo IKEA, mientras que LM tiene una serie de profesionales
#los cuales llevan a cabo un asesoramiento al cliente de elegir sus productos. Y es aqui donde existe la canibalización de productos.
#Puesto que ambas empresas son mismas del mismo grupo empresarial, tambien llevan los productos identicos y Obramat, puede
#llevar a cabo una estrategia de diferenciacion via precios mientras que LM la hace via diferenciacion del producto el cual
#introduce un sobreprecio frente a su competencia por los profesionales que asesoran a los clientes al llegar a la tienda y tienen a derivar a productos mas caros
# por todos estos motivos es de vital importancia la transformacion de LM Alicante hacia un showrooms en algunas de sus secciones
#como son aquellas que llevan a cabo reformas(secciones: cocina, sanitario y ceramica.) Al diferenciarse LM via diferenciacion de producto
#no puede bajar sus precios pero si aumentar su calidad y eso le haga ir hacia un nicho de mayor renta. 
#Tenemos que destacar que el margen del beneficio de LM  se debe a la venta de productos complementarios de menor precio
#donde se aumenta mucho el margen de ganacias debido a su bajo costo(por ejemplo: Vender un WC y el codo de PVC para su instalacion aparte.)
#En este ejemplo el verdadero beneficio esta en la venta del codo y no en el WC. 
glimpse(rcomen)
glimpse(rven)
glimpse(ronline2020)

#primero limpiamos el dataset (rcomen)
#Fijarme mucho en el trabajo de Boston. Si podemos comparar MDH y Top 2500 con variables numericas.

#IDEAS para limpiar: en rcomen, Cambiar mdh y top 2500, mediante mutate(top 2500) y mdh cambiar
#observaciones a si o no. 
#en r online2020 crear mutate de precio, cambiar numerico numero de referencia
#en rven cambiar a numero enteros o decimales fijarlos.  CAMBIAR EN TODOS LOS DATET LA KEY, NUMERO REFERENCIA.

summary(rven1)
str(rven1)
summary(rcomen1)
summary(ronline20limpio)

#Voy a limpiar el dataset RCOMEN cambiando las variables mdh y top 2500.
rcomen1 <- rcomen %>% rename("MARCA PROPIA" = "TOP MDH", "TIPO DE CLIENTE" = "FIDELIDAD")
# Reemplazar cadenas de caracteres por otra
rcomen1$`MARCA PROPIA` <-str_replace_all(rcomen1$`MARCA PROPIA`,c("No MDH" = "NO", "MDH" = "SI"))
rcomen1$`TOP 2500` <-str_replace_all(rcomen1$`TOP 2500`,c("No TOP 2500" = "NO", "TOP 2500" = "SI"))

rcomen1 <-rcomen1 %>% rename("ID_PRODUCTOS" = "Nº REFERENCIA")
#Voy a limpiar el dataset RVEN

rven1 <- rven %>% rename("MARCA PROPIA" = "TOP MDH")
rven1$`MARCA PROPIA` <-str_replace_all(rven1$`MARCA PROPIA`,c("No MDH" = "NO", "MDH" = "SI"))
rven1$`TOP 2500` <-str_replace_all(rven1$`TOP 2500`,c("No TOP 2500" = "NO", "TOP 2500" = "SI"))
rven1 <-rven1 %>% rename("ID_PRODUCTOS" = "Nº REFERENCIA")
#¿Agrupar datos variable reviews en intervalos? pero cual es el objetivo del proyecto?

#Voy a limpar datos ronline2020

#1- cambiar nombre nº Articulo por  ID_PRODUCTOS para tener misma key en los 3 datasets. 
#2Crear variable precio.

#1
ronline20limpio <-ronline2020 %>% rename("ID_PRODUCTOS" = "Nº Artículo")
#2

#Crear variables que contengan las caracteristicas que un producto. Previamente, quitamos cualquier NA y filtramos los productos de sanitario.

rcomen1na <- rcomen1[!is.na(rcomen1$`VALORACIÓN MEDIA`),]
summary(rcomen1na)

Sanrven1 <- rven1 %>% filter(rven1$SECCIÓN == "SANITARIO")
Sanrcomen1 <- rcomen1na %>% filter(rcomen1na$SECCIÓN == "SANITARIO")
Sanroline1 <- ronline20limpio %>% filter(ronline20limpio$Sección == "SANITARIO")

#Probamos que hay varias reseñas de un mismo producto.
Sanrcomen1 %>% filter(Sanrcomen1$ID_PRODUCTOS == "16735502")
Sanrven1 %>% filter(Sanrven1$ID_PRODUCTOS == "16735502")

Sanroline1 %>% count(Sanroline1$Subsección)
datatipo <- Sanroline1 %>% count()

Sanroline1 %>% print(count(Sanroline1$Subsección))
Sanroline1 %>% summary(Sanroline1$Tipo)




datawcsuelo <- Sanroline1 %>% filter(Sanroline1$Tipo == "WC A SUELO")

#hacer captura de pantalla datos limpios
head(datawcsuelo) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(datawcsuelo)

head(Sanrven1) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(Sanrven1)

head(Sanrcomen1) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(Sanrcomen1)


#Limpiarwcsuelo


dwc <- subset(datawcsuelo, datawcsuelo$Descripción == "PACK")  

 datawcsuelo$Descripción %>% filter(!str_detect(text,"TAPA"))
 
datawcsuelo$Descripción[!datawcsuelo$Descripción == "TAPA WC ROCA CASSANDRA
"] 

datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'TAPA WC ROCA CASSANDRA'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'COD 48 APARATOS SANITARIOS'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'CISTERNA ALIMENTACION LATERAL MISTRAL'),]

datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'TAPA WC ROCA MERIDIAN N/COMP C/LIBRE BLA'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'TAPA INODORO AMORTIGUADA BAU GROHE'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'CISTERNA WC IDEALIVE'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'CISTERNA WC OUTLINE/AFFINITY/TYRIA'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'TAPA WC GALA NORTE CAIDA AMORTIGUADA'),]
datawcsuelo <- datawcsuelo[!(datawcsuelo$Descripción == 'CISTERNA AL/LATERAL ACCESS'),]

datawcsuelo <- datawcsuelo %>% mutate(PRECIO = datawcsuelo$Importe / datawcsuelo$Cantidad)

Sandatawcsuelo <- datawcsuelo

ggplot(data = Sanroline1) + geom_boxplot( mapping = aes(x = Subsección, y = Cantidad)) + facet_wrap(~Sanroline1$Tipo)

#creamos variable precio

#antes de crear un dataset con las caracteristicas de un wc, vamos a unir las bases de datos ya limpias en un nuevo dataset de prueba.

dataprueba <- merge(x = Sandatawcsuelo, y = Sanrcomen1)

#Primera union realizada, vamos a renombrar las variables y hacemos la union definitiva.

rven1 <- rven %>% rename("MARCA PROPIA" = "TOP MDH")

dataprueba <- dataprueba %>% rename("VALORACION RESEÑA" = "VALORACIÓN MEDIA")

datadefinitivo <- merge(x = dataprueba, y = Sanrven1 ) 

datadefinitivo <- datadefinitivo %>% select(-"UDS. VENDIDAS 12M",-"VENTA12M",
                                            -"GAMA")

databoceto <- merge(x = variables, y = datadefinitivo)

datadefinitivo %>% plot_correlate() 

write.xlsx(datawcsuelo,"datawcsuelo.xlsx")

#creamos las variables a mano en excel para facilitar el trabajo. Ademas eliminamos dos observaciones por tratarse
#de una cisterna y un inodoro independientes.


#creamos variables para hacer el dataset definitivo
#Creamos variable MARCA
print(datawcsuelo)

datawcsuelo <- datawcsuelo %>% mutate(MARCA3 = gsub("ROCA SANITARIO, SA TR","ROCA",Proveedor))
datawcsuelo$MARCA2<-str_replace_all(datawcsuelo$MARCA2,c("ALM. LEROY TORIJA S07" = "SENSEA"))
datawcsuelo$MARCA2 <- str_replace_all(datawcsuelo$MARCA2, c("ALM.LEROY TORIJA S07" = "SENSEA","LAZOS BATH, SL" = "LAZOS",
                                                            "BATH-COLLECTION, S.L." = "BATHCO",
                                                            "FOSSIL NATURA S.L.U." = "FOSSIL NATURA",
                                                            "GROHE ESPANA, SA" = "GROHE",
                                                            "IDEAL STANDARD, SLU TR" = "IDEAL",
                                                            "ALM. LEROY MECO S07" = "SENSEA",
                                                            "CERAMICAS GALA, S.A TR" = "GALA",
                                                            "FERRETERIA LA LLAVE, SL TR" = "LA LLAVE"))


#CORRECTO!!! 

datawcsuelo <-datawcsuelo %>% rename("MARCA" = "MARCA2")

datawcsuelo<- datawcsuelo %>% select(-"MARCA3",-"MARCA")

datawcsuelo$MARCA <- str_replace_all(datawcsuelo$MARCA,c("GALASSIA HISPANIA, SA" = "GALASSIA",
                                                         "ARTECRISTAL BANO, SL" = "ARTECRISTAL"))

#CREAMOS VARIABLE FONDO REDUCIDO.

datawcsuelo <- datawcsuelo %>% mutate("FONDO REDUCIDO" = gsub("ROCA","SI",MARCA))

datawcsuelo$`FONDO REDUCIDO` <- str_replace_all(datawcsuelo$`FONDO REDUCIDO`, c("SENSEA" = "SI","LAZOS" = "SI",
                                                            "BATHCO" = "SI",
                                                            "FOSSIL NATURA" = "NO",
                                                            "GROHE" = "SI",
                                                            "IDEAL" = "SI",
                                                            "GALA" = "NO",
                                                            "LA LLAVE" = "NO",
                                                            "NOSSIA HISPANIA, SA" = "NO",
                                                            "NO BANO, SL" ="NO"))

print(datawcsuelo)


datawcsuelo$`FONDO REDUCIDO`[c(2,3)] <- "SI"
datawcsuelo$`FONDO REDUCIDO`[c(7,8,12,14,15,16,17,18,19,20,22,24,25,28,29,35,36,37)] <- "NO"
#cambiar las observaciones, estan mal.
"SI" <- which(datawcsuelo$ID_PRODUCTOS[82281354] == datawcsuelo$`FONDO REDUCIDO`["NO"])
"SI" <- which(datawcsuelo$ID_PRODUCTOS[88279133] == datawcsuelo$`FONDO REDUCIDO`["NO"])

#La variable  "ahorro de agua" no es una variable relevante, ya que todos los WC's tienen un minimo de 3L 
#y un maximo de 6L

##############################################################################################
#PRUEBAS
filter(datadefinitivo, datadefinitivo$Proveedor == "GROHE")

max_observation <- subset(datadefinitivo, PRECIO > 300)

gr <- subset(datadefinitivo, datadefinitivo$ID_PRODUCTOS == "83840502")

gr <- datadefinitivo %>% filter(ID_PRODUCTOS == 83840502)
dataprueba %>% filter(ID_PRODUCTOS ==82016336)

Sanroline1 %>% filter(ID_PRODUCTOS == 82016336)

datawcsuelo %>% filter(Código ==205546 )
#cargamos base de datos "datawcsuelo" modifciada con las variables.  

variables <- read_xlsx("./datawcsuelo con variable.xlsx")

#Unimos las bases de datos para obtener los comentarios.


#############################################################################################

#Vamos a trabajar con una base de datos de prueba para avanzar en cuanto al código necesario para hacer el estudio.

############################################################################################

databoceto <- merge(x = variables, y = datadefinitivo)

datay <- merge(x = variables, y = datadefinitivo)

head(databoceto) %>% kable %>%
kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(databoceto)

head(variables) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(variables)

head(datadefinitivo) %>% kable %>%
  kableExtra::kable_styling(fixed_thead = list(enabled = T, background = "lightgreen"))

glimpse(datadefinitivo)


#realizamos analisis de variación.

databoceto %>%  plot_bar_category("TOP 2500")
databoceto %>%  plot_bar_category("MARCA PROPIA")
databoceto %>%  plot_bar_category("Gama")
databoceto %>% plot_bar_category("Descripción")
databoceto %>%plot_bar_category("MARCA")
##########################33
carac <- c("RIMLESS","TAPA AMORTIGUADA","SALIDA DUAL","FABRICACION","MATERIAL")

Grimless <-  ggplot(databoceto, aes(x = databoceto$RIMLESS)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "INODOROS CON SISTEMA RIMLESS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Posee o no posee",
                              y = "Observaciones totales")

Grimless
###############
Gtapaextra <-  ggplot(databoceto, aes(x = databoceto$`TAPA EXTRAIBLE`)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "INODOROS CON TAPA EXTRAIBLE",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Posee o no posee",
                              y = "Observaciones totales")

Gtapaextra
##################
Gtapamor <-  ggplot(databoceto, aes(x = databoceto$`TAPA AMORTIGUADA`)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "INODOROS CON TAPA AMORTIGUADA",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Posee o no posee",
                              y = "Observaciones totales")

Gtapamor
##############################################################################################
Gdual <-  ggplot(databoceto, aes(x = databoceto$`SALIDA DUAL`)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "INODOROS CON SALIDA DUAL",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Posee o no Posee",
                              y = "Observaciones totales")

Gdual
########################################################
Gfab <-  ggplot(databoceto, aes(x =datamateriales$FABRICACION)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "ORIGEN DE LA FABRICACION DE INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Fabricado o no fabricado en Europa",
                              y = "Observaciones totales")

Gfab
##############################
Gmat <-  ggplot(databoceto, aes(x = datamateriales$MATERIAL)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "MATERIALES DE FABRIACIÓN DE LOS INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Tipo de material",
                              y = "Observacioens totales")

Gmat
gfab_mat <- grid.arrange(Gmat,Gfab, ncol = 2)
gtapas <- grid.arrange(Gtapaextra,Gtapamor, ncol = 2)
gsistemas <- grid.arrange(ggaran,Grimless,Gdual, ncol = 3)

####Falta modificar ejes de graficos dobles. 


####3#################################3
#INTRODUCIR COMENTARIO ACERCA DE LOS PLOTS Y LAS OBSERVACIONES QUE VEMOS.
#mejora graficos anteriores ANALISIS EXPLORATORIO DE LOS DATOS
top <- ggplot(databoceto, aes(x = databoceto$`TOP 2500`)) +                      
  #geom_bar() +                                             
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS TOP 2500") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "Diagrama de barras TOP 2500",
                                subtitle = "Diagrama de barras",
                                caption = "Fuente: Elaboración Propia",
                                x = "Valoración media",
                                y = "Observaciones totales")
top
###########3
ggmarca <- ggplot(databoceto, aes(x = databoceto$`MARCA PROPIA`)) +
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("INODOROS MARCA PROPIA") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "Inodoros Marca Propia",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Pertenece o no pertenece",
                              y = "Observaciones totales")
ggmarca

#################################################################
gggama <- ggplot(databoceto, aes(y = databoceto$`FECHA CREACIÓN`, x =databoceto$MARCA)) + 
  geom_point() + ggtitle("Gamas de producto") + theme_ipsum_tw() + guide_axis(angle = 45)

gggama
#####
ggdescp <- ggplot(databoceto, aes(x = databoceto$DESCRIPCIÓN)) +
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("Modelos de inodoros") + theme_ipsum_tw() + coord_flip() + 
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=0.5,
            hjust=-0.3,
            size=4.0) + labs (title = "MODELOS DE INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Nombre de los modelos",
                              y = "Observaciones totales")
ggdescp
####
ggdescprecio <- ggplot(databoceto, aes(x = databoceto$DESCRIPCIÓN, y = PRECIO)) +
  geom_point() + labs(y= "Frecuencia") + 
  ggtitle("Modelos de inodoros") + theme_ipsum_tw() + coord_flip() + 
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=0.5,
            hjust=-0.3,
            size=4.0) + labs (title = "MODELOS DE INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Nombre de los modelos",
                              y = "Observaciones totales")

ggdescprecio
###
ggmarc <- ggplot(databoceto, aes(x = databoceto$MARCA)) +
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("MARCAS DE INODOROS QUE OBTIENEN UNA VALORACIÓN") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "MARCAS DE INODOROS QUE OBTIENEN UNA VALORACIÓN",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "MARCAS",
                              y = "Valoraciones totales")
ggmarc
###
max(databoceto$Importe)
grimporte <- ggplot(databoceto2, aes(x = datab)) 
grimporte + geom_bar()
grimporte + geom_histogram(stat = "density",)
grimporte + geom_density(alpha = 0.8, fill ="lightgreen") + xlim(0,200000) +
#Comentar densidad
grimporte + geom_density()
grimporte + geom_histogram(aes(y=..density..), stat = "bin", binwidth=100000, fill ="lightgreen") +
  geom_density() + theme_ipsum_tw() + xlab("precio") + ylab("densidad") +  labs(title = "Importe DE LOS INODOROS",
                                                                                subtitle = "Histograma",
                                                                                caption = "Fuente: Elaboración Propia",
                                                                                x = "Importe",
                                                                                y = "Densidad") 


ggimporte
###
max(databoceto$Cantidad)
grcant <- ggplot(databoceto, aes(x = databoceto$Cantidad)) 
grcant + geom_bar()
grcant + geom_histogram(fill = "lightgreen", bindwith = 30) + xlim(0,1500) + theme_ipsum_tw() + xlab("precio") + ylab("densidad") +  labs(title = "Importe DE LOS INODOROS",
                                                                                           subtitle = "Diagrama de barras",
                                                                                           caption = "Fuente: Elaboración Propia",
                                                                                           x = "Cantidad vendida",
                                                                                           y = "observaciones")


grcant + geom_density( fill ="lightgreen") + xlim(0,250000)
###
ggaran <- ggplot(databoceto, aes(x = databoceto$GARANTIA)) +
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("MARCAS DE INODOROS") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "GARANTIA DE INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Años de garantia",
                              y = "Observaciones totales")
ggaran
###
ggvr <- ggplot(databoceto, aes(x = datay$`VALORACION RESEÑA`)) +
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("MARCAS DE INODOROS") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "NÚMERO DE OPINIONES PARA CADA NIVEL DE PUNTUACIÓN",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Valoración de la reseña",
                              y = "Observaciones totales")

ggvr
###
griim <- ggplot(databoceto, aes(x = databoceto$`VALORACIÓN MEDIA`))
griim + geom_bar()
griim+ geom_histogram(stat = "density",)
griim + geom_density(alpha = 0.8, fill ="lightgreen") + xlim(3,5)
#Comentar densidad
griim + geom_density()
grao <- griim+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=0.125, fill ="lightgreen") + geom_density() + theme_ipsum_tw() + xlab("precio") + ylab("densidad") + labs (title = "PRECIO DE LOS INODOROS",
                                                                                                                                                                            subtitle = "Histograma",
                                                                                                                                                                            caption = "Fuente: Elaboración Propia",
                                                                                                                                                                         x = "Valoración media",
                                                                                                                                                                            y = "Densidad")
grao
##
ggcliente <- ggplot(databoceto, aes(x = databoceto$`TIPO DE CLIENTE`)) +
  geom_bar( colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("MARCAS DE INODOROS") + theme_ipsum_tw() +
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=-0.5, 
            size=5.0) + labs (title = "Tipo de cliente que ha valorado un inodoro",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Puntaje de la reseña",
                              y = "Observaciones totales")
ggcliente
##
ggres <- ggplot(databoceto, aes(x = databoceto$`Nº RESEÑAS`)) +
  geom_bar(colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("MARCAS DE INODOROS") + theme_ipsum_tw() + labs (title = "NUMERO DE OPINIONES DE INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Número de reseñas por cada modelo de inodoro",
                              y = "Observaciones totales")


ggres
###
ggprov <- ggplot(databoceto, aes(x = databoceto$Proveedor)) +
  geom_bar(width=0.5, colour="black", fill="lightgreen") + labs(y= "Frecuencia") + 
  ggtitle("MARCAS DE INODOROS") + theme_ipsum_tw() + coord_flip() + 
  geom_text(aes(label=..count..), stat='count',  
            position=position_dodge(0.9), 
            vjust=0.5,
            hjust=-0.3,
            size=4.0) + labs (title = "VALORACIÓN OPINION DE INODOROS",
                              subtitle = "Diagrama de barras",
                              caption = "Fuente: Elaboración Propia",
                              x = "Puntaje de la reseña",
                              y = "Observaciones totales")

ggprov
###
#Comentar densidad

#######################################################
datay

variab <- c("PRECIO", "VALORACION RESEÑA", "VALORACIÓN MEDIA")

for (z in variab){
  griim <- ggplot(databoceto, aes(x = z))
  griim + geom_bar()
  griim + geom_histogram()
  griim + geom_density(alpha = 0.8, fill ="lightgreen") + xlim(3,5)
  #Comentar densidad
  griim + geom_density()
  griim+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=0.125, fill ="lightgreen") + geom_density() + theme_ipsum_tw() + xlab("precio") + ylab("densidad") + labs (title = "PRECIO DE LOS INODOROS",
                                                                                                                                                                                                       subtitle = "Histograma",
                                                                                                                                                                                                       caption = "Fuente: Elaboración Propia",
                                                                                                                                                                                                       x = "Valoración media",
                                                                                                                                                                                                       y = "Densidad")
}
#######################################################
ggcant

###
databoceto %>% plot_hist_numeric("Importe")

groom <- ggplot(databoceto, aes(x = databoceto$PRECIO, colour = "lightgreen"))
groom + geom_bar()
groom+ geom_histogram(stat = "density")             
groom + geom_density()
groom+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=100, col = "black", fill = "green", alpha = 0.4) + geom_density() + theme_test() +
  xlim(0,500) + xlab("precio") + ylab("densidad") + ggtitle("PRECIO") 

wq <- ggplot(databoceto,  aes(x = PRECIO, fill = databoceto$MARCA == "ROCA","SENSEA",)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white") +
  geom_density(alpha=.2, fill="#B3EE3A")
  
wq


groom <- ggplot(databoceto, aes(x = PRECIO))
groom + geom_bar()
groom+ geom_histogram(stat = "density")             
groom + geom_density(alpha=.4, fill="#B3EE3A")
groom+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=100, fill= "lightgreen") + geom_density(alpha = 0.8) + theme_ipsum_tw() +
  xlim(0,500) + xlab("precio") + ylab("densidad") + ggtitle("PRECIO") + labs(title = "PRECIO DE LOS INODOROS",
                                                                           subtitle = "Histograma",
                                                                           caption = "Fuente: Elaboración Propia",
                                                                           x = "Precio",
                                                                           y = "Densidad")







#comenntar grafico.

#eliminamos observaciones atipicas y observamos 3 grandes saltos. en precios de 0 a 150 euros, de 150 a 250 y 250
# a 350 euros. Vamos a profundizar acerca de este rango de precio.

griim <- ggplot(databoceto, aes(x = databoceto$`VALORACIÓN MEDIA`)) 
griim + geom_bar()
griim+ geom_histogram(stat = "density",)
w <- griim + geom_density(alpha = 0.8, fill ="lightgreen") + theme_ipsum_tw() + xlim(3,5) + labs (title = "VALORACION MEDIA DE LOS INODOROS",
                                                                          subtitle = "DENSIDAD ACOTADA ENTRE LOS VALORES 3 Y 5",
                                                                          caption = "Fuente: Elaboración Propia",
                                                                          x = "Valoración media",
                                                                          y = "Densidad")


w
#############################################################

#Comentar densidad
griim + geom_density()
q <- griim+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=0.125, fill ="lightgreen") + xlim(0,5)  + geom_density() + theme_ipsum_tw() + xlab("precio") + ylab("densidad") + labs (title = "VALORACION MEDIA DE LOS INODOROS",
                                           subtitle = "HISTOGRAMA Y DENSIDAD",
                                           caption = "Fuente: Elaboración Propia",
                                           x = "Valoración media",
                                           y = "Densidad")
q

grid.arrange(q,w, ncol = 2)
png("q")
#######################################################################################

gruum <- ggplot(databoceto, aes(x = databoceto$Cantidad))
gruum + geom_bar()
gruum+ geom_histogram(stat = "density")             
gruum + geom_density()
gruum+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=100000) + geom_density() + theme_test() + xlab("cantidad") + ylab("densidad")
#####
greem <- ggplot(databoceto, aes(x = databoceto$`VALORACION RESEÑA`, fill = MARCA))
greem + geom_bar() + theme_ipsum_tw()  +   scale_fill_brewer(palette = "Spectral") + labs (title = "Valoraciones de los Inodoros",
                                                                                  subtitle = "Diagrama de barras",
                                                                                  caption = "Fuente: Elaboración Propia",
                                                                                  x = "Valoraciónes",
                                                                                  y = "observaciones totales") 

greem <- ggplot(datay, aes(x = datay$`VALORACION RESEÑA`, fill = MARCA))
greem + geom_bar() + theme_ipsum_tw() +  scale_fill_brewer(palette = "Dark") + labs (title = "Valoraciones de los Inodoros",
                                                                                       subtitle = "Diagrama de barras",
                                                                                       caption = "Fuente: Elaboración Propia",
                                                                                       x = "Valoraciones",
                                                                                       y = "observaciones totales") 




ggplot(databoceto, aes(x = datay$`VALORACION RESEÑA`)) + geom_bar()

df_roca <- subset(datay,datay$MARCA == "ROCA")
df_sensea <- subset(datay,datay$MARCA == "SENSEA")

groc <- ggplot(df_roca, aes(x = df_roca$`VALORACION RESEÑA`))
groc
groc + geom_bar(fill = "#009ACD") + theme_ipsum_tw() + labs (title = "Valoraciones de los Inodoros",
                                                                                     subtitle = "Diagrama de barras",
                                                                                     caption = "Fuente: Elaboración Propia",
                                                                                     x = "Valoraciónes",
                                                                                     y = "observaciones totales") 
gsensea
####

# Calcular el número de observaciones totales para cada categoría
recuento <- df_roca %>%
  group_by(`VALORACION RESEÑA`) %>%
  summarise(observaciones_totales = n())

# Fusionar los datos del recuento de observaciones con el data frame original
df_roca_con_recuento <- merge(df_roca, recuento, by = "VALORACION RESEÑA")

# Crear el gráfico de barras con etiquetas de texto
groc <- ggplot(df_roca_con_recuento, aes(x = `VALORACION RESEÑA`)) +
  geom_bar(fill = "#009ACD") +
  theme_ipsum_tw() +
  labs(title = "Valoraciones de los Inodoros ROCA",
       subtitle = "Diagrama de barras",
       caption = "Fuente: Elaboración Propia",
       x = "Valoracion",
       y = "Observaciones totales") +
  geom_text(aes(label = observaciones_totales, y = observaciones_totales), vjust = -0.5, color = "black", size = 4)

groc

###

# Calcular el número de observaciones totales para cada categoría
recuenta <- df_sensea %>%
  group_by(`VALORACION RESEÑA`) %>%
  summarise(observaciones_totales = n())

# Fusionar los datos del recuento de observaciones con el data frame original
df_sensea_con_recuento <- merge(df_sensea, recuenta, by = "VALORACION RESEÑA")

# Crear el gráfico de barras con etiquetas de texto
gsensea <- ggplot(df_sensea_con_recuento, aes(x = `VALORACION RESEÑA`)) +
  geom_bar(fill = "#90EE90") +
  theme_ipsum_tw() +
  labs(title = "Valoraciones de los Inodoros SENSEA",
       subtitle = "Diagrama de barras",
       caption = "Fuente: Elaboración Propia",
       x = "Valoracion",
       y = "Observaciones totales") +
  geom_text(aes(label = observaciones_totales, y = observaciones_totales), vjust = -0.5, color = "black", size = 4)

gsensea

grid.arrange(gsensea,groc, ncol = 2)

###
#COMENTAR
greem + geom_histogram(stat = "density")     
greem + geom_density()
greem+ geom_histogram(aes(y=..density..), stat = "bin", binwidth=10)+ geom_density() + theme_test()
+ xlab("V,RESEÑA") + ylab("densidad") 
######################


groom <- ggplot(databoceto, aes(x = databoceto$`Nº RESEÑAS`))
groom + geom_bar()
groom + geom_histogram(stat = "density")             
groom + geom_density()
groom + geom_histogram(aes(y=..density..), stat = "bin", binwidth=5) + geom_density() + theme_test() + xlab("cantidad") + ylab("densidad")
grim <- ggplot(databoceto, aes(x = databoceto$`TIPO DE CLIENTE`))
grim + geom_bar()
grum <- ggplot(databoceto, aes(x = databoceto$`FECHA CREACIÓN`))
grum + geom_bar()
min(databoceto$`FECHA CREACIÓN`)                                  
#FIN ANALISIS VARIACIÓN
########################################################
#Analisis de correlación.

colores_verdes <- colorRampPalette(c("lightgreen", "darkgreen"))

# Asignar el gradiente de colores verdes personalizado a los coeficientes de correlación
colores_cor <- colores_verdes(100)
colores_cor <- colores_cor[findInterval(dfcorfull, seq(-1, 1, length.out = 101))]

# Crear el gráfico de correlación con el gradiente de colores verdes personalizado
plot_correlate(df, colors = colores_cor)


dfcorfull %>%  plot_correlate() 

dfcorfull %>% plot_correlate() + theme_calc() +  labs(title = "Gráfico de correlación de las variables numéricas",
                                                      subtitle = "Análisis de correlación",
                                                      caption = "Fuente: Elaboración Propia",
                                                      color = "black",
                                                      x = "", y = "") + guides (x = guide_axis(angle = 45))

dfcorfull <- datay[, -c(1, 3, 4, 5, 6, 7)]

Material <- c("plastico","porcelana","ceramica")

############Comentar correlación variables numericas.

#variables categoricas

ggplot(dfcorfull, aes(x = MARCA, y = dfcorfull$Descripción)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~MARCA)

ggmarcamodelos <- ggplot(dfcorfull, aes(x = MARCA, y = Descripción)) + geom_point( color = "lightgreen", size = 3) + guides (x = guide_axis(angle = 45)) + theme_bw() +  labs(title = "Gráfico de correlación de las variables marca y descrpción",
                                                                                                                                       subtitle = "Análisis de correlación",
                                                                                                                                       caption = "Fuente: Elaboración Propia",
                                                                                                                                       y = "                                                 Descripción", side = 1,
                                                                                                                                       
                                                                                                                                       color = "black")
                                                                                                                                       

ggmarcamodelos
#####
ggmarcaimporte <- ggplot(dfcorfull, aes(y = dfcorfull$Importe, x = MARCA)) + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + ylim(0,150000) + theme_ipsum_tw() +  labs(title = "Diagrama de cajas de las variables marca e importe obtenido en total",
                                                                                                                                                                              subtitle = "Análisis de covariacion",
                                                                                                                                                                              caption = "Fuente: Elaboración Propia",
                                                                                                                                                                              y = "                                                 Importe Obtenido", side = 1,
                                                                                                                                                                              
                                                                                                                                                                              color = "black")

ggmarcaimporte
####
ggmarcacantidad <- ggplot(dfcorfull, aes(y = Cantidad, x = MARCA)) + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + ylim(0,1500) + theme_ipsum_tw() +  labs(title = "Diagrama de cajas de las variables marca y cantidad vendida",
                                                                              subtitle = "Análisis de covariación",
                                                                              caption = "Fuente: Elaboración Propia",
                                                                              y = "                                                 Ventas", side = 1,
                                                                              x = "Marca",
                                                                              color = "black")
ggmarcacantidad
###
ggmarcaprecio <- ggplot(dfcorfull, aes(y = PRECIO, x = MARCA)) + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + ylim(0,500) + theme_ipsum_tw() +  labs(title = "Diagrama de cajas de las variables marca y precio",
                                                                              subtitle = "Analisis de covariación",
                                                                              caption = "Fuente: Elaboración Propia",
                                                                              y = "                                                 Precio", side = 1,
                                                                              x ="Marca",
                                                                              color = "black")
ggmarcaprecio
##
ggmarcafondo<- ggplot(dfcorfull, aes(x = `FONDO REDUCIDO`, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                           subtitle = "Análisis de correlación",
                                                                           caption = "Fuente: Elaboración Propia",
                                                                           y = "                                                 Descripción", side = 1,
                                                                           
                                                                           color = "MARCA")

ggmarcafondo
##
ggmarcahorro<- ggplot(dfcorfull, aes(x = `AHORRO AGUA`, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                                        subtitle = "Análisis de correlación",
                                                                                                                                                                                        caption = "Fuente: Elaboración Propia",
                                                                                                                                                                                        y = "                                                 Descripción")
ggmarcahorro                                                                                                                                                                               
##
ggmarcarim<- ggplot(dfcorfull, aes(x = RIMLESS, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                                                   subtitle = "Análisis de correlación",
                                                                                                                                                                                                   caption = "Fuente: Elaboración Propia",
                                                                                                                                                                                                   y = "                                                 Descripción")
ggmarcarim
##
ggmarcamort<- ggplot(dfcorfull, aes(x = `TAPA AMORTIGUADA`, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                             subtitle = "Análisis de correlación",
                                                                                                                                                                             caption = "Fuente: Elaboración Propia",
                                                                                                                                                                             y = "                                                 Descripción")
ggmarcamort
##
ggmarcasalida <- ggplot(dfcorfull, aes(x = `SALIDA DUAL`, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                             subtitle = "Análisis de correlación",
                                                                                                                                                                             caption = "Fuente: Elaboración Propia",
                                                                                                                                                                             y = "                                                 Descripción")
ggmarcasalida
##
ggmarcaextraible <- ggplot(dfcorfull, aes(x = `TAPA EXTRAIBLE`, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                                       subtitle = "Análisis de correlación",
                                                                                                                                                                                       caption = "Fuente: Elaboración Propia",
                                                                                                                                                                                       y = "                                                 Descripción")
ggmarcaextraible
##
##
ggmarcagarantia <- ggplot(dfcorfull, aes(x = GARANTIA, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                                       subtitle = "Análisis de correlación",
                                                                                                                                                                                       caption = "Fuente: Elaboración Propia",
                                                                                                                                                                                       y = "                                                 Descripción")
ggmarcagarantia
##
ggmarcatop <- ggplot(dfcorfull, aes(x = `TOP 2500`, y = Descripción, color = MARCA)) + geom_point(size = 4) + scale_fill_brewer(palette = "Spectral") + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca, modelo y descripción",
                                                                                                                                                                                       subtitle = "Análisis de correlación",
                                                                                                                                                                                       caption = "Fuente: Elaboración Propia",
                                                                                                                                                                                       y = "                                                 Descripción")

ggmarcatop
##
ggmaterialvaloracion <- ggplot(datamateriales, aes(y = MATERIAL, x = `VALORACIÓN MEDIA`)) + geom_boxplot() + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + theme_ipsum_tw() +  labs(title = "DIAGRAMA DE LAS CAJAS DE LAS VARIABLES MATERIALES Y VALORACION MEDIA",
                                                                           subtitle = "ANALISIS DE COVARIACION",
                                                                           caption = "Fuente: Elaboración Propia",
                                                                           y = "                                                 Precio", side = 1,
                                                                           x ="Marca",
                                                                           color = "black")


ggmaterialvaloracion
########
ggorigenvaloracion <- ggplot(datamateriales, aes(y = FABRICACION, x = `VALORACIÓN MEDIA`)) + geom_boxplot() + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + theme_ipsum_tw() +  labs(title = "DIAGRAMA DE LAS CAJAS DE LAS VARIABLES FABRICACION Y VALORACION MEDIA",
                                                             subtitle = "ANALISIS DE COVARIACION",
                                                             caption = "Fuente: Elaboración Propia",
                                                             y = "                                                 ORIGEN", side = 1,
                                                             x ="VALORACION MEDIA",
                                                             color = "black")
ggorigenvaloracion
#############
###############3
ggmarcavaloracion <- ggplot(dfcorfull, aes(x = dfcorfull$`VALORACION RESEÑA`, y = Descripción)) + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + theme_ipsum_tw() +  labs(title = "DIAGRAMA D CAJAS DE LAS VARIABLES MODELOS DE WC Y VALORACIÓN DE LAS RESEÑAS",
                                                                              subtitle = "ANÁLISIS DE COVARIACIÓN",
                                                                              caption = "Fuente: Elaboración Propia",
                                                                              y = "                                                 MODELOS DE WC", side = 1,
                                                                              x = "VALORACIÓN DE LA RESEÑA",
                                                                              color = "black")
ggmarcavaloracion

###
ggmarcavalormedio <- ggplot(dfcorfull, aes(x = `VALORACIÓN MEDIA`, y = Descripción, color = MARCA)) + geom_point(size = 6) + 
  stat_boxplot(geom = "errorbar") + theme_ipsum_tw() + xlim(3,5) +  labs(title = "DIAGRAMA DE CAJAS DE LAS VARIABLES MODELO DE WC Y VALORACIÓN MEDIA",
                                                             subtitle = "ANALISIS DE COVARIACIÓN",
                                                             caption = "Fuente: Elaboración Propia",
                                                             y = "                                                 MODELOS DE WC", side = 1,
                                                             
                                                             color = "MARCA")
ggmarcavalormedio
##
ggmarcaopinion <- ggplot(dfcorfull, aes(x = MARCA, y = dfcorfull$`Nº RESEÑAS`)) + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + theme_ipsum_tw() +  labs(title = "DIAGRAMA DE CAJAS DE LAS VARIABLES MARCA Y NÚMERO DE RESEÑAS",
                                                                         subtitle = "ANALISIS DE COVARIACIÓN",
                                                                         caption = "Fuente: Elaboración Propia",
                                                                         y = "                                                 NÚMERO DE RESEÑAS", side = 1,
                                                                         X = "MARCA",
                                                                         color = "black")
ggmarcaopinion

##
ggmarcacliente <- ggplot(dfcorfull, aes(x = `TIPO DE CLIENTE`, y = MARCA)) + geom_point() + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca y descrpción",
                                                                         subtitle = "Análisis de correlación",
                                                                         caption = "Fuente: Elaboración Propia",
                                                                         y = "                                                 Descripción", side = 1,
                                                                         
                                                                         color = "black")
ggmarcacliente
##
ggplot(databoceto) + geom_boxplot(aes(x=MARCA, y = databoceto$`VALORACIÓN MEDIA`))
ggplot(databoceto) + geom_boxplot(aes(x=MARCA, y = PRECIO)) 
  coord_cartesian(ylim = c(0,500))
                                  
##
#########################
##
ggplot(databoceto) + geom_boxplot(aes(x=MARCA, y = databoceto$`Nº RESEÑAS`))
ggplot(databoceto) + geom_boxplot(aes(x=MARCA, y = databoceto$`VALORACION RESEÑA`))
ggplot(databoceto) + geom_point(aes(x=databoceto$`VALORACIÓN MEDIA`, y = databoceto$`Nº RESEÑAS`)) +  xlim(3,5) + geom_smooth()
###
ggplot(databoceto) + geom_bar(aes(x=MARCA, color = `TIPO DE CLIENTE`))

#######
databoceto %>% ggplot(aes(x=PRECIO, y=databoceto$`Nº RESEÑAS`)) + geom_point() + xlim(0,500) + geom_smooth(method = lm, se = FALSE)
###########33
datamateriales %>% ggplot(aes(y = Descripción, x = PRECIO, color = MARCA)) + geom_point(size = 6) +  xlim(50,450) + theme_ipsum_tw() + labs(title = "DIAGRAMA DE CAJAS DE LAS VARIABLES MODELOS DE WC, MARCA Y PRECIO",
                                                                                                                                            subtitle = "ANALISIS DE COVARIACIÓN",
                                                                                                                                            caption = "Fuente: Elaboración Propia",
                                                                                                                                            y = "                                                 MODELOS DE WC", side = 1,
                                                                                                                                            X = "PRECIO",
                                                                                                                                            color = "MARCA")

############
databoceto %>%  ggplot(aes(x=databoceto$PRECIO, y =databoceto$`VALORACIÓN MEDIA`)) + geom_point() + 
  xlim(0,500) + ylim(3,5) + geom_smooth(method = lm, se = FALSE)
########################3
#GRAFICO MUY IMPORTANTE. #podemos observar cierta correlación positiva entre valoracion media y precio.
###################################
#Cantidad variabe dependiente
databoceto %>% ggplot(aes(x=databoceto$`FONDO REDUCIDO`, y=databoceto$Cantidad)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$RIMLESS, y=databoceto$Cantidad)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`SALIDA DUAL`, y=databoceto$Cantidad)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`TAPA EXTRAIBLE`, y=databoceto$Cantidad)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`TAPA AMORTIGUADA`, y=databoceto$Cantidad)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$MARCA, y=databoceto$Cantidad)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`MARCA PROPIA`, y=databoceto$Cantidad)) + geom_boxplot()
#########################################################################################
#Precio variable dependiente
databoceto %>% ggplot(aes(x=`FONDO REDUCIDO`, y=databoceto$PRECIO)) + geom_boxplot()  + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + ylim(0,500) + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables Precio y Fondo reducido",
                                                                           subtitle = "Análisis de correlación",
                                                                           caption = "Fuente: Elaboración Propia",
                                                                           y = "PRECIO",
                                                                           
                                                                           color = "black")
databoceto %>% ggplot(aes(x=databoceto$RIMLESS, y=databoceto$PRECIO)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`SALIDA DUAL`, y=databoceto$PRECIO)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`TAPA EXTRAIBLE`, y=databoceto$PRECIO)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`TAPA AMORTIGUADA`, y=databoceto$PRECIO)) + geom_boxplot()
databoceto %>% ggplot(aes(x=databoceto$`TOP 2500`, y=databoceto$PRECIO)) + geom_boxplot()
##############################################################################################
ggmarcaprecio <- ggplot(dfcorfull, aes(y = PRECIO, x = MARCA)) + geom_boxplot( color = "black", fill = "lightgreen", outlier.color = "black", ) + 
  stat_boxplot(geom = "errorbar") + ylim(0,500) + theme_ipsum_tw() +  labs(title = "Gráfico de correlación de las variables marca y descrpción",
                                                                           subtitle = "Análisis de correlación",
                                                                           caption = "Fuente: Elaboración Propia",
                                                                           y = "                                                 Descripción", side = 1,
                                                                           
                                                                           color = "black")
ggmarcaprecio
##############################3
roca <- databoceto %>% select(DESCRIPCIÓN,PRECIO,MARCA,`VALORACIÓN MEDIA`) %>%  filter(MARCA == "ROCA")

sensea <- databoceto %>% select(DESCRIPCIÓN,PRECIO,MARCA,`VALORACIÓN MEDIA`) %>%  filter(MARCA == "SENSEA")

roca %>%  ggplot(aes(x = `VALORACIÓN MEDIA`, color = DESCRIPCIÓN, y = PRECIO))  + geom_point() + ylim(150,400)

databoceto

sensea %>%  ggplot(aes(x = `VALORACIÓN MEDIA`, color = DESCRIPCIÓN , y = PRECIO)) + geom_point()


###############
#modelo con datos NO proporcionados por LM todavia. NO HACER CASO A ESTA PARTE DEL CODIGO. EXPERIMENTO.
##############
# Crear un nuevo dataset a partir de variables existentes seleccionando por número de columna
columnas_seleccionadas <- c(14,15,16,17,18,19,20,21,22,26,27,29,35,36,37)  # Números de columna que deseas seleccionar GUCHU

dataguchu <- subset(datamateriales, select = columnas_seleccionadas)
dataguchu <- na.omit(dataguchu)
datamateriales
datatest <- databocetoc[.,9,10,11,13,14,15,16,17,18,19,20,25,26,33]
#0.8 test y 0.2 prueba
datatest_part <- dataguchu %>% initial_split(.7)
datatest_entren <- datatest_part %>% training()
datatest_prueb  <- datatest_part %>% testing()
d

dataguchu
receta_datatest1 <- datatest_entren %>% recipe(QUEJAS ~ + TEXTRAIBLE + SDUAL + FREDUCIDO + RIMLESS + GARANTIA + FABRICACION + MATERIAL)

receta_datatest_prep <- receta_datatest1 %>%  prep()



datatest_entren <- receta_datatest_prep %>% juice()
datatest_prueb  <- receta_datatest_prep %>% bake(testing(datatest_part))

modelo_datatest1 <- logistic_reg(mode= "classification", penalty = 0) %>% set_engine("glm")

modelo_datatest1_est <- modelo_datatest1 %>% 
  fit(QUEJAS ~ ., data = datatest_entren)
modelo_datatest1_est %>% broom::tidy()

summary(dataguchu)




##################
guchu_part <- dataguchu %>% initial_split(.8)
guchu_entren <- guchu_part %>% training()
guchu_prueb  <- guchu_part %>% testing()

receta_guchu1 <- training(guchu_part) %>%
  recipe(QUEJAS ~ + SDUAL + FREDUCIDO + RIMLESS + GARANTIA + FABRICACION + MATERIAL)

receta_guchu1_prep <- receta_guchu1 %>%  prep()



guchu_entren <- receta_guchu1_prep %>% juice()
guchu_prueb  <- receta_guchu1_prep %>% bake(testing(guchu_part))

modelo_guchu1 <- logistic_reg(mode= "classification", penalty = 0) %>% set_engine("glm")

modelo_guchu1_est <- modelo_guchu1 %>% 
  fit(QUEJAS ~ ., data = guchu_entren)
modelo_guchu1_est %>% broom::tidy()

###############
#probabilidad
modelo_databoceto1_est %>% 
  predict(databoceto_prueb)                  

proptibble <- modelo_databoceto1_est%>% 
  predict(databoceto_prueb, type = "prob")
#creamos el flujo de trabajo

databoceto_flujo <- workflow() %>%
  add_recipe(receta_databoceto1_prep) %>%       
  add_model(modelo_databoceto1)

databoceto_flujo_est <- databoceto_flujo %>% fit(data = databoceto_part %>% training()) 
#validación del modelo

confusion <-modelo_databoceto1_est %>% predict(databoceto_prueb) %>% 
  bind_cols(databoceto_prueb) %>%  
  conf_mat(truth=databoceto$`VALORACIÓN MEDIA`, estimate= .pred_class)  

metricas <- metric_set(accuracy, spec, sens)    

errores <-modelo_databoceto1_est %>% predict(databoceto_prueb) %>% 
  bind_cols(databoceto_prueb) %>%
  metricas(truth=databoceto$`VALORACIÓN MEDIA`, estimate= .pred_class)
kable(errores) 
databoceto_flujo_est %>% broom::tidy()
###curvas ROC

databoceto_probs <- modelo_databoceto1_est %>% predict(databoceto_prueb, type = "prob") %>%
  bind_cols(databoceto_prueb) 
databoceto_probs %>%
  roc_auc(satisfaccion, `.pred_no_satisfecho`) 
#####linea 427 modificar en funcion de lo que quiera predecir

mandrid_probs %>%
  roc_curve(satisfaccion, `.pred_no_satisfecho`) %>%  autoplot()
#################################################################################################################3
databoceto$`VALORACION RESEÑA` <-str_replace_all(databoceto$`VALORACION RESEÑA`,c("1" = "UNO", "2" = "DOS",
                                                                                  "3" = "TRES", "4" = "CUATRO",
                                                                                  "5" = "CINCO"))


databoceto <- databoceto %>%
  arrange(match(`VALORACION RESEÑA`, c("UNO", "DOS", "TRES", "CUATRO", "CINCO")))


databoceto$`VALORACION RESEÑA` <- as.factor(databoceto$`VALORACION RESEÑA`)

datay$`VALORACION RESEÑA` %>% table()
databoceto$`VALORACION RESEÑA` %>% table()
###############################################################################################################
#METODO DE ARBOLES

install.packages("rpart")
install.packages("rpart.plot")
install.packages("C50")
install.packages("caret")
library("rpart")
library("rpart.plot")
library("C50")
library("caret")


pruebadataboceto <- databoceto %>% select("Descripción", "MARCA", "FONDO REDUCIDO","RIMLESS","TAPA AMORTIGUADA",
                                          "SALIDA DUAL", "TAPA EXTRAIBLE", "GARANTIA","TOP 2500","MARCA PROPIA",
                                          "VALORACION RESEÑA")
pruebadataboceto$`VALORACION RESEÑA` <-as.factor(pruebadataboceto$`VALORACION RESEÑA`)

pruebadataboceto$`FONDO REDUCIDO`<- as.factor(pruebadataboceto$`FONDO REDUCIDO`)
pruebadataboceto$RIMLESS <- as.factor(pruebadataboceto$RIMLESS)
pruebadataboceto$`TAPA AMORTIGUADA` <- as.factor(pruebadataboceto$`TAPA AMORTIGUADA`)
pruebadataboceto$`SALIDA DUAL` <- as.factor(pruebadataboceto$`SALIDA DUAL`)
pruebadataboceto$`TAPA EXTRAIBLE` <- as.factor(pruebadataboceto$`TAPA EXTRAIBLE`)
pruebadataboceto$GARANTIA <- as.factor(pruebadataboceto$GARANTIA)
pruebadataboceto$`TOP 2500` <- as.factor(pruebadataboceto$`TOP 2500`)
pruebadataboceto$`MARCA PROPIA`<- as.factor(pruebadataboceto$`MARCA PROPIA`)
pruebadataboceto <- pruebadataboceto %>% rename(valoreview = "VALORACION RESEÑA", "TAMORT" = "TAPA AMORTIGUADA", 
                                                "TEXTRAIBLE" = "TAPA EXTRAIBLE",
                                                "TOP" = "TOP 2500", "MPROPIA" = "MARCA PROPIA")
pruebadataboceto <- pruebadataboceto %>% rename("FREDUCIDO" = "FONDO REDUCIDO")
pruebadataboceto <- pruebadataboceto %>% rename("AGUA" = "AHORRO"
                                                )
t.id <- createDataPartition(pruebadataboceto$valoreview)
T.idert <- createDataPartition(pruebadataboceto$valoreview, p = .7, list = F)
dfit <- rpart(data = pruebadataboceto[T.id,], valoreview ~ MARCA + FREDUCIDO + RIMLESS + TAMORT + SDUAL +
                TEXTRAIBLE + GARANTIA + TOP + MPROPIA, method = "class", )

T.idert <- createDataPartition(pruebadataboceto$valoreview, p = .7, list = F)
dfiter <- rpart(data = pruebadataboceto[T.idert,], valoreview ~ MARCA + FREDUCIDO + RIMLESS + TAMORT + SDUAL +
                  TEXTRAIBLE + GARANTIA + TOP + MPROPIA, method = "class", )

prp(dfiter, type = 2, nn=T, fallen.leaves = T,
    faclen = 4, varlen = 8, shadow.col = "gray")
summary(dfiter)

plotcp(dfiter)
text(dfit)

dfit$cptable

dfitpruned <- prune(dfit, cp = 0.01000000)

summary(dfit
        )
##########################################   RANDOM FOREST GUCHU   ##########################
install.packages("randomForest")
library(randomForest)
set.seed(11)
pruebadatamateriales <-na.omit(pruebadatamateriales)
summary(pruebadatamateriales)
test.id <- createDataPartition(dataguchus$QUEJAS, p = 0.8, list = F)
mod <- randomForest(x = dataguchus[test.id, 2:13], y = dataguchus[test.id, 14],
                    ntree = 100, xtest = dataguchus[-test.id, 2:13], ytest = dataguchus[-test.id, 14],
                    importance = T, keep.forest = T)
pruebadataboceto

mod
summary(mod)
qq <- mod$importance
qq
plot(dataguchus[test.id,]$QUEJAS, predict(mod, newdata = dataguchus[test.id,]),
     xlab = "actual", ylab = "predichos")

qq %>% kable()
knitr::kable(qq)
#TRAS VARIAS PRUEBAS AMBOS MODELOS DAN COMO VARIABLE MAS IMPORTANTE A LA MARCA Y EN SEGUNDO LUGAR A LA GARANTIA.
#COINCIDE CON LO QUE HABIAMOS VISTO EN LOS GRAFICOS.
###############################################
####################2 intento

set.seed(10)
wc_part <- pruebadataboceto %>% initial_split(.8)
wc_entren <- wc_part %>% training()
wc_prueb  <- wc_part %>% testing()

receta_wc1 <- training(wc_part) %>%
  recipe(valoreview ~ MARCA + FREDUCIDO + RIMLESS + TAMORT + SDUAL + TEXTRAIBLE + GARANTIA + TOP + MPROPIA)

receta_wc1_prep <- receta_wc1 %>%  prep()

wc_entren <- receta_wc1_prep %>% juice()
wc_prueb  <- receta_wc1_prep %>% bake(testing(wc_part))

modelo_wc1 <- logistic_reg(mode= "classification", penalty = 0) %>% set_engine("glm")

modelo_wc1_est <- modelo_wc1 %>% 
  fit(valoreview ~ MARCA + FREDUCIDO + RIMLESS + TAMORT + SDUAL + TEXTRAIBLE + GARANTIA + TOP + MPROPIA, data = wc_entren)
modelo_wc1_est %>% broom::tidy()



modelo_wc1_est %>% 
  predict(wc_prueb)                  

wcproptibble <- modelo_wc1_est%>% 
  predict(wc_prueb, type = "prob") %>% bind_cols(wc_prueb)


wc_flujo <- workflow() %>%
  add_recipe(receta_wc1_prep) %>%       
  add_model(modelo_wc1)

wc_flujo_est <- wc_flujo %>% fit(data = wc_part %>% training()) 

wc_flujo_est %>% extract_recipe() %>% bake(wc_prueb)
wc_flujo_est %>% extract_fit_parsnip() %>% tidy()          
wc_flujo_est %>% predict(wc_prueb)


#validar

confusion <-modelo_wc1_est %>% predict(wc_prueb) %>% 
  bind_cols(wc_prueb) %>%  
  conf_mat(truth=valoreview, estimate= .pred_class)  

metricas <- metric_set(accuracy, spec, sens)    

errores <-modelo_wc1_est %>% predict(wc_prueb) %>% 
  bind_cols(wc_prueb) %>%
  metricas(truth=valoreview, estimate= .pred_class)
kable(errores) 

wc_flujo_est %>% broom::tidy() 

estadisticasknn <- wc_flujo_est %>% broom::tidy() %>% kable()

estadisticasknn
estadisticasknn %>% kable_styling()
confusion
metricas
errores

wc_probs <- modelo_wc1_est %>% predict(wc_prueb, type = "prob") %>%
  bind_cols(wc_prueb) 
wc_probs %>%
  roc_auc(valoreview,.) 


WC_probs %>%
  roc_curve(valoreview$`.pred_CINCO`) %>%  autoplot()


databoceto
###################################################### modelo bien
####
pruebadatamateriales <- datamateriales %>% select("Descripción", "MARCA", "FONDO REDUCIDO","RIMLESS","TAPA AMORTIGUADA",
                                          "SALIDA DUAL", "TAPA EXTRAIBLE", "GARANTIA","TOP 2500","MARCA PROPIA",
                                          "VALORACION RESEÑA","FABRICACION","MATERIAL","QUEJAS")
dataguchu$MARCA <-as.factor(dataguchu$MARCA)
dataguchu$FABRICACION<- as.factor(dataguchu$FABRICACION)
dataguchu$MATERIAL <- as.factor(dataguchu$MATERIAL)
dataguchu$`FREDUCIDO`<- as.factor(dataguchu$`FREDUCIDO`)
dataguchu$RIMLESS <- as.factor(dataguchu$RIMLESS)
dataguchu$`TAMORT` <- as.factor(dataguchu$`TAMORT`)
dataguchu$`SDUAL` <- as.factor(dataguchu$`SDUAL`)
dataguchu$`TEXTRAIBLE` <- as.factor(dataguchu$`TEXTRAIBLE`)
dataguchu$GARANTIA <- as.factor(dataguchu$GARANTIA)
dataguchu$`TOP` <- as.factor(dataguchu$`TOP`)
dataguchu$`MPROPIA`<- as.factor(dataguchu$`MPROPIA`)
dataguchu$AGUA<- as.factor(dataguchu$AGUA)
dataguchu <- dataguchu %>% rename("TAMORT" = "TAPA AMORTIGUADA","TEXTRAIBLE" = "TAPA EXTRAIBLE", "TOP" = "TOP 2500", 
                                "MPROPIA" = "MARCA PROPIA")
dataguchu <- dataguchu%>% rename("FREDUCIDO" = "FONDO REDUCIDO")
dataguchu<- dataguchu  %>% rename("AGUA" = "AHORRO AGUA")
dataguchu$QUEJAS<- as.factor(dataguchu$QUEJAS)

####

Pruebadatamateriales_part <- pruebadatamateriales %>% initial_split(prop = .8)
lm1_receta <- training(Pruebadatamateriales_part) %>%            
  recipe(valoreview ~  + FREDUCIDO + RIMLESS + TAMORT + SDUAL + TEXTRAIBLE + GARANTIA + TOP + MPROPIA + FABRICACION + MATERIAL) 

lm1_modelo <- linear_reg(mode= "regression", penalty = 0) %>%
  set_engine("lm")

lm1_flujo <- workflow() %>%
  add_recipe(lm1_receta) %>%
  add_model(lm1_modelo)

lm1_flujo_est <- lm1_flujo %>% fit(data = training(Pruebadatamateriales_part)) 

lm1_flujo_est %>% extract_fit_parsnip() %>% tidy() %>% 
  kbl(digits = 2, caption = "Table 9. Modelo de Regresión") %>% kable_paper("hover")


class(pruebadatamateriales$valoreview)
pruebadatamateriales$valoreview <- as.numeric(pruebadatamateriales$valoreview)

lm1_flujo_est %>% extract_fit_parsnip() %>% 
  vip(num_features = 14)

m_metricas <- list()
lm_metricas[[1]] <- lm1_flujo_est %>% 
  predict(testing(pruebadatamateriales_part)) %>% 
  bind_cols(testing(pruebadatameriales_part)) %>%  
  metrics(truth=, estimate= .pred)



remove(pruebadatamateriales)
pruebadatamateriales$FREDUCIDO <- ifelse(pruebadatamateriales$FREDUCIDO == "SI", 1, 0)
pruebadatamateriales$RIMLESS <- ifelse(pruebadatamateriales$RIMLESS == "SI", 1, 0)
pruebadatamateriales$TAMORT <- ifelse(pruebadatamateriales$TAMORT == "SI", 1, 0)
pruebadatamateriales$SDUAL <- ifelse(pruebadatamateriales$SDUAL == "SI", 1, 0)
pruebadatamateriales$TEXTRAIBLE <- ifelse(pruebadatamateriales$TEXTRAIBLE == "SI", 1, 0)
pruebadatamateriales$TOP <- ifelse(pruebadatamateriales$TOP == "SI", 1, 0)
pruebadatamateriales$MPROPIA <- ifelse(pruebadatamateriales$FREDUCIDO == "SI", 1, 0)
pruebadatamateriales$FABRICACION <- ifelse(pruebadatamateriales$FABRICACION == "EUROPA", 1, 0)
pruebadatamateriales$FREDUCIDO <- ifelse(pruebadatamateriales$FREDUCIDO == "SI", 1, 0)
pruebadatamateriales$MATERIAL <- ifelse(pruebadatamateriales$MATERIAL == "Porcelana", 1, 0)
###############################################################################
#debido a que los modelos multivariante presentan problemas, pasamos a trasnformar las observaciones en dos grupos y modelamos.
#Observamos que las observaciones [4-1] presetan desde quejas poco importantes, hasta grandes problemas. Sin embargo en 
#IMPORTANTE
#observaciones de 5 estrellas no hay quejas. por ello agruparemos las observaciones en 5 = Perfecto y 1-4 No perfecto. 
########################################################################################################
##############################################################################
##############################################3
#INTENTAMOS HACER MODELO PREVIO A HACER MUTATE DE QUEJAS Y NO QUEJAS. BIBLIOGRAFIA: R EN ESPAÑOL
pruebadataboceto <- pruebadataboceto %>% select(-Descripción)
pruebadataboceto$MARCA <- as.factor(pruebadataboceto$MARCA)
pruebadatamateriales
glimpse(pruebadataboceto)
set.seed(77)
dataguchus <- dataguchu %>% select(-"AGUA")
datos_split <- initial_split(dataguchus, prop = 0.8, strata = QUEJAS)
datos_train <- datos_split %>% training()
datos_test <- datos_split %>% testing()
##Validacion datos
datos_val <- bootstraps(datos_train, strata = QUEJAS)
#procesamiento datos

receta1 <- recipe(QUEJAS~ ., data = datos_train) %>% 
  step_impute_mean(all_numeric_predictors()) %>% 
  step_dummy(all_nominal_predictors()) %>% step_normalize(all_predictors()) %>% prep()

receta1 %>% juice() %>% skim()

receta2 <- recipe(QUEJAS~., data = datos_train) %>% 
  step_impute_bag(all_numeric_predictors()) %>% 
  step_dummy(all_nominal_predictors()) %>% step_normalize(all_predictors()) %>% prep()
#########################
#especificacion de modelos

knn_espec <- nearest_neighbor(neighbors = tune(),
                        weight_func = tune(),
                        dist_power = tune()) %>%
  set_engine("kknn") %>% set_mode("classification")



tree_espec <- decision_tree(cost_complexity = tune(),
                            tree_depth = tune(),
                            min_n = tune()) %>% set_engine("rpart") %>% set_mode("classification")

random_forest_espec <- rand_forest(mtry = tune(),
                                   trees = tune(),
                                   min_n = tune()) %>% set_engine("ranger") %>% set_mode("classification")

#recetas y modelos

receta_set <- list(receta_1 = receta1, receta_2 = receta2)

modelo_set <- list(modelo1 = knn_espec, modelo2 = tree_espec,
                   modelo3 = random_forest_espec)

#flujo de modelo

datos_model_set <- workflow_set(
  preproc = receta_set,
  models = modelo_set,
  cross = TRUE)

#Ejecucion de los modelos.

clus <- parallel::makeCluster(8)
doParallel::registerDoParallel(clus)
tic()
set.seed(77)
workflow_modelos <- datos_model_set %>% workflow_map(
  resamples = datos_val,
  verbose = TRUE,
  metrics = metric_set(roc_auc),
  fn = "tune_grid",
  grid = 30)
parallel::stopCluster(clus)
toc()
  
#EVALUACION MODELOS

workflow_modelos %>% autoplot()

rank <- workflow_modelos %>% rank_results(select_best = T, rank_metric = "roc_auc")

#Seleccion del mejor modelo

mejor_resultado <- workflow_modelos %>% 
  extract_workflow_set_result("receta_1_modelo3") %>% 
  select_best(metric = "roc_auc")
mejor_resultado
#Ajuste del mejor modelo

random_forest_fit <- workflow_modelos %>% 
  extract_workflow("receta_1_modelo3") %>% 
  finalize_workflow(mejor_resultado) %>% 
  fit(datos_train)

#prediccion con nuveos datos.
random_forest_fit %>% predict(new_data = datos_test, type = "class") %>% 
  bind_cols(datos_test) %>% select(QUEJAS, .pred_class) %>% 
  conf_mat(truth = QUEJAS, estimate = .pred_class)
#con grafico
random_forest_fit %>% predict(new_data = datos_test, type = "class") %>% 
  bind_cols(datos_test) %>% select(QUEJAS, .pred_class) %>% 
  conf_mat(truth = QUEJAS, estimate = .pred_class) %>% autoplot()

##Curva Roc
random_forest_fit %>% predict(new_data = datos_test, type = "prob") %>% 
  bind_cols(datos_test) %>% select(QUEJAS, .pred_SI, .pred_NO) %>% 
  roc_curve(truth = QUEJAS, .pred_SI,.pred_NO) %>%  autoplot()
###Curva auc
random_forest_fit %>% predict(new_data = datos_test, type = "prob") %>% 
  bind_cols(datos_test) %>% select(valoreview, .pred_CINCO, .pred_CUATRO, .pred_DOS, .pred_TRES, .pred_UNO) %>% 
  roc_auc(truth = valoreview, .pred_CINCO:.pred_UNO)
###########################################################################################################~€
#OPTIMIZACIÓN E INTERPRETACION DEL MODELO.
#Utilizaremos el Analisis SHAP para responder a la pregunta de cuanto contribuye cada caracteristica a una prediccion individual.

random_forest_spec <- rand_forest(mtry = 2,
                                   trees = tune(),
                                   min_n = tune()) %>% set_engine("ranger", importance = "impurity") %>% set_mode("classification")
#Optimizacion a traves de busqueda iterativa

workflow_random_forest <- workflow() %>% add_recipe(receta1) %>% add_model(random_forest_spec)

ctrl_sa <- control_sim_anneal(verbose = T, no_improve = 30L)

cluss <- parallel::makeCluster(8)
doParallel::registerDoParallel(cluss)
tic()
set.seed(77)
sa_search <- workflow_random_forest %>%  tune_sim_anneal(resamples = datos_val,
                                                         iter = 30,
                                                         metrics = metric_set(roc_auc),
                                                         control = ctrl_sa)
parallel::stopCluster(cluss)
toc()

sa_search %>% autoplot()


sa_search %>% show_best(metrics = "roc auc")

mejor_modelo_definitivo <- select_best(sa_search, metrics = "roc auc")
mejor_modelo_definitivo

#AJuste final

random_forest_receta_final <- receta1 %>% finalize_recipe(mejor_modelo_definitivo)
random_forest_final <- random_forest_spec %>% finalize_model(mejor_modelo_definitivo)

workflow_random_forest_definitivo <- workflow_random_forest %>% update_recipe(random_forest_receta_final) %>% 
  update_model(random_forest_final)

workflow_random_forest_definitivo
random_forest_final_fit %>% extract_fit_engine()
random_forest_final_fit <- fit(workflow_random_forest_definitivo, data = datos_train) 
statss<- random_forest_final_fit$post
s
######################################
#IMPORTANCIA DE LAS VARIABLES.
#Gracias a las 4 lineas de codigo siguientes, observamos que las variables mas importante son que un wc sea producto mas vendido que sea marca rooca y que tenga tapa extraible.
#esto se puede explicar definiendo al consumidor de LM como marquista, que prefiere un producto de calidad, a uno de calidad-precio dando especial imporantcia a caracteristicas
#como la tapa extraible mientras que otras caracteristicas ya estan canibalizadas en el sector como son el sistema rimless, garantia fondo reducido etc.
#Son caracteristicas que el consumidor ya da por hecho. Por ello prefiere una mayor calidad en funcion de la marca que un wc calidad precio.
datos_vip <-random_forest_final_fit %>% extract_fit_parsnip() %>% 
  vip(geom = "col")
datos_vip
#####################3
pruebadataboceto
imp_Boruta <- Boruta(dataguchus[-14],dataguchus$QUEJAS)
plot(imp_Boruta)
#################################
#Coincide con lo dicho anteriormente con el paquete VIP, grafico mas bonito.
##################################
variables_vip <- random_forest_final_fit %>% extract_fit_parsnip() %>% vip(geom = "col")
variables_vip <- variables_vip$data$Variable
plot %>% variables_vip
explica_random_forest <- explain_tidymodels(random_forest_final_fit,
                                            data = datos_train,
                                            y = dataguchus$QUEJAS,
                                            label = "random_forest",
                                            verbose = T)
explica_random_forest
###
set.seed(77)
shap_datos <- predict_parts(explainer = explica_random_forest,
                            new_observation = datos_test,
                            type = "shap")

plot(shap_datos)

databoceto
###################################   ANALISIS DE TEXTO  #######################################
install.packages("tidytext")
library(tidytext)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(tm)
library(ggraph)
#########################################################################
datatexto <- databoceto %>% select(c(2,26,27,28,29,30,31,32,33))
texxt <- databoceto %>% select(2,31)
#La idea es coger un modelo y ver que dicen de dicho modelo, elegimos modelo Mitos de roca CODIGO BUENO
texxt$Descripción <- as.factor(texxt$Descripción)
texxt$COMENTARIO <- as.factor(texxt$COMENTARIO)


NEREAV <- texxt %>% filter(Descripción == "PACK WC NEREA S/V ENT/LAT")
NEREAH <- texxt %>% filter(Descripción == "PACK WC NEREA S/H ENT/LAT")
MITOSH <- texxt %>% filter(Descripción == "PACK WC ROCA MITOS S/H ENT/LAT")
MITOSV <- texxt %>% filter(Descripción ==  "PACK WC ROCA MITOS S/V ENT/LAT")

NEREA <- merge(x = NEREAV, y = NEREAH, all = TRUE)

NEREA$COMENTARIO <- as.character(NEREA$COMENTARIO)

NEREA <- data.frame(text = NEREA$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))

MITOS <- merge(x = MITOSH, y = MITOSV, all = TRUE)
MITOS2 <- merge(x = MITOSH, y = MITOSV, all = TRUE)
MITOS$COMENTARIO <- as.character(MITOS$COMENTARIO)
MITOS <- data.frame(text = MITOS$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))


MITOS %>% filter( n>3) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab("Palabras") + ylab("observaciones") + coord_flip()

NEREA %>% filter( n>3) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas NEREA") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")

#######################BIOGRAMAS
MITOS2$COMENTARIO <- MITOS2$COMENTARIO %>% as.character


pares=tibble(txt = MITOS2$COMENTARIO)
MITOS2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

MITOS2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
MITOS2_separated <- MITOS2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

MITOS2_filtered <- MITOS2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

MITOS2_counts <- MITOS2_separated %>%
  count(word1, word2, sort = TRUE)

MITOS2_counts

MITOS2_united <- MITOS2_separated %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo <- MITOS2_united %>%
  count(bigram, sort = TRUE)

#Graficamos
conteo %>%
  filter(n > 2) %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas MITOS") + labs(subtitle = "MARCA ROCA", caption = "Fuente: Elaboración propia")

#creamos el objeto redefilico
MITOS2_graph <- MITOS2_counts %>%
  filter(n > 3) %>%
  graph_from_data_frame()

MITOS2_graph

set.seed(2017)
ggraph(MITOS2_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red")

###################################################################################################

MITOSH %>% filter(MITOSH$COMENTARIO == "la tapa")
MITOSH[duplicated(grep("la tapa\\", MITOSH$COMENTARIO)),]
tapa_mitos<- MITOSH[str_detect(MITOSH$COMENTARIO, "la tapa"),]

##################################################################### CODIGO BUENO ### Conteo palabras comentarios en general
texxt$COMENTARIO <- texxt$COMENTARIO %>% as.factor()
texxt$Descripción <- texxt$Descripción %>% as.factor()
texxt <- texxt%>% select(COMENTARIO,) %>% 
  map_dfr(~gsub("http[^[:space:]]*", "",texxt$COMENTARIO)) 
#######################################################################################333

texxt$COMENTARIO <- stopwords(language = "es")
te
texxt <- gsub("\\r", "", texxt)
texxt <- as.data.frame(texxt)
resultado <- data.frame(text = datatexto$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))

names(lexiconSW)<-"word"
lexiconSW$word<-as.character(lexiconSW$word)


library(lubridate)
datatexto_text <-  resultado %>% anti_join(get_stopwords(language="es"))
library(lubridate)
install.packages("wordcloud")
library(wordcloud)
install.packages("wordcloud2")
library(wordcloud2)
datatexto_text %>% ungroup() %>% 
  count(word) %>%
  with(wordcloud(word, n, type ="file",
                 lang = "spanish",
                 excludeWords = NULL,
                 textStemming = FALSE,
                 colorPalette = "Dark2",
                 min.freq = 4,
                 max.words = 10000))
#####################################################################
library(tidyverse)
library(tidyr)
library(purrr)
library(widyr)
library(ggraph)
library(igraph)
library(topicmodels)
library(lubridate)
library(wordcloud)
library(dplyr)
##############################################################
#Limpiar texto
prueba <- as.data.frame(datatexto_text)
datatexto_text

datatexto
datatexto_text <- datatexto$COMENTARIO %>% tolower()
prueba2 <- prueba %>% select %>% 
  map_dfr(~gsub("http[^[:space:]]*","",datatexto_text)) 
datatexto_text(6)

#Importar el texto
texto <- readLines("ruta/a/tu/archivo.txt")

#Convertir el texto a minúsculas
datatexto_text <- tolower(datatexto_text)

#Eliminar signos de puntuación y números
prueba2 <- gsub("[[:punct:]]", " ", prueba$datatexto_text)
prueba2 <- gsub("[[:digit:]]", " ", prueba$datatexto_text)
prueba2
#Eliminar palabras vacías
library(tm)
install.packages("stopwords")
datatexto_text <-  resultado %>% anti_join(get_stopwords(language="es"))

#Eliminar espacios en blanco adicionales
texto <- gsub("\\s+", " ", texto)

#Tokenizar el texto
texto <- unlist(strsplit(texto, " "))

#Crear la matriz de términos de documento (DTM)
library(tm)
dtm <- DocumentTermMatrix(Corpus(VectorSource(texto)))
################################################
#hacer modelo caracteristicas para conseguir un producto de 5 estrellas. 
#PARA ELLO
#CON RANDOOM FOREST CARACTERISTICAS EN GENERAL
#CON LOGI SABER LINEALIDAD DE LAS CARACTERICAS CUANTO DE IMORTANTE ES UNA CARACTERITICA
#CON KNN PREDECIR NUEVO WC POR EJEMPLO HACIA QUE MARCA SE ASEMEJA
#JUGAR CON LA MARCA FRENTE A LAS CARACTERISTICAS PARA SABER Y HACER UN MODELO CON ESO 
#NOTAS SACADAS DE PEDRO ALBORRAL TUTOR TFG.


write.xlsx(datay, "datamarerial.xlsx")
datamateriales <- read_xlsx("./datamateriales.xlsx")
datamateriales <- as.data.frame(datamateriales)
datamateriales <- mutate(datamateriales, FABRICACION = ifelse(MARCA== "ROCA", "EUROPA", "NO_EUROPA"))
datamateriales <- mutate(datamateriales, QUEJAS = ifelse(`VALORACION RESEÑA` == 5, "NO", "SI"))
remove(datamateriales)
###################################################################################################################
set.seed(10)
datatest_part <- dataguchu %>% initial_split(.8)
datatest_entren <- datatest_part %>% training()
datatest_prueb  <- datatest_part %>% testing()
d

dataguchu
receta_datatest1 <- datatest_entren %>% recipe(QUEJAS ~ + TEXTRAIBLE + SDUAL + FREDUCIDO + RIMLESS + GARANTIA + FABRICACION + MATERIAL)

receta_datatest_prep <- receta_datatest1 %>%  prep()



datatest_entren <- receta_datatest_prep %>% juice()
datatest_prueb  <- receta_datatest_prep %>% bake(testing(datatest_part))

modelo_datatest1 <- logistic_reg(mode= "classification", penalty = 0) %>% set_engine("glm")

modelo_datatest1_est <- modelo_datatest1 %>% 
  fit(QUEJAS ~ ., data = datatest_entren)
modelo_datatest1_est %>% broom::tidy()
resultado_tidy <- broom::tidy(modelo_datatest1_est)
tabla_formateada <- kable(resultado_tidy)
resultado_tidy %>% head %>% kable()
print(tabla_formateada)
library(knitr)

#probabilidad
modelo_datatest1_est %>% 
  predict(datatest_prueb)                  

proptibble <- modelo_datatest1_est%>% 
  predict(datatest_prueb, type = "prob")
#creamos el flujo de trabajo

datatest_flujo <- workflow() %>%
  add_recipe(receta_datatest_prep) %>%       
  add_model(modelo_datatest1)

datatest_flujo_est <- datatest_flujo %>% fit(data = datatest_part %>% training()) 


#validación del modelo

confusion <-modelo_datatest1_est %>% predict(datatest_prueb) %>% 
  bind_cols(datatest_prueb) %>%  
  conf_mat(truth=QUEJAS, estimate= .pred_class)  

metricas <- metric_set(accuracy, spec, sens)    

errores <-modelo_datatest1_est %>% predict(datatest_prueb) %>% 
  bind_cols(datatest_prueb) %>%
  metricas(truth=QUEJAS, estimate= .pred_class)
kable(errores) 
Estadisticas<-  datatest_flujo_est %>% broom::tidy()
datatest_flujo_est %>% broom::tidy()
Estadisticas
metricas
errores
confusion
###curvas ROC

datatest_probs <- modelo_datatest1_est %>% predict(datatest_prueb, type = "prob") %>%
  bind_cols(datatest_prueb) 
datatest_probs %>%
  roc_auc(QUEJAS, `.pred_NO`) 


datatest_probs %>%
  roc_curve(QUEJAS, `.pred_NO`) %>%  autoplot()
#######################################################IMPORTANCIA
import <- lm1_flujo_est %>% extract_fit_parsnip() %>% 
  vip(num_features = 14)
import %>% ggplot()

########################################################################3
Boston_cv <- training(Boston_part) %>% vfold_cv(v=10)
lm1_flujo_est %>% extract_fit_parsnip() %>% 
  vip(num_features = 14)
