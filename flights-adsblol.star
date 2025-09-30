load("render.star", "render")
load("http.star", "http")
load("encoding/json.star", "json")

ADSBLOL_BASEURL = "https://api.adsb.lol"
ADSBLOL_LAT = 0
ADSBLOL_LNG = 0
ADSBLOL_RADIUS = 10

def main():
  request_aircraft = http.get(
    url = ADSBLOL_BASEURL + "/v2/closest/{}/{}/{}".format(ADSBLOL_LAT, ADSBLOL_LNG, ADSBLOL_RADIUS)
  )
  flight = request_aircraft.json()["ac"][0]["flight"].strip()
  aircraft = request_aircraft.json()["ac"][0]["t"]

  request_plane = http.post(
    url = ADSBLOL_BASEURL + "/api/0/routeset", 
    json_body = {"planes": [{"callsign": flight, "lat": request_aircraft.json()["ac"][0]["lat"], "lng": request_aircraft.json()["ac"][0]["lon"]}]}
  )
  origin = request_plane.json()[0]["_airports"][-2]["iata"]
  destination = request_plane.json()[0]["_airports"][-1]["iata"]

  return render.Root(
    child = render.Padding(
      pad = 2,
      child = render.WrappedText(content = "{}\n{}\n{}✈{}".format(flight, aircraft, origin, destination)),
    )
  )
