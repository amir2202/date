import 'dart:async';

import 'package:dating/intro.dart';
import 'package:dating/messaging/LocalNotifications.dart';
import 'package:dating/scheduler/Schedule.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'messaging/Firebase.dart';




void main() {

  runApp(Loading());
  Schedule.scheduleOnlinePing();
  LocalNotifications.initialise();
}