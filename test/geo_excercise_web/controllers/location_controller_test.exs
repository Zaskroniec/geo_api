defmodule GEOExcerciseWeb.LocationControllerTest do
  use GEOExcerciseWeb.ConnCase, async: true

  describe "show GET /locations/:ip_address" do
    test "returns geo location based on `ip_address` param", %{conn: conn} do
      %{
        ip_address: "127.0.0.1",
        country_code: "PL",
        country: "Poland",
        city: "Gdańsk",
        lon: "18.638306",
        lat: "54.372158",
        code: 32214
      }
      |> GeoImporter.Structs.Location.insert_changeset()
      |> GEOExcercise.Repo.insert!()

      conn = get(conn, ~p"/api/locations/127.0.0.1")

      assert response = json_response(conn, 200)

      assert %{
               "data" => %{
                 "city" => "Gdańsk",
                 "country" => "Poland",
                 "country_code" => "PL",
                 "ip_address" => "127.0.0.1",
                 "lat" => 54.372158,
                 "lon" => 18.638306
               }
             } = response
    end

    test "raises exception for given `ip_address`", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, ~p"/api/locations/127.0.0.1")
      end
    end

    test "raises exception for given invalid `ip_address`", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, ~p"/api/locations/dasd12")
      end
    end
  end
end
