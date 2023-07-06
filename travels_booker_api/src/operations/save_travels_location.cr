class SaveTravelsLocation < TravelsLocation::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  # permit_columns location : Int64, travel : Int64
end
