class BookingUserInfo {
  final String uid;
  final String name;
  final String contactNumber;
  final String photoUrl;
  BookingUserInfo(
    this.uid,
    this.name,
    this.contactNumber,
    this.photoUrl,
  );
}

class DriverUserInfo extends BookingUserInfo {
  final String zoneNumber;
  final String plateNumber;
  final String vehicleType;
  DriverUserInfo(
    super.uid,
    super.name,
    super.contactNumber,
    this.zoneNumber,
    this.plateNumber,
    this.vehicleType,
    super.photoUrl,
  );
}
