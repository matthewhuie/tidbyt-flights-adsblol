load("render.star", "render")
load("http.star", "http")
load("encoding/json.star", "json")

ADSBLOL_BASEURL = "https://api.adsb.lol"
ADSBLOL_LAT = 0 
ADSBLOL_LNG = 0 
ADSBLOL_RADIUS = 10

def main():
  request_aircraft = http.get(ADSBLOL_BASEURL + "/v2/closest/{}/{}/{}".format(ADSBLOL_LAT, ADSBLOL_LNG, ADSBLOL_RADIUS))
  print(request_aircraft)
  flight = request_aircraft.json()["ac"][0]["flight"].strip()
  aircraft = request_aircraft.json()["ac"][0]["t"]

  plane = {"planes": [{"callsign": flight, "lat": request_aircraft.json()["ac"][0]["lat"], "lng": request_aircraft.json()["ac"][0]["lon"]}]}

  return render.Root(
    child = render.Padding(
      pad = 2,
      child = render.WrappedText(content = "%s\n%s" % (flight, aircraft)),
    )
  )
