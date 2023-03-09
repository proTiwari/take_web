// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CityRecord> _$cityRecordSerializer = new _$CityRecordSerializer();

class _$CityRecordSerializer implements StructuredSerializer<CityRecord> {
  @override
  final Iterable<Type> types = const [CityRecord, _$CityRecord];
  @override
  final String wireName = 'CityRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, CityRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.advancemoney;
    if (value != null) {
      result
        ..add('advancemoney')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.amount;
    if (value != null) {
      result
        ..add('amount')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.areaofland;
    if (value != null) {
      result
        ..add('areaofland')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.city;
    if (value != null) {
      result
        ..add('city')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.foodservice;
    if (value != null) {
      result
        ..add('foodservice')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.mobilenumber;
    if (value != null) {
      result
        ..add('mobilenumber')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.numberoffloors;
    if (value != null) {
      result
        ..add('numberoffloors')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.numberofrooms;
    if (value != null) {
      result
        ..add('numberofrooms')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.pincode;
    if (value != null) {
      result
        ..add('pincode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.propertyname;
    if (value != null) {
      result
        ..add('propertyname')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.servicetype;
    if (value != null) {
      result
        ..add('servicetype')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.sharing;
    if (value != null) {
      result
        ..add('sharing')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.state;
    if (value != null) {
      result
        ..add('state')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.streetaddress;
    if (value != null) {
      result
        ..add('streetaddress')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.wantto;
    if (value != null) {
      result
        ..add('wantto')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.lon;
    if (value != null) {
      result
        ..add('lon')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.lat;
    if (value != null) {
      result
        ..add('lat')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.date;
    if (value != null) {
      result
        ..add('date')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.ownername;
    if (value != null) {
      result
        ..add('ownername')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.paymentduration;
    if (value != null) {
      result
        ..add('paymentduration')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.profileImage;
    if (value != null) {
      result
        ..add('profileImage')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.propertyId;
    if (value != null) {
      result
        ..add('propertyId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.propertyimage;
    if (value != null) {
      result
        ..add('propertyimage')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.whatsappnumber;
    if (value != null) {
      result
        ..add('whatsappnumber')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.uid;
    if (value != null) {
      result
        ..add('uid')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.areaoflandunit;
    if (value != null) {
      result
        ..add('areaoflandunit')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  CityRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CityRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'advancemoney':
          result.advancemoney = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'areaofland':
          result.areaofland = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'foodservice':
          result.foodservice = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mobilenumber':
          result.mobilenumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'numberoffloors':
          result.numberoffloors = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'numberofrooms':
          result.numberofrooms = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'pincode':
          result.pincode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'propertyname':
          result.propertyname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'servicetype':
          result.servicetype = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'sharing':
          result.sharing = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'state':
          result.state = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'streetaddress':
          result.streetaddress = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'wantto':
          result.wantto = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'lon':
          result.lon = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'lat':
          result.lat = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'ownername':
          result.ownername = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'paymentduration':
          result.paymentduration = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'profileImage':
          result.profileImage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'propertyId':
          result.propertyId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'propertyimage':
          result.propertyimage.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'whatsappnumber':
          result.whatsappnumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'areaoflandunit':
          result.areaoflandunit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$CityRecord extends CityRecord {
  @override
  final String? advancemoney;
  @override
  final String? amount;
  @override
  final String? selleramount;
  @override
  final String? areaofland;
  @override
  final String? city;
  @override
  final String? description;
  @override
  final String? email;
  @override
  final String? foodservice;
  @override
  final String? mobilenumber;
  @override
  final String? numberoffloors;
  @override
  final String? numberofrooms;
  @override
  final String? pincode;
  @override
  final String? propertyname;
  @override
  final String? servicetype;
  @override
  final String? sharing;
  @override
  final String? state;
  @override
  final String? streetaddress;
  @override
  final String? wantto;
  @override
  final double? lon;
  @override
  final double? lat;
  @override
  final DateTime? date;
  @override
  final String? ownername;
  @override
  final String? paymentduration;
  @override
  final String? profileImage;
  @override
  final String? propertyId;
  @override
  final BuiltList<String>? propertyimage;
  @override
  final String? whatsappnumber;
  @override
  final String? uid;
  @override
  final String? areaoflandunit;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$CityRecord([void Function(CityRecordBuilder)? updates]) =>
      (new CityRecordBuilder()..update(updates))._build();

  _$CityRecord._(
      {this.advancemoney,
      this.amount,
      this.areaofland,
      this.selleramount,
      this.city,
      this.description,
      this.email,
      this.foodservice,
      this.mobilenumber,
      this.numberoffloors,
      this.numberofrooms,
      this.pincode,
      this.propertyname,
      this.servicetype,
      this.sharing,
      this.state,
      this.streetaddress,
      this.wantto,
      this.lon,
      this.lat,
      this.date,
      this.ownername,
      this.paymentduration,
      this.profileImage,
      this.propertyId,
      this.propertyimage,
      this.whatsappnumber,
      this.uid,
      this.areaoflandunit,
      this.ffRef})
      : super._();

  @override
  CityRecord rebuild(void Function(CityRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CityRecordBuilder toBuilder() => new CityRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CityRecord &&
        advancemoney == other.advancemoney &&
        amount == other.amount &&
        areaofland == other.areaofland &&
        city == other.city &&
        description == other.description &&
        email == other.email &&
        foodservice == other.foodservice &&
        mobilenumber == other.mobilenumber &&
        numberoffloors == other.numberoffloors &&
        numberofrooms == other.numberofrooms &&
        pincode == other.pincode &&
        propertyname == other.propertyname &&
        servicetype == other.servicetype &&
        sharing == other.sharing &&
        state == other.state &&
        streetaddress == other.streetaddress &&
        wantto == other.wantto &&
        lon == other.lon &&
        lat == other.lat &&
        date == other.date &&
        ownername == other.ownername &&
        paymentduration == other.paymentduration &&
        profileImage == other.profileImage &&
        propertyId == other.propertyId &&
        propertyimage == other.propertyimage &&
        whatsappnumber == other.whatsappnumber &&
        uid == other.uid &&
        areaoflandunit == other.areaoflandunit &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc(0, advancemoney.hashCode), amount.hashCode), areaofland.hashCode), city.hashCode), description.hashCode), email.hashCode), foodservice.hashCode), mobilenumber.hashCode), numberoffloors.hashCode), numberofrooms.hashCode),
                                                                                pincode.hashCode),
                                                                            propertyname.hashCode),
                                                                        servicetype.hashCode),
                                                                    sharing.hashCode),
                                                                state.hashCode),
                                                            streetaddress.hashCode),
                                                        wantto.hashCode),
                                                    lon.hashCode),
                                                lat.hashCode),
                                            date.hashCode),
                                        ownername.hashCode),
                                    paymentduration.hashCode),
                                profileImage.hashCode),
                            propertyId.hashCode),
                        propertyimage.hashCode),
                    whatsappnumber.hashCode),
                uid.hashCode),
            areaoflandunit.hashCode),
        ffRef.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CityRecord')
          ..add('advancemoney', advancemoney)
          ..add('amount', amount)
          ..add('areaofland', areaofland)
          ..add('city', city)
          ..add('description', description)
          ..add('email', email)
          ..add('foodservice', foodservice)
          ..add('mobilenumber', mobilenumber)
          ..add('numberoffloors', numberoffloors)
          ..add('numberofrooms', numberofrooms)
          ..add('pincode', pincode)
          ..add('propertyname', propertyname)
          ..add('servicetype', servicetype)
          ..add('sharing', sharing)
          ..add('state', state)
          ..add('streetaddress', streetaddress)
          ..add('wantto', wantto)
          ..add('lon', lon)
          ..add('lat', lat)
          ..add('date', date)
          ..add('ownername', ownername)
          ..add('paymentduration', paymentduration)
          ..add('profileImage', profileImage)
          ..add('propertyId', propertyId)
          ..add('propertyimage', propertyimage)
          ..add('whatsappnumber', whatsappnumber)
          ..add('uid', uid)
          ..add('areaoflandunit', areaoflandunit)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class CityRecordBuilder implements Builder<CityRecord, CityRecordBuilder> {
  _$CityRecord? _$v;

  String? _advancemoney;
  String? get advancemoney => _$this._advancemoney;
  set advancemoney(String? advancemoney) => _$this._advancemoney = advancemoney;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _selleramount;
  String? get selleramount => _$this._selleramount;
  set selleramount(String? selleramount) => _$this._selleramount = selleramount;

  String? _areaofland;
  String? get areaofland => _$this._areaofland;
  set areaofland(String? areaofland) => _$this._areaofland = areaofland;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _foodservice;
  String? get foodservice => _$this._foodservice;
  set foodservice(String? foodservice) => _$this._foodservice = foodservice;

  String? _mobilenumber;
  String? get mobilenumber => _$this._mobilenumber;
  set mobilenumber(String? mobilenumber) => _$this._mobilenumber = mobilenumber;

  String? _numberoffloors;
  String? get numberoffloors => _$this._numberoffloors;
  set numberoffloors(String? numberoffloors) =>
      _$this._numberoffloors = numberoffloors;

  String? _numberofrooms;
  String? get numberofrooms => _$this._numberofrooms;
  set numberofrooms(String? numberofrooms) =>
      _$this._numberofrooms = numberofrooms;

  String? _pincode;
  String? get pincode => _$this._pincode;
  set pincode(String? pincode) => _$this._pincode = pincode;

  String? _propertyname;
  String? get propertyname => _$this._propertyname;
  set propertyname(String? propertyname) => _$this._propertyname = propertyname;

  String? _servicetype;
  String? get servicetype => _$this._servicetype;
  set servicetype(String? servicetype) => _$this._servicetype = servicetype;

  String? _sharing;
  String? get sharing => _$this._sharing;
  set sharing(String? sharing) => _$this._sharing = sharing;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _streetaddress;
  String? get streetaddress => _$this._streetaddress;
  set streetaddress(String? streetaddress) =>
      _$this._streetaddress = streetaddress;

  String? _wantto;
  String? get wantto => _$this._wantto;
  set wantto(String? wantto) => _$this._wantto = wantto;

  double? _lon;
  double? get lon => _$this._lon;
  set lon(double? lon) => _$this._lon = lon;

  double? _lat;
  double? get lat => _$this._lat;
  set lat(double? lat) => _$this._lat = lat;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  String? _ownername;
  String? get ownername => _$this._ownername;
  set ownername(String? ownername) => _$this._ownername = ownername;

  String? _paymentduration;
  String? get paymentduration => _$this._paymentduration;
  set paymentduration(String? paymentduration) =>
      _$this._paymentduration = paymentduration;

  String? _profileImage;
  String? get profileImage => _$this._profileImage;
  set profileImage(String? profileImage) => _$this._profileImage = profileImage;

  String? _propertyId;
  String? get propertyId => _$this._propertyId;
  set propertyId(String? propertyId) => _$this._propertyId = propertyId;

  ListBuilder<String>? _propertyimage;
  ListBuilder<String> get propertyimage =>
      _$this._propertyimage ??= new ListBuilder<String>();
  set propertyimage(ListBuilder<String>? propertyimage) =>
      _$this._propertyimage = propertyimage;

  String? _whatsappnumber;
  String? get whatsappnumber => _$this._whatsappnumber;
  set whatsappnumber(String? whatsappnumber) =>
      _$this._whatsappnumber = whatsappnumber;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _areaoflandunit;
  String? get areaoflandunit => _$this._areaoflandunit;
  set areaoflandunit(String? areaoflandunit) =>
      _$this._areaoflandunit = areaoflandunit;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  CityRecordBuilder() {
    CityRecord._initializeBuilder(this);
  }

  CityRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _advancemoney = $v.advancemoney;
      _amount = $v.amount;
      _selleramount = $v.selleramount;
      _areaofland = $v.areaofland;
      _city = $v.city;
      _description = $v.description;
      _email = $v.email;
      _foodservice = $v.foodservice;
      _mobilenumber = $v.mobilenumber;
      _numberoffloors = $v.numberoffloors;
      _numberofrooms = $v.numberofrooms;
      _pincode = $v.pincode;
      _propertyname = $v.propertyname;
      _servicetype = $v.servicetype;
      _sharing = $v.sharing;
      _state = $v.state;
      _streetaddress = $v.streetaddress;
      _wantto = $v.wantto;
      _lon = $v.lon;
      _lat = $v.lat;
      _date = $v.date;
      _ownername = $v.ownername;
      _paymentduration = $v.paymentduration;
      _profileImage = $v.profileImage;
      _propertyId = $v.propertyId;
      _propertyimage = $v.propertyimage?.toBuilder();
      _whatsappnumber = $v.whatsappnumber;
      _uid = $v.uid;
      _areaoflandunit = $v.areaoflandunit;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CityRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CityRecord;
  }

  @override
  void update(void Function(CityRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CityRecord build() => _build();

  _$CityRecord _build() {
    _$CityRecord _$result;
    try {
      _$result = _$v ??
          new _$CityRecord._(
              advancemoney: advancemoney,
              amount: amount,
              areaofland: areaofland,
              city: city,
              description: description,
              email: email,
              foodservice: foodservice,
              mobilenumber: mobilenumber,
              numberoffloors: numberoffloors,
              numberofrooms: numberofrooms,
              pincode: pincode,
              propertyname: propertyname,
              servicetype: servicetype,
              sharing: sharing,
              state: state,
              streetaddress: streetaddress,
              wantto: wantto,
              lon: lon,
              lat: lat,
              date: date,
              ownername: ownername,
              paymentduration: paymentduration,
              profileImage: profileImage,
              propertyId: propertyId,
              propertyimage: _propertyimage?.build(),
              whatsappnumber: whatsappnumber,
              uid: uid,
              areaoflandunit: areaoflandunit,
              ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'propertyimage';
        _propertyimage?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CityRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
