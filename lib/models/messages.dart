import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  int id;
  String searchId;
  FieldValue lastTime;
  String date;
  String time;
  String type;
  String docId;
  String fileName;
  String seenByOther;
  String message;
  int senderId;
  String sendBy;
  int toId;
  String status;
  String seen;

  Message({
    required this.id,
    required this.searchId,
    required this.lastTime,
    required this.date,
    required this.time,
    required this.type,
    required this.docId,
    required this.fileName,
    required this.seenByOther,
    required this.message,
    required this.senderId,
    required this.sendBy,
    required this.toId,
    required this.status,
    required this.seen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'search_id': searchId,
      'last_time': lastTime,
      'date': date,
      'time': time,
      'type': type,
      'doc_id': docId,
      'fileName': fileName,
      'seen_by_other': seenByOther,
      'message': message,
      'sender_id': senderId,
      'sendby': sendBy,
      'to_id': toId,
      'status': status,
      'seen': seen,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      searchId: map['search_id'],
      lastTime: map['last_time'],
      date: map['date'],
      time: map['time'],
      type: map['type'],
      docId: map['doc_id'],
      fileName: map['fileName'],
      seenByOther: map['seen_by_other'],
      message: map['message'],
      senderId: map['sender_id'],
      sendBy: map['sendby'],
      toId: map['to_id'],
      status: map['status'],
      seen: map['seen'],
    );
  }
}
