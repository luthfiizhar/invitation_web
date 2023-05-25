class SearchTerm {
  SearchTerm({
    this.keywords = "",
    this.max = "10",
    this.pageNumber = "1",
    this.orderBy = "",
    this.orderDir = "",
    this.formType = "Request",
  });
  String keywords;
  String pageNumber;
  String orderBy;
  String orderDir;
  String max;
  String formType;

  @override
  String toString() {
    return "orderBy : $orderBy, orderDir : $orderDir";
  }
}
