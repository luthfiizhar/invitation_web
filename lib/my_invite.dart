import 'package:flutter/material.dart';

class MyInviteModel {
  final String EventID;
  final String InvitationID;
  final int TotalVisitor;
  final String VisitTime;

  MyInviteModel(
    this.EventID,
    this.InvitationID,
    this.TotalVisitor,
    this.VisitTime,
  );

  DataRow getRow(
    SelectedCallBack callback,
    List<String> selectedIds,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(EventID)),
        DataCell(Text(InvitationID)),
        DataCell(Text(TotalVisitor.toString())),
        DataCell(Text(VisitTime)),

        // DataCell(
        //   Text(phone),
        // ),
      ],
      onSelectChanged: (newState) {
        callback(EventID.toString(), newState ?? false);
      },
      selected: selectedIds.contains(EventID.toString()),
    );
  }

  factory MyInviteModel.fromJson(Map<String, dynamic> json) {
    return MyInviteModel(
      json['EventID'] as String,
      json['InvitationID'] as String,
      json['TotalVisitor'] as int,
      json['VisitTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'EventID': EventID,
      'InvitationID': InvitationID,
      'VisitTime': VisitTime,
      'TotalVisitor': TotalVisitor,
    };
  }
}

typedef SelectedCallBack = Function(String id, bool newSelectState);
