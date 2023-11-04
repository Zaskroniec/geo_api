defmodule GEOExcerciseWeb.LocationController do
  use GEOExcerciseWeb, :controller

  alias GeoImporter.LocationQuery

  def show(conn, %{"ip_address" => ip_address} = _params) do
    location = LocationQuery.get_by_ip_address!(ip_address)

    render(conn, :show, location: location)
  end
end
