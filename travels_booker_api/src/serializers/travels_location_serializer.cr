#ESSE SERIALIZER É USADO PARA MOSTRAR AS LOCALIZAÇÕES DE UMA VIAGEM
class TravelsLocationSerializer < BaseSerializer
  # ELE ESPERA RECEBER UM PARAMETRO DO TIPO TRAVELSLOCATION
  def initialize(@travels_locations : TravelsLocation)
  end

  # ELE RETORNA UM HASH COM OS DADOS DA LOCALIZAÇÃO
  def render
    {
      id:           @travels_locations.id, #ID DA LOCALIZAÇÃO
      travel_stops: {
        @travels_locations.location_id, @travels_locations.travel_id, #ID DA LOCALIZAÇÃO E DA VIAGEM SEPARADOS POR VIRGULA (ISSO CRIA UM ARRAY DE 2 POSIÇÕES)
      },
    }
  end
end
