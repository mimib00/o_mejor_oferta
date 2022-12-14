enum AttributeTypes {
  text,
  number,
  boolean,
  checkbox,
  radiobox,
  images,
  textarea;

  const AttributeTypes();

  factory AttributeTypes.getType(String value) {
    switch (value) {
      case "TEXT":
        return AttributeTypes.text;
      case "NUMBER":
        return AttributeTypes.number;
      case "BOOLEAN":
        return AttributeTypes.boolean;
      case "RADIO":
        return AttributeTypes.radiobox;
      case "CHECKBOX":
        return AttributeTypes.checkbox;
      case "IMAGES":
        return AttributeTypes.images;
      case "TEXTAREA":
        return AttributeTypes.textarea;
      default:
        return AttributeTypes.text;
    }
  }
}

class Attributes {
  final int id;
  final String title;
  final String description;
  final int sequence;
  final bool required;
  final AttributeTypes type;
  final List<String> choices;
  final int category;

  Attributes(
    this.id,
    this.title,
    this.description,
    this.sequence,
    this.required,
    this.type,
    this.choices,
    this.category,
  );

  factory Attributes.fromJson(Map<String, dynamic> data) {
    return Attributes(
      data["id"],
      data["title"],
      data["sub_title"],
      data["sequence"],
      data["is_required"],
      AttributeTypes.getType(data["input_type"]),
      data["choices"].cast<String>(),
      data["category"],
    );
  }
}
