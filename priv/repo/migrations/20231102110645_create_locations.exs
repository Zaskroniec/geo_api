defmodule GEOExcercise.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table("locations") do
      add :ip_address, :inet, null: false
      add :country_code, :string, size: 2, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :lon, :decimal, null: false, precision: 15, scale: 12
      add :lat, :decimal, null: false, precision: 15, scale: 13
      add :code, :bigint, null: false

      timestamps()
    end

    create unique_index(:locations, :ip_address)
  end
end
