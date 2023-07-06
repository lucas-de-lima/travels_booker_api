class CreateLocations::V20230625154502 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Location) do
      primary_key id : Int64
      add_timestamps
      add name : String
      add type : String
      add dimension : String
      add residents : Int32
      add original : Int32
    end
  end

  def rollback
    drop table_for(Location)
  end
end
