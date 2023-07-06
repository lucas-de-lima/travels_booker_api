# ESSE SERIALIZER SERVE PARA RETORNAR O ID DA LOCATION
class LocationIdSerializer < BaseSerializer
  # AQUI ESTOU INFORMANDO QUE O PARAMETRO ESPERADO É DO TIPO LOCATION
  def initialize(@location : Location)
  end
  # AQUI ESTOU RETORNANDO O ID DA LOCATION
  def render
    {
      id: @location.id, # ID DA LOCALIZAÇÃO
    }
  end
end
