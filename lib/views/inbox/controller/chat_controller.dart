import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController extends GetxController {
  late WebSocketChannel channel;

  final dio = Dio();
  final TextEditingController input = TextEditingController();

  RxList<InboxThread> threads = <InboxThread>[].obs;

  RxList<Message> messages = <Message>[].obs;

  void messagesHandler(Map<String, dynamic> message) async {
    // update threads
    await getThreads(updating: true);
    // update chatroom
    await getChatRoom(message["thread_id"].toString(), updating: true);
    input.clear();
    update();
  }

  Future<void> blockChat(String id) async {
    try {
      final url = "$baseUrl/chat/block-thread/$id/";
      final token = Authenticator.instance.fetchToken();
      await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      await getThreads();
      await Fluttertoast.showToast(msg: "Chat blocked");
      Get.back();
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> unBlockChat(String id) async {
    try {
      final url = "$baseUrl/chat/unblock-thread/$id/";
      final token = Authenticator.instance.fetchToken();
      await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      await getThreads();
      await Fluttertoast.showToast(msg: "Chat unblocked");
      Get.back();
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getChatRoom(String id, {bool updating = false}) async {
    if (!updating) {
      messages.clear();
    }
    try {
      final url = "$baseUrl/chat/threads/$id";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      for (var message in res.data) {
        if (updating && messages.indexWhere((element) => element.id == message["id"]) == -1) {
          messages.add(Message.fromJson(message));
        } else if (!updating) {
          messages.add(Message.fromJson(message));
        }
      }
      // return messages;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getThreads({bool updating = false}) async {
    if (!updating) {
      threads.clear();
    }
    try {
      const url = "$baseUrl/chat/threads/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      for (var thread in res.data) {
        if (updating) {
          int index = 0;
          if (threads.isNotEmpty) {
            final val = threads.indexWhere((element) => element.id == thread["id"]);
            index = val == -1 ? 0 : val;
          }

          if (threads[index].message != thread["id"]) {
            threads[index] = InboxThread.fromJson(thread);
          }
        } else {
          threads.add(InboxThread.fromJson(thread));
        }
      }
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void connect() async {
    final token = Authenticator.instance.fetchToken();
    final url =
        Uri.parse("wss://o-mejor-oferta.herokuapp.com/chat/").replace(queryParameters: {"token": token["access"]});
    channel = WebSocketChannel.connect(url);
    channel.stream.listen((event) {
      messagesHandler(jsonDecode(event));
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    channel.sink.add(jsonEncode(message));
  }

  Future<void> close() async {
    await channel.sink.close();
  }

  @override
  void onInit() {
    connect();

    super.onInit();
  }

  @override
  void onClose() async {
    await close();
    super.onClose();
  }
}
