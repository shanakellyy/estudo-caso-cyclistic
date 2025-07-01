# 🚲 Estudo de Caso - Cyclistic

Este repositório contém um **Estudo de Caso**, no qual analisei os dados da empresa fictícia **Cyclistic**, um sistema de compartilhamento de bicicletas em Chicago. O objetivo principal foi identificar **diferenças de comportamento entre usuários casuais e membros anuais** e propor estratégias de marketing baseadas em dados, para **converter usuários casuais em assinantes**.

---

## 📌 Objetivo

O foco deste estudo é transformar dados brutos em **insights acionáveis**, respondendo à pergunta de negócios:

> **Como podemos converter usuários casuais da Cyclistic em membros anuais?**

---

## 🔍 Etapas da Análise

Este projeto segue as etapas do processo de análise de dados orientado pelo Google:

1. **Perguntar** — Definição clara do problema de negócios.  
2. **Preparar** — Obtenção e compreensão dos dados.  
3. **Processar** — Limpeza, tratamento e estruturação dos dados.  
4. **Analisar** — Exploração e visualização para extração de insights.  
5. **Compartilhar** — Comunicação dos resultados.  
6. **Agir** — Recomendações baseadas nos dados.

---

## 🗂️ Sobre os Dados

- Os dados foram disponibilizados pela **Motivate International Inc.**
- Contêm registros de viagens dos **1º trimestres de 2019 e 2020**.
- As colunas incluem: ID da viagem, horários, estações, tipo de usuário, entre outros.

---

## 🛠️ Ferramentas Utilizadas

- **R** e **RStudio** para análise de dados e visualizações  
- Pacotes principais:
  - `tidyverse`
  - `lubridate`
  - `janitor`
  - `here`

---

## 🧹 Limpeza e Transformação

- Padronização dos nomes das colunas entre os dois datasets.  
- Remoção de linhas e colunas vazias.  
- Conversão de formatos de data e hora.  
- Cálculo da duração da viagem.  
- Tratamento de dados inválidos (ex: viagens negativas ou > 24h).  
- Criação de colunas auxiliares: dia da semana, hora de início/fim da viagem.

---

## 📊 Principais Análises

- Duração média das viagens por tipo de usuário  
- Dias da semana com maior número de viagens  
- Padrões de horário de uso  
- Comportamento geral comparando usuários casuais x membros

![Gráfico: Duração média das viagens por dia da semana](/imagens/Rplot01.png)

---

## 📈 Resultados e Recomendações

As análises mostraram diferenças claras nos padrões de uso. Com base nesses insights, foram feitas recomendações para campanhas de marketing mais direcionadas. O relatório final foi desenvolvido com foco na visualização clara dos dados e na tomada de decisão.

---

## 🔗 Saiba Mais

Você pode conferir a versão completa deste estudo, com mais análises e visualizações, no meu perfil do Medium. Caso tenha interesse em acompanhar meu trabalho ou entrar em contato profissionalmente, também estou disponível no LinkedIn:

- 📖 [Leia o artigo completo no Medium](https://medium.com/@rshanakelly/estudo-de-caso-como-um-sistema-de-compartilhamento-de-bicicletas-lida-com-o-sucesso-acelerado-9bd9e62260d2)  
- 💼 [Visite meu perfil no LinkedIn](https://www.linkedin.com/in/shanakellydelima/)
