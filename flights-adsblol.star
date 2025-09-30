load("render.star", "render")
load("http.star", "http")
load("encoding/json.star", "json")

ADSBLOL_URL = "https://api.adsb.lol"

def main():
  data_aircraft = http.get(ADSBLOL_URL + "/v2/closest/LAT/LNG/RADIUS")

  pretty_json = json.encode(data_aircraft.json())

  return render.Root(
    child = render.Padding(
      pad = 2,
      child = render.Text(content = pretty_json),
    )
  )
