import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';

class PasswordHashArgon2 {
  String generateRandomSalt([int length = 16]) {
    final random = Random.secure();
    final salt = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(salt);
  }

  String generateHashedPassword(String password, String salt) {
    var _salt = salt.toBytesLatin1();
    var parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      _salt,
      iterations: 2,
      memoryPowerOf2: 16,
    );

    var argon2 = Argon2BytesGenerator();
    argon2.init(parameters);
    var passwordBytes = parameters.converter.convert(password);
    var result = Uint8List(16);
    argon2.generateBytes(passwordBytes, result);
    var finalPassword = result.toHexString();

    return finalPassword;
  }

  bool verifyPassword(
      String password, String salt, String storedHashedPassword) {
    final hashPassword = generateHashedPassword(password, salt);
    return hashPassword == storedHashedPassword;
  }
}
