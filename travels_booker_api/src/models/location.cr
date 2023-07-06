class Location < BaseModel
  table do
    column name : String
    column type : String
    column dimension : String
    column residents : Int32
    column original : Int32 # ESSE CAMPO NÃO EXISTE NO JSON QUE VEM DO BODY,
                            # MAS É NECESSÁRIO PARA RETORNAR O ID DA TRAVEL CORRETAMENTE EM (src/action/travel_plans/index.cr nas linhas 90 e 126)

    # RELAÇÃO COM TRAVEL E TRAVELS_LOCATION
    has_many travels_locations : TravelsLocation # Relação com a tabela de relacionamento
    has_many travels : Travel, [:travels_locations, :travel] # Relação com a tabela de Travel
  end
end
