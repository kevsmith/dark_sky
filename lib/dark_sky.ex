defmodule DarkSky do
  @moduledoc """
  Documentation for DarkSky.
  """

  def forecast(lat, long) do
    url =
      Enum.join(
        [build_url("forecast", lat, long), "exclude=minutely,hourly,alerts,flags"],
        "?"
      )

    case :hackney.get(
           url,
           [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}],
           [],
           []
         ) do
      {:ok, 200, headers, ref} ->
        IO.puts("#{inspect(headers)}")
        {:ok, body} = :hackney.body(ref)

        body =
          case :proplists.get_value("Content-Encoding", headers, nil) do
            "gzip" ->
              :zlib.gunzip(body)

            _ ->
              body
          end

        Jason.decode(body)

      error ->
        error
    end
  end

  defp build_url(request_type) do
    Enum.join([base_url(), request_type, api_token()], "/")
  end

  defp build_url(request_type, lat, long) do
    Enum.join([build_url(request_type), build_location(lat, long)], "/")
  end

  defp build_location(lat, long), do: Enum.join([lat, long], ",")

  defp api_token() do
    Application.get_env(:dark_sky, :api_token, System.get_env("DARK_SKY_API_TOKEN"))
  end

  defp base_url() do
    Application.get_env(:dark_sky, :base_url, "https://api.darksky.net")
  end
end
