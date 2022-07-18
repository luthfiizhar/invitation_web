class Visitor {
  Visitor(
      {this.FirstName,
      this.LastName,
      this.Email,
      // this.startDate,
      // this.endDate,
      this.number});

  String? FirstName;
  String? LastName;
  String? Email;
  // String? startDate;
  // String? endDate;
  int? number;

  toString() => 'FirstName: $FirstName, LastName: $LastName, Email: $Email';

  Map toJson() => {
        'FirstName': FirstName,
        'LastName': LastName,
        'Email': Email,
        // 'startDate': startDate,
        // 'endDate': endDate,
      };
}
