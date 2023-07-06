# ESSE SERIALIZER É USADO PARA RETORNAR OS DADOS DE UMA VIAGEM
class TravelExpandSerializer < BaseSerializer
  # É ESPERADO QUE RECEBA UM PARAMETRO DO TIPO TRAVEL
  def initialize(@travel : Travel)
  end

  # RETORNA UM HASH COM OS DADOS DA VIAGEM E OS DADOS DE CADA LOCAL
  def render
    {
      id:           @travel.id, # ID DA VIAGEM
      # O LocationSerializer É USADO PARA RETORNAR OS DADOS DE CADA LOCAL (LocationSerializer está em src/serializers/location_serializer.cr)
      travel_stops: LocationSerializer.for_collection(@travel.locations), # DADOS DE CADA LOCAL DA VIAGEM
    }
  end
end
