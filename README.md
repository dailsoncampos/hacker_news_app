# Tutorial de Instalação e Utilização da Aplicação utilizando Docker

## Pré-requisitos

- Docker instalado na sua máquina. Guia de instalação do Docker
- Docker Compose instalado. Guia de instalação do Docker Compose

## Passo 1: Clonar o Repositório

Primeiro, clone o repositório da aplicação:

```bash
git clone https://github.com/dailsoncampos/hacker_news_app.git
cd hacker_news_app
```

## Passo 2: Construir e Iniciar os Contêineres

`docker-compose up --build`

## Passo 3: Executar as Migrações do Banco de Dados

`docker-compose run web rails db:create db:migrate`

## Passo 4: Acessar a Aplicação

`http://localhost:3000`
