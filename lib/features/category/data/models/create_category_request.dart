class CreateCategoryRequest {
  final String name;

  const CreateCategoryRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}
