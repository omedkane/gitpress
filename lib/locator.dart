import 'package:get_it/get_it.dart';
import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/push_notifications.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<Talk2Users>(() => DbTalker("users"));
  locator.registerLazySingleton<Talk2Orders>(() => DbTalker("orders"));
  locator.registerLazySingleton<Talk2Lines>(() => DbTalker("orderline"));
  locator.registerLazySingleton<Talk2Clothes>(() => DbTalker("clothes"));
  locator.registerLazySingleton<ClotheCatalogue>(() => ClotheCatalogue());
  locator.registerLazySingleton<PhoneMaster>(() => PhoneMaster());
  locator.registerLazySingleton(() => PushNotificationService());
}
