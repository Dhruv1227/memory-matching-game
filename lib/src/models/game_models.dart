part of '../app.dart';

enum Difficulty {
  easy('Easy', 6, Icons.spa_rounded),
  medium('Medium', 8, Icons.auto_awesome_rounded),
  hard('Hard', 10, Icons.local_fire_department_rounded);

  const Difficulty(this.label, this.pairs, this.icon);

  final String label;
  final int pairs;
  final IconData icon;
}

enum CardThemeChoice {
  classic('Classic', Icons.collections_rounded),
  space('Space', Icons.rocket_launch_rounded),
  nature('Nature', Icons.park_rounded),
  cafe('Cafe', Icons.restaurant_rounded);

  const CardThemeChoice(this.label, this.icon);

  final String label;
  final IconData icon;

  List<CardVisual> get visuals {
    switch (this) {
      case CardThemeChoice.classic:
        return const [
          CardVisual(
            id: 0,
            label: 'Anchor',
            asset: 'assets/images/anchor.png',
            icon: Icons.anchor_rounded,
            color: Color(0xFF246A73),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 1,
            label: 'Bolt',
            asset: 'assets/images/bolt.png',
            icon: Icons.flash_on_rounded,
            color: Color(0xFFE96B56),
            accent: Color(0xFF246A73),
          ),
          CardVisual(
            id: 2,
            label: 'Camera',
            asset: 'assets/images/camera.png',
            icon: Icons.camera_alt_rounded,
            color: Color(0xFF2E5EAA),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 3,
            label: 'Compass',
            asset: 'assets/images/compass.png',
            icon: Icons.explore_rounded,
            color: Color(0xFF6D5BD0),
            accent: Color(0xFFE96B56),
          ),
          CardVisual(
            id: 4,
            label: 'Leaf',
            asset: 'assets/images/leaf.png',
            icon: Icons.eco_rounded,
            color: Color(0xFF2C7A4B),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 5,
            label: 'Moon',
            asset: 'assets/images/moon.png',
            icon: Icons.brightness_3_rounded,
            color: Color(0xFF394A7A),
            accent: Color(0xFFEDE7D2),
          ),
          CardVisual(
            id: 6,
            label: 'Rocket',
            asset: 'assets/images/rocket.png',
            icon: Icons.rocket_launch_rounded,
            color: Color(0xFFC75042),
            accent: Color(0xFF246A73),
          ),
          CardVisual(
            id: 7,
            label: 'Star',
            asset: 'assets/images/star.png',
            icon: Icons.star_rounded,
            color: Color(0xFFE0A928),
            accent: Color(0xFF394A7A),
          ),
          CardVisual(
            id: 8,
            label: 'Sun',
            asset: 'assets/images/sun.png',
            icon: Icons.wb_sunny_rounded,
            color: Color(0xFFDD7A35),
            accent: Color(0xFF246A73),
          ),
          CardVisual(
            id: 9,
            label: 'Wave',
            asset: 'assets/images/wave.png',
            icon: Icons.waves_rounded,
            color: Color(0xFF167C80),
            accent: Color(0xFFF0B84C),
          ),
        ];
      case CardThemeChoice.space:
        return const [
          CardVisual(
            id: 0,
            label: 'Rocket',
            asset: 'assets/images/space_rocket.png',
            icon: Icons.rocket_launch_rounded,
            color: Color(0xFFC75042),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 1,
            label: 'Planet',
            asset: 'assets/images/space_planet.png',
            icon: Icons.public_rounded,
            color: Color(0xFF4169A8),
            accent: Color(0xFFE96B56),
          ),
          CardVisual(
            id: 2,
            label: 'Star',
            asset: 'assets/images/space_star.png',
            icon: Icons.star_rounded,
            color: Color(0xFFE0A928),
            accent: Color(0xFF394A7A),
          ),
          CardVisual(
            id: 3,
            label: 'Moon',
            asset: 'assets/images/space_moon.png',
            icon: Icons.brightness_3_rounded,
            color: Color(0xFF394A7A),
            accent: Color(0xFFEDE7D2),
          ),
          CardVisual(
            id: 4,
            label: 'Comet',
            asset: 'assets/images/space_comet.png',
            icon: Icons.auto_awesome_rounded,
            color: Color(0xFF6D5BD0),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 5,
            label: 'Signal',
            asset: 'assets/images/space_signal.png',
            icon: Icons.wifi_tethering_rounded,
            color: Color(0xFF247C92),
            accent: Color(0xFFE96B56),
          ),
          CardVisual(
            id: 6,
            label: 'Telescope',
            asset: 'assets/images/space_telescope.png',
            icon: Icons.travel_explore_rounded,
            color: Color(0xFF2D4F74),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 7,
            label: 'Flare',
            asset: 'assets/images/space_flare.png',
            icon: Icons.flare_rounded,
            color: Color(0xFFE77842),
            accent: Color(0xFF2D4F74),
          ),
          CardVisual(
            id: 8,
            label: 'Orbit',
            asset: 'assets/images/space_orbit.png',
            icon: Icons.all_inclusive_rounded,
            color: Color(0xFF7852A9),
            accent: Color(0xFFEDE7D2),
          ),
          CardVisual(
            id: 9,
            label: 'Capsule',
            asset: 'assets/images/space_capsule.png',
            icon: Icons.change_history_rounded,
            color: Color(0xFF0F6B5B),
            accent: Color(0xFFE96B56),
          ),
        ];
      case CardThemeChoice.nature:
        return const [
          CardVisual(
            id: 0,
            label: 'Leaf',
            asset: 'assets/images/nature_leaf.png',
            icon: Icons.eco_rounded,
            color: Color(0xFF2C7A4B),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 1,
            label: 'Flower',
            asset: 'assets/images/nature_flower.png',
            icon: Icons.local_florist_rounded,
            color: Color(0xFFC75A86),
            accent: Color(0xFF2C7A4B),
          ),
          CardVisual(
            id: 2,
            label: 'Tree',
            asset: 'assets/images/nature_tree.png',
            icon: Icons.park_rounded,
            color: Color(0xFF426B3A),
            accent: Color(0xFFE96B56),
          ),
          CardVisual(
            id: 3,
            label: 'Wave',
            asset: 'assets/images/nature_wave.png',
            icon: Icons.waves_rounded,
            color: Color(0xFF167C80),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 4,
            label: 'Mountain',
            asset: 'assets/images/nature_mountain.png',
            icon: Icons.terrain_rounded,
            color: Color(0xFF6D5D45),
            accent: Color(0xFF7EA6A1),
          ),
          CardVisual(
            id: 5,
            label: 'Rain',
            asset: 'assets/images/nature_rain.png',
            icon: Icons.water_drop_rounded,
            color: Color(0xFF2E75A8),
            accent: Color(0xFFEDE7D2),
          ),
          CardVisual(
            id: 6,
            label: 'Cloud',
            asset: 'assets/images/nature_cloud.png',
            icon: Icons.cloud_rounded,
            color: Color(0xFF5F7892),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 7,
            label: 'Sun',
            asset: 'assets/images/nature_sun.png',
            icon: Icons.wb_sunny_rounded,
            color: Color(0xFFDD7A35),
            accent: Color(0xFF426B3A),
          ),
          CardVisual(
            id: 8,
            label: 'Spa',
            asset: 'assets/images/nature_spa.png',
            icon: Icons.spa_rounded,
            color: Color(0xFF5F8E51),
            accent: Color(0xFFE96B56),
          ),
          CardVisual(
            id: 9,
            label: 'Bloom',
            asset: 'assets/images/nature_bloom.png',
            icon: Icons.filter_vintage_rounded,
            color: Color(0xFFB35A5A),
            accent: Color(0xFFF0B84C),
          ),
        ];
      case CardThemeChoice.cafe:
        return const [
          CardVisual(
            id: 0,
            label: 'Pizza',
            asset: 'assets/images/cafe_pizza.png',
            icon: Icons.local_pizza,
            color: Color(0xFFE96B56),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 1,
            label: 'Cake',
            asset: 'assets/images/cafe_cake.png',
            icon: Icons.cake,
            color: Color(0xFFC75A86),
            accent: Color(0xFFEDE7D2),
          ),
          CardVisual(
            id: 2,
            label: 'Coffee',
            asset: 'assets/images/cafe_coffee.png',
            icon: Icons.local_cafe,
            color: Color(0xFF6D5D45),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 3,
            label: 'Dinner',
            asset: 'assets/images/cafe_dinner.png',
            icon: Icons.restaurant,
            color: Color(0xFF0F6B5B),
            accent: Color(0xFFE96B56),
          ),
          CardVisual(
            id: 4,
            label: 'Snack',
            asset: 'assets/images/cafe_snack.png',
            icon: Icons.fastfood,
            color: Color(0xFFDD7A35),
            accent: Color(0xFF394A7A),
          ),
          CardVisual(
            id: 5,
            label: 'Drink',
            asset: 'assets/images/cafe_drink.png',
            icon: Icons.local_drink,
            color: Color(0xFF167C80),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 6,
            label: 'Plate',
            asset: 'assets/images/cafe_plate.png',
            icon: Icons.local_dining,
            color: Color(0xFF4169A8),
            accent: Color(0xFFEDE7D2),
          ),
          CardVisual(
            id: 7,
            label: 'Service',
            asset: 'assets/images/cafe_service.png',
            icon: Icons.room_service,
            color: Color(0xFF7852A9),
            accent: Color(0xFFF0B84C),
          ),
          CardVisual(
            id: 8,
            label: 'Breakfast',
            asset: 'assets/images/cafe_breakfast.png',
            icon: Icons.free_breakfast,
            color: Color(0xFFC75042),
            accent: Color(0xFF246A73),
          ),
          CardVisual(
            id: 9,
            label: 'Juice',
            asset: 'assets/images/cafe_juice.png',
            icon: Icons.local_bar,
            color: Color(0xFF2C7A4B),
            accent: Color(0xFFE96B56),
          ),
        ];
    }
  }
}

enum GameCue { tap, match, mismatch, win }

class CardVisual {
  const CardVisual({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.accent,
    this.asset,
  });

  final int id;
  final String label;
  final IconData icon;
  final Color color;
  final Color accent;
  final String? asset;
}

class GameCard {
  GameCard({
    required this.id,
    required this.visual,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  final int id;
  final CardVisual visual;
  bool isFaceUp;
  bool isMatched;
}

class ScoreRecord {
  const ScoreRecord({
    required this.difficulty,
    required this.theme,
    required this.score,
    required this.moves,
    required this.seconds,
    required this.rating,
  });

  final Difficulty difficulty;
  final CardThemeChoice theme;
  final int score;
  final int moves;
  final int seconds;
  final int rating;
}

class RoundResult {
  const RoundResult({
    required this.difficulty,
    required this.theme,
    required this.score,
    required this.moves,
    required this.seconds,
    required this.rating,
  });

  final Difficulty difficulty;
  final CardThemeChoice theme;
  final int score;
  final int moves;
  final int seconds;
  final int rating;
}

class ConfettiParticle {
  ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.spin,
    required this.drift,
  });

  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double spin;
  final double drift;
}
