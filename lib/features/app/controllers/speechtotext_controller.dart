import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice/common/widgets/loaders/loaders.dart';
import 'package:voice/data/repositories/post_repository.dart';
import 'package:voice/features/app/controllers/post_controller.dart';
import 'package:voice/utils/logging/logger.dart';

class SpeechToTextController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;
  final RxBool loading = false.obs;
  final RxString recognizedText = ''.obs;
  final RxDouble confidence = 0.0.obs;

  // Reference to PostController if needed
  final PostController postController = PostController.instance;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: (error) => print('Error: $error'),
    );
  }

  void _onSpeechStatus(String status) {
    print('Speech status: $status');
    if (status == 'notListening') {
      isListening.value = false;
    }
  }

  void getSpeechPostData() async {
    try {
      loading.value = true;

      final data = await PostRepository.instance.fetchSpeechPostData(
        recognizedText.value,
      );

      // Now you can use the data
      // Example: title, desc, location
      postController.title.text = data["title"];
      postController.desc.text = data["desc"];
      postController.location.value = data["location"];
      Navigator.pop(Get.context!);
    } catch (e) {
      // You can show a snackbar or error message here
      TLoggerHelper.error(e.toString());
      TLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong: $e",
      );
    } finally {
      loading.value = false;
    }
  }

  void startListening() async {
    if (recognizedText.value.trim() != "") {
      getSpeechPostData();
      return;
    }
    if (!isListening.value) {
      bool available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        isListening.value = true;
        recognizedText.value = '';
        confidence.value = 0.0;
        await _speech.listen(
          onResult: (result) {
            recognizedText.value = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              confidence.value = result.confidence;
            }
          },
        );
      }
    } else {
      isListening.value = false;
      _speech.stop();
    }
  }

  Color getConfidenceColor(double confidence) {
    if (confidence > 0.8) {
      return Colors.green;
    } else if (confidence > 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
