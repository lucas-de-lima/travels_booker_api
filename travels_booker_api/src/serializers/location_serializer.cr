# ESSE SERIALIZER É USADO PARA SERIALIZAR OS DADOS DE UMA LOCALIZAÇÃO
class LocationSerializer < BaseSerializer
  # ATRIBUTOS QUE SERÃO RENDERIZADOS É ESPERADO UM PARAMETRO DO TIPO Location
  def initialize(@location : Location)
  end

  # MÉTODO QUE RENDERIZA OS DADOS DA LOCALIZAÇÃO FORMATADOS
  def render
    {
      id:        @location.original, # ID DA LOCALIZAÇÃO
      name:      @location.name, # NOME DA LOCALIZAÇÃO
      type:      @location.type, # TIPO DA LOCALIZAÇÃO
      dimension: @location.dimension, # DIMENSÃO DA LOCALIZAÇÃO
    }
  end
end
