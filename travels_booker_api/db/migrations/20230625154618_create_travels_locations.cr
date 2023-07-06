class CreateTravelsLocations::V20230625154618 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(TravelsLocation) do
      primary_key id : Int64
      add_belongs_to location : Location, on_delete: :cascade
      add_belongs_to travel : Travel, on_delete: :cascade
      add_timestamps
    end
  end

  def rollback
    drop table_for(TravelsLocation)
  end
end
