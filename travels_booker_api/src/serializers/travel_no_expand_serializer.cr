#ESSE SERIALIZER É USADO PARA RETORNAR APENAS O ID E AS LOCALIZAÇÕES DO TRAVEL QUANDO O ENDPOINT NÃO RECEBER O PARAMETRO EXPAND
class TravelNoExpandSerializer < BaseSerializer
  # É ESPERADO RECEBER UM PARAMETRO DO TIPO TRAVEL
  def initialize(@travel : Travel)
  end

  # RETORNA UM HASH COM O ID DO TRAVEL E UM ARRAY COM AS LOCALIZAÇÕES
  def render
    # CRIA UM ARRAY VAZIO DO TIPO INT64
    array = Array(Int64).new
    # PERCORRE TODAS AS LOCALIZAÇÕES DO TRAVEL E ADICIONA NO ARRAY
    @travel.locations.each do |locations|
      # ADICIONA O ID DA LOCALIZAÇÃO NO ARRAY DE INT64
      array << locations.original
    end
    {
      id:           @travel.id, # ID DO TRAVEL
      travel_stops: array, # ARRAY DE LOCALIZAÇÕES
    }
  end
end
