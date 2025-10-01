load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
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
      child = render.Column(
        children = [
          render.Row(
            expanded = True,
            main_align = "space_between",
            children = [
              render.Text(
                content = flight,
                font = "CG-pixel-3x5-mono",
                color = "#EDC001"
              ),
              render.Text(
                content = aircraft, 
                font = "CG-pixel-3x5-mono"
              ),
            ]
          ),
          render.Box(
            render.Row(
              expanded = True,
              main_align = "space_around",
              cross_align = "center",
              children = [
                render.Text(
                  content = "{}".format(origin),
                  font = "6x13"
                ),
                render.Image(
                  src = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAVElEQVR4AYzMgQqAIAxF0fT//7k8UmOMFg0u6tv1zePnhHje0/0Lcawh8Z2VEC2WO5xv8qxhJ+9GckYrcrZFLRkScjY9hA9a3Gu+Gy3QSXYhfknECwAA//8MK+nbAAAABklEQVQDAIyaQA1voWxzAAAAAElFTkSuQmCC""")
                ),
                render.Text(
                  content = "{}".format(destination),
                  font = "6x13"
                ),
              ]
            )
          )
        ]
      )
    )
  )
