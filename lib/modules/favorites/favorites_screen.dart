import 'package:evencir_task/widgets/screen_header_text.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: ScreenHeaderText(text: "Favorites")

    );
  }
}
