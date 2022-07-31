class ChoiceOptions {
  int name;
  String title;
  List<int> options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}
