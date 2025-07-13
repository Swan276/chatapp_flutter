import 'dart:convert';

class EndCall {
  EndCall({
    required this.participantId,
  });

  final String participantId;

  EndCall copyWith({
    String? participantId,
  }) {
    return EndCall(
      participantId: participantId ?? this.participantId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participantId': participantId,
    };
  }

  factory EndCall.fromMap(Map<String, dynamic> map) {
    return EndCall(
      participantId: map['participantId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EndCall.fromJson(String source) =>
      EndCall.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EndCall(participantId: $participantId)';

  @override
  bool operator ==(covariant EndCall other) {
    if (identical(this, other)) return true;

    return other.participantId == participantId;
  }

  @override
  int get hashCode => participantId.hashCode;
}
