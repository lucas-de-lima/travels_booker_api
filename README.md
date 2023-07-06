# Multiverse Travels Booker API

A API Multiverse Travels Booker é uma API desenvolvida em Crystal com o framework Lucky, que permite planejar e reservar viagens interdimensionais no universo de Rick and Morty. Com recursos simples, como criação, obtenção, atualização e exclusão de planos de viagem, a API oferece uma interface intuitiva para explorar diferentes realidades. Desenvolvida com desempenho e confiabilidade em mente, a API Multiverse Travels Booker é a sua porta de entrada para aventuras emocionantes e descobertas em múltiplas dimensões. Prepare-se para uma jornada sem limites e divirta-se explorando novos mundos com a ajuda dessa poderosa ferramenta tecnológica!

* [Índice](#multiverse-travels-booker-api)
  * [Configuração do Ambiente](#configuração-do-ambiente)
  * [Iniciando](#iniciando)
  * [Diretórios](#diretórios)
  * [Endpoints](#endpoints)
  * [Lista de Tarefas](#lista-de-tarefas)

## Configuração do Ambiente
Para configurar o ambiente de desenvolvimento da API, você precisará ter o Docker e o Docker Compose instalados em sua máquina. Essas ferramentas facilitarão a criação e execução dos containers necessários para a aplicação.

## Iniciando
[Ir para o topo](#multiverse-travels-booker-api)
Clone o repositório:
```
git clone {chave ssh do repositório}
```
Entre na pasta:
```
cd {diretório do projeto após o clone}
```
Suba tudo com docker compose:
```
docker-compose up
```
Após esse comando, se você não usou a flag -d (docker-compose up -d), podera visualizar os logs das requisições aos endpoints

## Diretórios
[Ir para o topo](#iniciando)
O diretório principal, que contém todos os endpoints pode ser encontrado em:
```
travels_booker_api/src/actions/travel_plans/index.cr
```
As models estão em:
```
travels_booker_api/src/models
```
As migrations estão em:
```
travels_booker_api/db/migrations
```



## Endpoints 
[Ir para o topo](#diretórios)

***Utilidade*** -
  Na raiz do projeto existe um arquivo chamado `thunder-collection_Travels Booker.json`
  Ele contém todas as rotas suportadas por essa API, assim você não terá necessidade de criar as rotas manualmente. 
  Ele pode ser facilmente importado na sua extenção do VsCode, o `Thunder Client` basta importar esse aquivo na seção de `Collections`
<br>

A API Multiverse Travels Booker oferece uma variedade de endpoints para facilitar o planejamento de viagens no universo de Rick and Morty. Esses endpoints permitem aos usuários criar novos planos de viagem, obter uma visão geral de todos os planos existentes, acessar detalhes de planos específicos, atualizar planos existentes e excluir planos de viagem. 

***Query parameters***
  Essa API pode usar query parameters, que são os seguintes:
  - optimize (boolean - falso por padrão): Quando verdadeiro, o array de travel_stops é ordenado de maneira a otimizar a viagem.
  - expand (boolean - falso por padrão): Quando verdadeiro, o campo de travel_stops é um array de entidades com informações detalhadas sobre cada parada.
  Exemplo:
  ```json
  GET /travel-plans?optimize=false&expand=true
  ```
<br>

### POST /travel-plans

Este endpoint é utilizado para criar um novo plano de viagem com base nas paradas fornecidas.

<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans
```

Corpo da Requisição:
```json
{
  "travel_stops": [1, 2]
}
```
Resposta:

Em caso de sucesso, a resposta será um objeto contendo o id, e travel_stops com um array de inteiros referente aos stops fornecidos no body, e status 200:
```json
{
  "id": 1,
  "travel_stops": [1, 2]
}
```
</details>

<br>

### GET /travel-plans

Este endpoint retorna uma lista de todas as travels registadas no banco de dados, com status 200.
<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans
```

Resposta:

```json
[
  {
    "id": 1,
    "travel_stops": [1,2]
  },
  {
    "id": 2,
    "travel_stops": [3,4]
  }
]
```
</details>

<br>

### GET /travel-plans?expand=true

Este endpoint retorna uma lista de travels que se alteram em relação ao termo de busca "expand", com status 200.
<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans?expand=true
```
Em caso da requisição receber um parametro query /travel-plans?expand=true, a resposta sera um array com id, e travel_stops com os detalhes de cada stop fornecido no body:

Resposta:

```json
[
  {
    "id": 1,
    "travel_stops": [
      {
        "id": 1,
        "name": "Earth (C-137)",
        "dimension": "Dimension C-137",
        "type": "Planet"
      },
      {
        "id": 2,
        "name": "Abadango",
        "dimension": "unknown",
        "type": "Cluster"
      }
    ]
  },
  {
    "id": 2,
    "travel_stops": [
      {
        "id": 3,
        "name": "Citadel of Ricks",
        "dimension": "unknown",
        "type": "Space station"
      },
      {
        "id": 4,
        "name": "Worldender's lair",
        "dimension": "unknown",
        "type": "Planet"
      }
    ]
  }
]
```
</details>

<br>

### GET /travel-plans/{id}

Este endpoint retorna uma travel especifica buscando pelo id, com status 200.
<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans/1
```

Resposta:

```json
{
    "id": 1,
    "travel_stops": [1, 2]
}
```
</details>

<br>

### GET /travel-plans/{id}/?expand=true

Este endpoint é utilizado para buscar uma travel pelo {id} com o parametro de query "expand=true".

Em caso de sucesso, a resposta será o travel_stops com os detalhes de cada stop, com status 200.

<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans/1/?expand=true
```
Resposta:

```json
{
  "id": 1,
  "travel_stops": [
    {
      "id": 1,
      "name": "Earth (C-137)",
      "dimension": "Dimension C-137",
      "type": "Planet"
    },
    {
      "id": 2,
      "name": "Abadango",
      "dimension": "unknown",
      "type": "Cluster"
    }
  ]
}
```

</details>

<br>

### PUT /travel-plans/{id}

Este endpoint é utilizado para atualizar uma travel pelo {id}.

Em caso de sucesso, a resposta será uma travel com os travel_stops atualizados com as informações recebidas no corpo da requisição, com status 200.

<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans/1
```
Corpo da requisição:

```json
{
  "travel_stops": [5,6]
}
```
Resposta:

```json
{
  "id": 1,
  "travel_stops": [5,6]
}
```

</details>

<br>

### DELETE /travel-plans/{id}
Este endpoint remove uma travel do banco de dados com base no {id} fornecido:

Em caso de sucesso a resposta sera vazia, com status 204.

<details>
    <summary>Exemplo:</summary><br />

```
/travel-plans/1
```

Resposta:

```json

```
</details>

<br>

### Lista de Tarefas 

[Ir para o topo](#endpoints)

[Ir para o começo](#multiverse-travels-booker-api)
<br>

[ ] ***_query parameters_*** = *optimize* -
Ao receber esse parâmetro, a API deve retornar o array de `travel_stops` reordenado com o objetivo de minimizar o número de saltos interdimensionais e organizar as paradas de viagem passando das localizações menos populares para as mais populares. Para tanto, deve-se visitar todas as localizações de uma mesma dimensão antes de se pular para uma localização de outra dimensão.
<br>

[ ] ***Lançamentos de erros personalizados*** -
É possivel usar `begin` para tentar executar um bloco de código, e `raise` para levantar uma exeção no caso de algum erro acontecer no escopo do `begin`.
