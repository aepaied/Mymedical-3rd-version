class RecentSearch {
  int id;
  String searchText;

  RecentSearch({
    this.id,
    this.searchText
  });

  RecentSearch.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.searchText = json["searchText"];
  }
}
