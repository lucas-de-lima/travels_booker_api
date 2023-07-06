class Travel < BaseModel
  table do
    # RELAÇÃO COM LOCATIONS E TRAVELS_LOCATIONS
    has_many travels_locations : TravelsLocation # Relação com a tabela de relacionamento
    has_many locations : Location, [:travels_locations, :location] # Relação com a tabela de Location
  end
end
