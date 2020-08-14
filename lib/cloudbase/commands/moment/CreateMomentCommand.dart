import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:snsmax/cloudbase/commands/ClientApiFunctionCommand.dart';

import '../../../cloudbase.dart';

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
}

class CreateMomentCommand extends ClientApiFunctionCommand<bool> {
  CreateMomentCommand(CreateMomentCommandController controller)
      : super(controller.toData());

  @override
  String get commandName => 'moment:create';

  @override
  bool deserializer(data, CloudBaseResponse response) {
    if (data == true) {
      return true;
    }

    throw UnimplementedError(response.message ?? '发布失败');
  }
}
