import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'city_record.g.dart';

abstract class CityRecord implements Built<CityRecord, CityRecordBuilder> {
  static Serializer<CityRecord> get serializer => _$cityRecordSerializer;

  String? get advancemoney;

  String? get amount;

  String? get areaofland;

  String? get city;

  String? get description;

  String? get email;

  String? get foodservice;

  String? get mobilenumber;

  String? get numberoffloors;

  String? get numberofrooms;

  String? get pincode;

  String? get propertyname;

  String? get servicetype;

  String? get sharing;

  String? get state;

  String? get streetaddress;

  String? get wantto;

  double? get lon;

  double? get lat;

  DateTime? get date;

  String? get ownername;

  String? get paymentduration;

  String? get profileImage;

  String? get propertyId;

  BuiltList<String>? get propertyimage;

  String? get whatsappnumber;

  String? get uid;

  String? get areaoflandunit;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(CityRecordBuilder builder) => builder
    ..advancemoney = ''
    ..amount = ''
    ..areaofland = ''
    ..city = ''
    ..description = ''
    ..email = ''
    ..foodservice = ''
    ..mobilenumber = ''
    ..numberoffloors = ''
    ..numberofrooms = ''
    ..pincode = ''
    ..propertyname = ''
    ..servicetype = ''
    ..sharing = ''
    ..state = ''
    ..streetaddress = ''
    ..wantto = ''
    ..lon = 0.0
    ..lat = 0.0
    ..ownername = ''
    ..paymentduration = ''
    ..profileImage = ''
    ..propertyId = ''
    ..propertyimage = ListBuilder()
    ..whatsappnumber = ''
    ..uid = ''
    ..areaoflandunit = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('City');

  static Stream<CityRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<CityRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  CityRecord._();
  factory CityRecord([void Function(CityRecordBuilder) updates]) = _$CityRecord;

  static CityRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createCityRecordData({
  String? advancemoney,
  String? amount,
  String? areaofland,
  String? city,
  String? description,
  String? email,
  String? foodservice,
  String? mobilenumber,
  String? numberoffloors,
  String? numberofrooms,
  String? pincode,
  String? propertyname,
  String? servicetype,
  String? sharing,
  String? state,
  String? streetaddress,
  String? wantto,
  double? lon,
  double? lat,
  DateTime? date,
  String? ownername,
  String? paymentduration,
  String? profileImage,
  String? propertyId,
  String? whatsappnumber,
  String? uid,
  String? areaoflandunit, 
  String? selleramont,
}) {
  final firestoreData = serializers.toFirestore(
    CityRecord.serializer,
    CityRecord(
      (c) => c
        ..advancemoney = advancemoney
        ..amount = amount
        ..selleramount = selleramont
        ..areaofland = areaofland
        ..city = city
        ..description = description
        ..email = email
        ..foodservice = foodservice
        ..mobilenumber = mobilenumber
        ..numberoffloors = numberoffloors
        ..numberofrooms = numberofrooms
        ..pincode = pincode
        ..propertyname = propertyname
        ..servicetype = servicetype
        ..sharing = sharing
        ..state = state
        ..streetaddress = streetaddress
        ..wantto = wantto
        ..lon = lon
        ..lat = lat
        ..date = date
        ..ownername = ownername
        ..paymentduration = paymentduration
        ..profileImage = profileImage
        ..propertyId = propertyId
        ..propertyimage = null
        ..whatsappnumber = whatsappnumber
        ..uid = uid
        ..areaoflandunit = areaoflandunit,
    ),
  );

  return firestoreData;
}
