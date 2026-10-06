#ANALISIS DE TEXTO LEROY MERLIN

###################################   ANALISIS DE TEXTO  #######################################
install.packages("tidytext")
library(tidytext)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(tm)
library(ggraph)
library(tidytext) #Análisis de datos textuales
library(ggplot2) #Graficas
library(wordcloud2) #Graficas datos textuales
library(tidyr) #Procemsamiento
library(igraph)#grafico de redes
library(ggraph)#grafico de redes
library("udpipe") #toquenización y diccionarios en español
install.packages("udpipe")
library(stringr) #Manejo de cadenas de texto expresiones regulares
library(dplyr) #Procemsamiento
library(readxl) #Cargar archivos excel
library(readr) #Cargar archios csv
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



MITOS <- merge(x = MITOSH, y = MITOSV, all = TRUE)
MITOS2 <- merge(x = MITOSH, y = MITOSV, all = TRUE)
MITOS$COMENTARIO <- as.character(MITOS$COMENTARIO)
MITOS <- data.frame(text = MITOS$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))


MITOS %>% filter( n>3) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightblue") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas MITOS") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")



#######################BIOGRAMAS MITOS
MITOS2$COMENTARIO <- MITOS2$COMENTARIO %>% as.character


pares=tibble(txt = MITOS2$COMENTARIO)
MITOS2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

MITOS2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
MITOS2_separated <- MITOS2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- data_frame(word = c(tm::stopwords("spanish")),
                                lexicon = "spanish")


MITOS2_filtered <- MITOS2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

MITOS2_counts <- MITOS2_filtered %>%
  count(word1, word2, sort = TRUE)

MITOS2_counts

MITOS2_united <- MITOS2_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo <- MITOS2_united %>%
  count(bigram, sort = TRUE)

#Graficamos
conteo %>%
  filter(n > 1) %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightblue") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas MITOS") + labs(subtitle = "MARCA ROCA", caption = "Fuente: Elaboración propia")

#creamos el objeto redefilico
MITOS2_graph <- MITOS2_counts %>%
  filter(n > 2) %>%
  graph_from_data_frame()

MITOS2_graph

set.seed(2017)
ggraph(MITOS2_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red filtro superior a 2 palabras")

###################################################################################################

MITOSH %>% filter(MITOSH$COMENTARIO == "la tapa")
MITOSH[duplicated(grep("la tapa\\", MITOSH$COMENTARIO)),]
tapa_mitos<- MITOSH[str_detect(MITOSH$COMENTARIO, "la tapa"),]
###################################################################################CODIGO APARTE
texxt$COMENTARIO <- stopwords(language = "es")
te
texxt <- gsub("\\r", "", texxt)
texxt <- as.data.frame(texxt)
resultado <- data.frame(text = datatexto$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))
###################################################################################################### NEREA

NEREA <- merge(x = NEREAV, y = NEREAH, all = TRUE)

NEREA$COMENTARIO <- as.character(NEREA$COMENTARIO)

NEREA <- data.frame(text = NEREA$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))

NEREA %>% filter( n>3) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas NEREA") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")

####
NEREA2 <- merge(x = NEREAV, y = NEREAH, all = TRUE)
NEREA2$COMENTARIO <- NEREA2$COMENTARIO %>% as.character()


pares=tibble(txt = NEREA2$COMENTARIO)
NEREA2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

NEREA2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
NEREA2_separated <- NEREA2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- data_frame(word = c(tm::stopwords("spanish")),
                                lexicon = "spanish")

NEREA2_filtered <- NEREA2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

NEREA2_counts <- NEREA2_filtered %>%
  count(word1, word2, sort = TRUE)

NEREA2_counts

NEREA2_united <- NEREA2_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo_NEREA <- NEREA2_united %>%
  count(bigram, sort = TRUE)

#Graficamos
conteo_NEREA %>%
  filter(n > 1) %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas NEREA") + labs(subtitle = "MARCA SENSEA", caption = "Fuente: Elaboración propia")

#creamos el objeto redefilico
NEREA2_graph <- NEREA2_counts %>%
  filter(n > 2) %>%
  graph_from_data_frame()

NEREA2_graph

set.seed(2017)
ggraph(NEREA2_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red") + theme_clean()
################################3
ROCAEOS <- texxt %>% filter(Descripción == "PACK WC ROCA EOS S/DUAL ENT/INF")

ROCAEOS$COMENTARIO <- as.character(ROCAEOS$COMENTARIO)
ROCAEOS <- data.frame(text = ROCAEOS$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))


ROCAEOS %>% filter( n>1) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas ROCA EOS") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")
################################################################################
ROCAEOS2 <- texxt %>% filter(Descripción == "PACK WC ROCA EOS S/DUAL ENT/INF")
ROCAEOS2$COMENTARIO <- ROCAEOS2$COMENTARIO %>% as.character()


pares=tibble(txt = ROCAEOS2$COMENTARIO)
ROCAEOS2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

ROCAEOS2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
ROCAEOS2_separated <- ROCAEOS2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- data_frame(word = c(tm::stopwords("spanish")),
                                lexicon = "spanish")

ROCAEOS2_filtered <- ROCAEOS2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

ROCAEOS2_counts <- ROCAEOS2_filtered %>%
  count(word1, word2, sort = TRUE)

ROCAEOS2_counts

ROCAEOS2_united <- ROCAEOS2_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo_ROCAEOS <- ROCAEOS2_united %>%
  count(bigram, sort = TRUE)

#Graficamos
conteo_ROCAEOS  %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas ROCA EOS") + labs(subtitle = "MARCA ROCA", caption = "Fuente: Elaboración propia")

#creamos el objeto redefilico
ROCAEOS2_graph <- ROCAEOS2_counts %>%
  filter(n > 1) %>%
  graph_from_data_frame()

ROCAEOS2_graph

set.seed(2017)
ggraph(ROCAEOS2_graph, layout = "fr") + 
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red") + theme_clean()
###########################
NEO <- texxt %>% filter(Descripción == "PACK WC SENSEA NEO S/DUAL ENT/INF")

NEO$COMENTARIO <- as.character(NEO$COMENTARIO)

NEO <- data.frame(text = NEO$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))

NEO %>% filter( n>3) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas NEO") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")
#######################  
NEO2 <- texxt %>% filter(Descripción == "PACK WC SENSEA NEO S/DUAL ENT/INF")

NEO2$COMENTARIO <- NEO2$COMENTARIO %>% as.character()


pares=tibble(txt = NEO2$COMENTARIO)
NEO2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

NEO2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
NEO2_separated <- NEO2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- data_frame(word = c(tm::stopwords("spanish")),
                                lexicon = "spanish")

NEO2_filtered <- NEO2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

NEO2_counts <- NEO2_filtered %>%
  count(word1, word2, sort = TRUE)

NEO2_counts

NEO2_united <- NEO2_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo_NEO <- NEO2_united %>%
  count(bigram, sort = TRUE) %>% filter( n> 1)


#Graficamos
conteo_NEO  %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas NEO") + labs(subtitle = "MARCA SENSEA", caption = "Fuente: Elaboración propia")

#creamos el objeto redefilico
NEO2_graph <- NEO2_counts %>%
  filter(n > 1) %>%
  graph_from_data_frame()

NEO2_graph

set.seed(2017)
ggraph(NEO2_graph, layout = "fr") + 
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red") + theme_clean()
############################################################
LEGACY <- texxt %>% filter(Descripción == "PACK WC ROCA LEGACY S/DUAL ENT/INF RIMLE")

LEGACY$COMENTARIO <- as.character(LEGACY$COMENTARIO)

LEGACY <- data.frame(text = LEGACY$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))

LEGACY %>% filter( n>3) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightblue") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas LEGACY") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")
########################################################
LEGACY2 <- texxt %>% filter(Descripción == "PACK WC ROCA LEGACY S/DUAL ENT/INF RIMLE")

LEGACY2$COMENTARIO <- LEGACY2$COMENTARIO %>% as.character()


pares=tibble(txt = LEGACY2$COMENTARIO)
LEGACY2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

LEGACY2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
LEGACY2_separated <- LEGACY2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- data_frame(word = c(tm::stopwords("spanish")),
                                lexicon = "spanish")

LEGACY2_filtered <- LEGACY2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

LEGACY2_counts <- LEGACY2_filtered %>%
  count(word1, word2, sort = TRUE)

LEGACY2_counts

LEGACY2_united <- LEGACY2_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo_LEGACY <- LEGACY2_united %>%
  count(bigram, sort = TRUE) %>% filter( n> 1)


#Graficamos
conteo_LEGACY  %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightblue") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas LEGACY") + labs(subtitle = "MARCA ROCA", caption = "Fuente: Elaboración propia") + 
  annotation_custom(logo_grob, xmin = 7, xmax = 8, ymin = 7, ymax = 8,
                    alpha = 0.5)
 

#creamos el objeto redefilico
NEO2_graph <- NEO2_counts %>%
  filter(n > 1) %>%
  graph_from_data_frame()

NEO2_graph

set.seed(2017)
ggraph(NEO2_graph, layout = "fr") + 
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red") + theme_clean()

wordcloud2(NEO %>% filter(n>3))
wordcloud2(LEGACY %>% filter(n>3)) 
wordcloud2(NEREA %>% filter(n>2))
wordcloud2(MITOS %>% filter(n>2))


install.packages("cowplot")
library("cowplot")
library("png")
logo <- readPNG("./rocabueno.png")

logo_grob <- rasterGrob(logo, interpolate=TRUE)
ggplot(data, aes(x = x, y = y)) + 
  geom_point() + 
  annotation_custom(logo_grob, xmin = 2.5, xmax = 3, ymin = 5.5, ymax = 6)
###################################################################################3

AKKRON <- texxt %>% filter(Descripción == "PACK WC DUAL AKRON S/DUAL ENT/INF")

AKKRON$COMENTARIO <- as.character(AKKRON$COMENTARIO)

AKKRON <- data.frame(text = AKKRON$COMENTARIO) %>% 
  unnest_tokens(word,text) %>% 
  count(word, sort = TRUE) %>% anti_join(get_stopwords(language="es"))

AKKRON %>% filter( n>1) %>% 
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas AKKRON") + labs(subtitle = "Analisis de texto", caption = "Fuente: Elaboración propia")
#######################  
AKKRON2 <- texxt %>% filter(Descripción == "PACK WC SENSEA NEO S/DUAL ENT/INF")

AKKRON2$COMENTARIO <- AKKRON2$COMENTARIO %>% as.character()


pares=tibble(txt = AKKRON2$COMENTARIO)
AKKRON2_bigrams <- pares %>%
  unnest_tokens(bigram,txt, token = "ngrams",n=2)

AKKRON2_bigrams %>%
  count(bigram, sort = TRUE)
############################################## PASO2
AKKRON2_separated <- AKKRON2_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- data_frame(word = c(tm::stopwords("spanish")),
                                lexicon = "spanish")

AKKRON2_filtered <- AKKRON2_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

AKKRON2_counts <- AKKRON2_filtered %>%
  count(word1, word2, sort = TRUE)

AKKRON2_counts

AKKRON2_united <- AKKRON2_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#
conteo_AKKRON <- AKKRON2_united %>%
  count(bigram, sort = TRUE) %>% filter( n> 1)


#Graficamos
conteo_AKKRON  %>%
  mutate(bigram = reorder(bigram, n)) %>%
  ggplot(aes(bigram, n)) +
  geom_col( fill = "lightgreen") + xlab("Palabras") + ylab("observaciones") + coord_flip() +theme_clean() + 
  ggtitle("Palabras mas utilizadas AKKRON") + labs(subtitle = "MARCA DISTINTA A ROCA Y SENSEA", caption = "Fuente: Elaboración propia")

#creamos el objeto redefilico
AKKRON2_graph <- AKKRON2_counts %>%
  filter(n > 1) %>%
  graph_from_data_frame()

AKKRON2_graph

set.seed(2017)
ggraph(AKKRON2_graph, layout = "fr") + 
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) + ggtitle("Analisis de red") + theme_clean()

wordcloud2(AKKRON %>% filter(n>2))
