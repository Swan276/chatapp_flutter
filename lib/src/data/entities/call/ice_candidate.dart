import 'dart:convert';

import 'package:chatapp_ui/src/data/entities/call/rtc_ice_candidate_mapper.dart';

class IceCandidate {
  final String participantId;
  final RtcIceCandidateMapper iceCandidate;

  IceCandidate({
    required this.participantId,
    required this.iceCandidate,
  });

  IceCandidate copyWith({
    String? participantId,
    RtcIceCandidateMapper? iceCandidate,
  }) {
    return IceCandidate(
      participantId: participantId ?? this.participantId,
      iceCandidate: iceCandidate ?? this.iceCandidate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participantId': participantId,
      'iceCandidate': iceCandidate.toMap(),
    };
  }

  factory IceCandidate.fromMap(Map<String, dynamic> map) {
    return IceCandidate(
      participantId: map['participantId'] as String,
      iceCandidate: RtcIceCandidateMapper.fromMap(
          map['iceCandidate'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory IceCandidate.fromJson(String source) =>
      IceCandidate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IceCandidate(participantId: $participantId, iceCandidate: $iceCandidate)';

  @override
  bool operator ==(covariant IceCandidate other) {
    if (identical(this, other)) return true;

    return other.participantId == participantId &&
        other.iceCandidate == iceCandidate;
  }

  @override
  int get hashCode => participantId.hashCode ^ iceCandidate.hashCode;
}
