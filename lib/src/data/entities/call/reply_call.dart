import 'dart:convert';

class ReplyCall {
  ReplyCall({
    required this.participantId,
    required this.sdpAnswer,
  });

  final String participantId;
  final dynamic sdpAnswer;

  bool get isRejected => sdpAnswer == null;

  ReplyCall copyWith({
    String? participantId,
    dynamic sdpAnswer,
  }) {
    return ReplyCall(
      participantId: participantId ?? this.participantId,
      sdpAnswer: sdpAnswer ?? this.sdpAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participantId': participantId,
      'sdpAnswer': sdpAnswer,
    };
  }

  factory ReplyCall.fromMap(Map<String, dynamic> map) {
    return ReplyCall(
      participantId: map['participantId'] as String,
      sdpAnswer: map['sdpAnswer'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplyCall.fromJson(String source) =>
      ReplyCall.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReplyCall(participantId: $participantId, sdpAnswer: $sdpAnswer)';

  @override
  bool operator ==(covariant ReplyCall other) {
    if (identical(this, other)) return true;

    return other.participantId == participantId && other.sdpAnswer == sdpAnswer;
  }

  @override
  int get hashCode => participantId.hashCode ^ sdpAnswer.hashCode;
}
