# instala pacotes
install.packages("tidyverse") 
install.packages("janitor")
install.packages("here")
install.packages("lubridate")
install.packages("dplyr")

# carrega pacotes
library(tidyverse)
library(janitor)
library(here)
library(lubridate)

# informa nomes das colunas
colnames(Divvy_Trips_2019_Q1)
colnames(Divvy_Trips_2020_Q1)

# renomeia colunas existentes, cria novas e seleciona as colunas que gostaria de manter
Divvy_Trips_2019_Q1_limpo <- Divvy_Trips_2019_Q1 %>%
  rename(
    ride_id = trip_id,
    started_at = start_time,
    ended_at = end_time,
    start_station_name = from_station_name,
    start_station_id = from_station_id,
    end_station_name = to_station_name,
    end_station_id = to_station_id,
    member_casual = usertype
  ) %>%
  select(
    ride_id, started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual
  )

# seleciona as colunas que gostaria de manter
Divvy_Trips_2020_Q1_limpo <- Divvy_Trips_2020_Q1 %>%
  select(
    ride_id, started_at, ended_at,
    start_station_name, start_station_id,
    end_station_name, end_station_id,
    member_casual
  )

# modifica o tipo de dado, nesse caso para caracter
Divvy_Trips_2019_Q1_limpo$ride_id <- as.character(Divvy_Trips_2019_Q1_limpo$ride_id)
Divvy_Trips_2020_Q1_limpo$ride_id <- as.character(Divvy_Trips_2020_Q1_limpo$ride_id)

# junta as tabelas em uma só
dados_unidos <- bind_rows(Divvy_Trips_2019_Q1_limpo, Divvy_Trips_2020_Q1_limpo)

# remove colunas e linhas vazias
dados_unidos <- remove_empty(dados_unidos,which = c("cols"))
dados_unidos <- remove_empty(dados_unidos,which = c("rows"))

# converte string para formato data/hora
dados_unidos$started_at <- ymd_hms(dados_unidos$started_at)
dados_unidos$ended_at <- ymd_hms(dados_unidos$ended_at)

# cria uma nova coluna retornando o dia da semana da data informada
dados_unidos$day <- wday(dados_unidos$started_at)

# cria mais duas colunas informando apenas a hora do data/hora
dados_unidos$start_hour <- hour(dados_unidos$started_at)
dados_unidos$end_hour <- hour(dados_unidos$ended_at)

# cria uma coluna que mostra a duração da viagem
dados_unidos$ride_length <- difftime(dados_unidos$ended_at,dados_unidos$started_at)

# verifica quantas viagens com duração maior que 24 horas ou menor que 0 segundos existem
# na.rm = TRUE significa que ele vai ignorar células vazias pra não atrapalhar a contagem
sum(dados_unidos$ride_length <0, na.rm = TRUE)
sum(dados_unidos$ride_length >86400)

# cria uma nova tabela excluindo os valores negativos e acima de 86400 da tabela anterior
dados_atualizados <- dados_unidos[!(dados_unidos$ride_length<0 | dados_unidos$ride_length>86400),]

# substitui os dias da semana de números pra texto
dados_atualizados <- dados_atualizados %>%
  mutate(day = recode(day
                      ,"1" = "Sunday"
                      ,"2" = "Monday"
                      ,"3" = "Tuesday"
                      ,"4" = "Wednesday"
                      ,"5" = "Thursday"
                      ,"6" = "Friday"
                      ,"7" = "Saturday"))

# reordena a coluna day
dados_atualizados$day <- ordered(dados_atualizados$day, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))

# padroniza os tipos de membro e cria uma nova coluna
dados_atualizados <- dados_atualizados %>%
  mutate(member_category = case_when(
    member_casual %in% c("casual", "Customer") ~ "casual",
    member_casual %in% c("member", "Subscriber") ~ "member",
    TRUE ~ member_casual
  ))

# exclui a coluna antiga
dados_atualizados <- dados_atualizados %>%
  select(-member_casual)

# exclui usuarios que não sejam casual ou member
dados_atualizados <- dados_atualizados %>%
  filter(member_category %in% c("casual", "member"))

# adiciona nova coluna com a duração em minutos
dados_atualizados <- dados_atualizados %>%
  mutate(ride_length_min = as.numeric(ride_length) / 60)

# calcula média de duração por dia e por tipo de usuário
media_por_dia <- dados_atualizados %>%
  group_by(day, member_category) %>%
  summarise(media_duracao = mean(ride_length_min), .groups = "drop")

# exporta o arquivo em .csv
write.csv(dados_atualizados, here("dados_atualizados.csv"), row.names = FALSE)

####

# tabela com os dados e rótulo com quebras de linha
resumo_membros <- dados_atualizados %>%
  count(member_category) %>%
  mutate(
    porcentagem = n / sum(n) * 100,
    label = paste0(
      member_category, "\n",
      round(porcentagem, 1), "%\n",
      n, " viagens\n"  # <– essa linha extra aqui dá o espaço
    )
  )

# gráfico pizza com legenda
ggplot(resumo_membros, aes(x = "", y = n, fill = member_category)) +
  geom_bar(stat = "identity", width = 1, color = "white") + 
  coord_polar("y", start = 0) + 
  labs(title = "Usuários por Categoria", fill = NULL) +
  theme_void() +
  scale_fill_manual(
    values = c("casual" = "skyblue", "member" = "orange"),
    labels = resumo_membros$label
  ) +
  theme(
    legend.position = "right",
    legend.text = element_text(size = 12),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14)
  )

# gráfico de barras da duração média por dia
ggplot(media_por_dia, aes(x = day, y = media_duracao, fill = member_category)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_text(aes(label = round(media_duracao, 1)), 
            position = position_dodge(width = 0.9), 
            vjust = -0.3, size = 3.5) +
  labs(
    title = "Duração média das viagens por dia da semana",
    x = "Dia da semana",
    y = "Duração média (minutos)",
    fill = "Tipo de usuário"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "orange")) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# conta quantas viagens começam em cada hora, por tipo de usuário
viagens_por_hora <- dados_atualizados %>%
  group_by(start_hour, member_category) %>%
  summarise(total = n(), .groups = "drop")

# cria o gráfico
ggplot(viagens_por_hora, aes(x = start_hour, y = total, fill = member_category)) +
  geom_col(position = "dodge") +
  labs(
    title = "Número de viagens por hora do dia",
    x = "Hora de início da viagem",
    y = "Número de viagens",
    fill = "Tipo de usuário"
  ) +
  scale_fill_manual(values = c("casual" = "skyblue", "member" = "orange")) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
