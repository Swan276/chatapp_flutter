// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class RtcIceCandidateMapper {
  RtcIceCandidateMapper({
    required this.id,
    required this.candidate,
    required this.label,
  });

  final String? id;
  final String? candidate;
  final int? label;

  RTCIceCandidate getRTCIceCandidate() {
    return RTCIceCandidate(candidate, id, label);
  }

  RtcIceCandidateMapper copyWith({
    String? id,
    String? candidate,
    int? label,
  }) {
    return RtcIceCandidateMapper(
      id: id ?? this.id,
      candidate: candidate ?? this.candidate,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'candidate': candidate,
      'label': label,
    };
  }

  factory RtcIceCandidateMapper.fromMap(Map<String, dynamic> map) {
    return RtcIceCandidateMapper(
      id: map['id'] != null ? map['id'] as String : null,
      candidate: map['candidate'] != null ? map['candidate'] as String : null,
      label: map['label'] != null ? map['label'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RtcIceCandidateMapper.fromJson(String source) =>
      RtcIceCandidateMapper.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RtcIceCandidateMapper(id: $id, candidate: $candidate, label: $label)';

  @override
  bool operator ==(covariant RtcIceCandidateMapper other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.candidate == candidate &&
        other.label == label;
  }

  @override
  int get hashCode => id.hashCode ^ candidate.hashCode ^ label.hashCode;
}
