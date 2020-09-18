import 'dart:convert' show jsonEncode;

import 'package:fans/cloudbase/function/FunctionMockHttp.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' show Position;

class CreateMomentCommandVideoItemController {
  final String cover;
  final String src;

  const CreateMomentCommandVideoItemController(this.cover, this.src);

  Map<String, String> toData() {
    return {
      'src': src,
      'cover': cover,
    };
  }
}

class CreateMomentCommandAudioItemController
    extends CreateMomentCommandVideoItemController {
  CreateMomentCommandAudioItemController(String src, [String cover])
      : super(cover, src);

  @override
  Map<String, String> toData() {
    Map<String, String> data = {'src': src};
    if (cover is String && cover.isNotEmpty) {
      data['cover'] = cover;
    }

    return data;
  }
}

class CreateMomentCommandController {
  final String text;
  final Iterable<String> images;
  final CreateMomentCommandAudioItemController audio;
  final CreateMomentCommandVideoItemController video;
  final Iterable<String> vote;
  final Position location;

  const CreateMomentCommandController({
    @required this.text,
    this.images,
    this.audio,
    this.video,
    this.vote,
    this.location,
  });

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {'text': text};

    if (audio is CreateMomentCommandAudioItemController) {
      data['audio'] = audio.toData();
    } else if (video is CreateMomentCommandVideoItemController) {
      data['video'] = video.toData();
    } else if (images is Iterable<String> && images.isNotEmpty) {
      data['images'] = images.toList();
    }

    if (vote is Iterable<String> && vote.isNotEmpty) {
      data['vote'] = vote.toList();
    }

    if (location is Position) {
      data['location'] = {
        'longitude': location.longitude,
        'latitude': location.latitude,
      };
    }

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toData());
  }
}

class CreateMomentCommand {
  final CreateMomentCommandController controller;

  const CreateMomentCommand(this.controller);

  Future<String> send() async {
    final http = FunctionMockHttp(
      method: 'post',
      path: '/moments',
      body: controller.toString(),
      headers: {'Content-Type': 'application/json'},
    );
    final response = await http.send();
    final result = response.toJsonDecode();
    if (response.statusCode == 201) {
      return result['id'];
    }
    throw UnimplementedError(result['message']);
  }
}
