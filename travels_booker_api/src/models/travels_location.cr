class TravelsLocation < BaseModel
  table do
    # RELAÇÃO COM TRAVEL E LOCATION
    belongs_to location : Location # Relacionamento com a tabela de localização
    belongs_to travel : Travel # Relacionamento com a tabela de viagem
  end
end
