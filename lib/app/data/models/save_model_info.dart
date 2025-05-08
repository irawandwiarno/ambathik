class SavedModelInfo {
  final String label;
  final String path;

  SavedModelInfo({required this.label, required this.path});

  Map<String, dynamic> toJson() => {
    'label': label,
    'path': path,
  };

  factory SavedModelInfo.fromJson(Map<String, dynamic> json) {
    return SavedModelInfo(
      label: json['label'],
      path: json['path'],
    );
  }
}
