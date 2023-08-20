import 'package:mysql_client/mysql_client.dart';

class Variables {
  // slip variables
  static int lastSerial = 0;
  static String lane = "",
      ticketNumber = "",
      vehicleNumber = "",
      vehicleClass = "",
      shift = "",
      amount = "",
      allowedWeight = "",
      dateTime = "";

  // database variables
  static bool connected = false;
  static String dbPort = "",
      dbHost = "",
      dbUsername = "",
      dbPassword = "",
      dbName = "",
      tableName = "",
      endDate = "";

  // user variables
  static String username = "cMsYnfqxQXr", password = "p44ZRJ2457";
}
