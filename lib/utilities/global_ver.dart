import 'package:flutter/widgets.dart';
import 'package:instergram_flutter/screeen/add_post.dart';
import 'package:instergram_flutter/screeen/feed_screen.dart';

const webScreenSize = 600;

List<Widget> screens = [
  const FeedScreen(),
  const Text("search"),
  const AddPostScreen(),
  const Text("Favourite"),
  const Text("Personal")
];
