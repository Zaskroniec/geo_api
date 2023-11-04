defmodule GEOExcerciseWeb.LocationJSON do
  def show(%{location: location}) do
    %{data: data(location)}
  end

  defp data(location) do
    location
    |> Map.take([:city, :country, :country_code])
    |> Map.put(:ip_address, put_ip_address(location))
    |> Map.merge(get_coordinates(location))
  end

  defp put_ip_address(%{ip_address: %{address: address}}) do
    address
    |> Tuple.to_list()
    |> Enum.join(".")
  end

  defp get_coordinates(%{lat: lat, lon: lon}) do
    %{
      lat: Decimal.to_float(lat),
      lon: Decimal.to_float(lon)
    }
  end
end
