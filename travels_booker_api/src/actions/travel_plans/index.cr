require "json"
require "http/client"

# GET "/travel_plans/:id" AND GET "/travel_plans/:id?expand=true"
# ESSA CLASSE É RESPONSÁVEL POR RETORNAR UM REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES
class TravelPlans::Show < ApiAction
  get "/travel_plans/:id" do
    # PEGAMOS O PARAMETRO DE QUERY expand
    expand = params.from_query["expand"]?
    # SE O PARAMETRO FOR true, RETORNAMOS O REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES EXPANDIDAS (ou seja, com mais detalhes)
    if expand == "true"
      # PEGAMOS UM REGISTROS DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES (TravelQuery está em src/queries/travel_query.cr)
      travel = TravelQuery.find(id)
      # PEGAMOS O REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES EXPANDIDAS (TravelQuery está em src/queries/travel_query.cr)
      travelWithLocations = TravelQuery.preload_locations(travel)
      # RETORNAMOS O TravelExpandSerializer (TravelExpandSerializer está em src/serializers/travel_expand_serializer.cr)
      json TravelExpandSerializer.new(travelWithLocations)
    else
      # ENTRAMOS NO ELSE QUANDO O PARAMETRO expand FOR false OU NÃO EXISTIR (nesse caso, não expandimos as localizações)
      travel = TravelQuery.find(id)
      # PEGAMOS O REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES (TravelQuery está em src/queries/travel_query.cr)
      travelWithLocations = TravelQuery.preload_locations(travel)
      # RETORNAMOS O TravelNoExpandSerializer (TravelNoExpandSerializer está em src/serializers/travel_no_expand_serializer.cr)
      json TravelNoExpandSerializer.new(travelWithLocations)
    end
  end
end

# DELETE "/travel_plans/:id"
# ESSA CLASSE É RESPONSÁVEL POR DELETAR UM REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES
class TravelPlans::Delete < ApiAction
  delete "/travel_plans/:id" do
    # PEGAMOS O REGISTRO DE TRAVEL (TravelQuery está em src/queries/travel_query.cr)
    travel = TravelQuery.find(id)
    # DELETAMOS O REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES (DeleteTravel está em src/operators/delete_travel.cr)
    DeleteTravel.delete!(travel)
    # RETORNAMOS O STATUS 204 (NO CONTENT)
    head 204
  end
end

# GET "/travel_plans" AND GET "/travel_plans?expand=true"
# ESSA CLASSE É RESPONSÁVEL POR RETORNAR TODOS OS REGISTROS DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES
class TravelPlans::Index < ApiAction
  get "/travel_plans" do
    # PEGAMOS O PARAMETRO DE QUERY expand
    expand = params.from_query["expand"]?
    # SE O PARAMETRO FOR true, RETORNAMOS OS REGISTROS DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES EXPANDIDAS (ou seja, com mais detalhes)
    if expand == "true"
      # PEGAMOS TODOS OS REGISTROS DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES (TravelQuery está em src/queries/travel_query.cr)
      # TravelQuery.new.preload_locations(LocationQuery.new) retorna um array de TravelWithLocations (LocationQuery está em src/queries/location_query.cr)
      travelsLocations = TravelQuery.new.preload_locations(LocationQuery.new)
      # RETORNAMOS O ARRAY DE TravelExpandSerializer (TravelExpandSerializer está em src/serializers/travel_expand_serializer.cr)
      json TravelExpandSerializer.for_collection(travelsLocations)
    else
      # ENTRAMOS NO ELSE QUANDO O PARAMETRO expand FOR false OU NÃO EXISTIR (nesse caso, não expandimos as localizações)
      # PEGAMOS TODOS OS REGISTROS DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES (TravelQuery está em src/queries/travel_query.cr)
      travelsLocations = TravelQuery.new.preload_locations(LocationQuery.new)
      # RETORNAMOS O ARRAY DE TravelNoExpandSerializer (TravelNoExpandSerializer está em src/serializers/travel_no_expand_serializer.cr)
      json TravelNoExpandSerializer.for_collection(travelsLocations)
    end
  end
end

# PUT "/travel_plans/:id"
# ESSA CLASSE É RESPONSÁVEL POR ATUALIZAR UM REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES RECEBIDAS NO BODY DA REQUISIÇÃO (travel_stops)
class TravelPlans::Update < ApiAction
  put "/travel_plans/:id" do
    # CAPTURAMOS O BODY DA REQUISIÇÃO
    body = params.from_json["travel_stops"]
    # PEGAMOS O REGISTRO DE TRAVEL (TravelQuery está em src/queries/travel_query.cr)
    travel = TravelQuery.find(id)
    # DELETAMOS TODAS AS LOCALIZAÇÕES DO REGISTRO DE TRAVEL
    AppDatabase.exec("
        DELETE FROM travels_locations WHERE travel_id = $1
        ", args: [travel.id])
    # PEGAMOS OS TRAVEL_STOPS DO BODY DA REQUISIÇÃO QUE SÃO OS IDS DAS LOCALIZAÇÕES E CONVERTEMOS PARA UM ARRAY DE INTEIROS
    travel_stops = Array(Int32).from_json(body.to_s)
    # FAZEMOS UM EACH NO ARRAY DE INTEIROS E PEGAMOS O ID DE CADA LOCALIZAÇÃO
    travel_stops.each do |id|
      # FAZEMOS UMA REQUISIÇÃO PARA A API DO RICK AND MORTY PARA PEGAR OS RESIDENTES DE CADA LOCALIZAÇÃO
      response = HTTP::Client.get "https://rickandmortyapi.com/api/location/#{id}"
      # PEGAMOS O BODY DA REQUISIÇÃO E CONVERTEMOS PARA JSON
      parse = JSON.parse(response.body)
      # PEGAMOS OS RESIDENTES DE CADA LOCALIZAÇÃO E CONVERTEMOS PARA UM ARRAY DE STRING
      residents = Array(String).from_json(parse["residents"].to_s)
      # PEGAMOS O TAMANHO DO ARRAY DE RESIDENTES E ATRIBUIMOS PARA A VARIÁVEL residents_size (residents_size É O NÚMERO DE RESIDENTES DE CADA LOCALIZAÇÃO)
      residents_size = residents.size
      # CRIAMOS UM NOVO REGISTRO DE LOCATION (SaveLocation está em src/models/save_location.cr)
      modelLocation = SaveLocation.upsert!(name: parse["name"].to_s, original: id,
        dimension: parse["dimension"].to_s, type: parse["type"].to_s, residents: residents_size)
      # NO FUTURO É POSSIVEL MUDAR PARA O UPSERT! RECEBER OS CAMPOS FORMATADOS A PARTIR DE UM SERIALIZER? (AINDA NÃO TESTEI)

      # CRIAMOS UM NOVO REGISTRO DE TRAVEL_LOCATION (TravelLocation está em src/models/travel_location.cr)
      AppDatabase.exec("
        INSERT INTO travels_locations (travel_id, location_id) VALUES ($1, $2)
        ", args: [travel.id, modelLocation.id])
    end
    # RETORNAMOS O ID DO REGISTRO DE TRAVEL E O ARRAY DE TRAVEL_STOPS ATUALIZADOS
    json({"id": travel.id, "travel_stops": travel_stops})
  end
end

# POST "/travel_plans"
# ESSA CLASSE É RESPONSÁVEL POR CRIAR UM NOVO REGISTRO DE TRAVEL COM SUAS RESPECTIVAS LOCALIZAÇÕES
class TravelPlans::Post < ApiAction
  post "/travel_plans" do
    # CAPTURAMOS O BODY DA REQUISIÇÃO
    body = params.from_json["travel_stops"]
    # CONVERTEMOS O BODY PARA ARRAY DE INTEIROS
    travel_stops = Array(Int32).from_json(body.to_s)
    # CRIAMOS UM NOVO REGISTRO DE TRAVEL (SaveTravel está em src/operations/save_travel.cr)
    travel = SaveTravel.create!(created_at: Time.utc)

    # PARA CADA ID DE LOCALIZAÇÃO, FAZEMOS UMA REQUISIÇÃO PARA A API DO RICK AND MORTY
    travel_stops.each do |id|
      # FAZEMOS A REQUISIÇÃO PARA A API
      response = HTTP::Client.get "https://rickandmortyapi.com/api/location/#{id}"
      # PEGAMOS O BODY DA REQUISIÇÃO E CONVERTEMOS PARA JSON
      parse = JSON.parse(response.body)
      # PEGAMOS O ARRAY DE RESIDENTES E CONVERTEMOS PARA ARRAY DE STRING
      residents = Array(String).from_json(parse["residents"].to_s)
      # PEGAMOS O TAMANHO DO ARRAY DE RESIDENTES
      location = residents.size
      # CRIAMOS UM NOVO REGISTRO DE LOCALIZAÇÃO (SaveLocation está em src/operations/save_location.cr)
      setLocation = SaveLocation.upsert!(name: parse["name"].to_s, dimension: parse["dimension"].to_s, type: parse["type"].to_s, residents: location, original: id)
      # NO FUTURO É POSSIVEL MUDAR PARA O UPSERT! RECEBER OS CAMPOS FORMATADOS A PARTIR DE UM SERIALIZER? (AINDA NÃO TESTEI)

      # CRIAMOS UM NOVO REGISTRO DE TRAVELS_LOCATIONS
      AppDatabase.exec("
        INSERT INTO travels_locations (travel_id, location_id) VALUES ($1, $2)
        ", args: [travel.id, setLocation.id])
    end

    # RETORNAMOS O ID DO REGISTRO DE TRAVEL E O ARRAY DE TRAVEL_STOPS
    json({
      id: travel.id,
      travel_stops: travel_stops
    })
  end
end
