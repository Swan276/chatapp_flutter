import 'dart:convert';

class InitCall {
  InitCall({
    required this.participantId,
    this.participantName,
    required this.sdpOffer,
  });

  final String participantId;
  final String? participantName;
  final dynamic sdpOffer;

  InitCall copyWith({
    String? participantId,
    String? participantName,
    dynamic sdpOffer,
  }) {
    return InitCall(
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      sdpOffer: sdpOffer ?? this.sdpOffer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participantId': participantId,
      'participantName': participantName,
      'sdpOffer': sdpOffer,
    };
  }

  factory InitCall.fromMap(Map<String, dynamic> map) {
    return InitCall(
      participantId: map['participantId'] as String,
      participantName: map['participantName'] as String?,
      sdpOffer: map['sdpOffer'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory InitCall.fromJson(String source) =>
      InitCall.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'InitCall(participantId: $participantId, participantName: $participantName, sdpOffer: $sdpOffer)';

  @override
  bool operator ==(covariant InitCall other) {
    if (identical(this, other)) return true;

    return other.participantId == participantId &&
        other.participantName == participantName &&
        other.sdpOffer == sdpOffer;
  }

  @override
  int get hashCode =>
      participantId.hashCode ^ participantName.hashCode ^ sdpOffer.hashCode;
}
