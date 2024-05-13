class PerksModel {
  PerksModel({required this.name, required this.description});

  final String name;
  final String description;

  factory PerksModel.updateName({required String name, required PerksModel perksModel}) => PerksModel(
        name: name,
        description: perksModel.description,
      );

  factory PerksModel.updateDescription({required String description, required PerksModel perksModel}) => PerksModel(
        name: perksModel.name,
        description: description,
      );
}
