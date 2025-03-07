import 'dart:math';

class Playground {
  final String name;
  final double latitude;
  final double longitude;

  Playground(this.name, this.latitude, this.longitude);
}

class NearbyPlayground extends Playground {
  final double distanceKm;

  NearbyPlayground(
      super.name, super.latitude, super.longitude, this.distanceKm);
}

class PlaygroundLocator {
  final List<Playground> playgrounds;

  PlaygroundLocator(this.playgrounds);

  List<NearbyPlayground> findPlaygroundsInRadius(
      double userLat, double userLon, double radiusKm) {
    List<NearbyPlayground> filteredPlaygrounds = playgrounds
        .map((playground) {
          double distance = _calculateDistance(
              userLat, userLon, playground.latitude, playground.longitude);
          return NearbyPlayground(playground.name, playground.latitude,
              playground.longitude, distance);
        })
        .where((playground) => playground.distanceKm <= radiusKm)
        .toList();

    filteredPlaygrounds.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return filteredPlaygrounds;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}

void main() {
  double userLat = 21.233908;
  double userLon = 72.884538;

  List<Playground> playgrounds = [
    Playground("Veer Narmad Garden", 21.141989, 72.774460),
    Playground("Jolly Party Plot", 21.226350, 72.894867),
    Playground("Athwa Playground", 21.178967, 72.831192),
    Playground("Dumas Beach Park", 21.099600, 72.701600),
    Playground("Surat City Gymkhana Ground", 21.178200, 72.772300),
    Playground("Gopi Talav Garden", 21.194400, 72.821900),
    Playground("Hazira Garden", 21.115300, 72.650300),
    Playground("Yogi Chowk Ground", 21.209600, 72.888600),
    Playground("Bharthana Garden", 21.225600, 72.831100),
    Playground("VR Mall Garden", 21.212220, 72.818970),
  ];

  PlaygroundLocator locator = PlaygroundLocator(playgrounds);
  double radiusKm = 4.0;

  List<NearbyPlayground> nearbyPlaygrounds =
      locator.findPlaygroundsInRadius(userLat, userLon, radiusKm);

  print("Playgrounds within ${radiusKm}km of your location:");
  for (var playground in nearbyPlaygrounds) {
    print(
        "${playground.name} - ${playground.distanceKm.toStringAsFixed(2)} km away");
  }
}
