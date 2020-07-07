class Bundesland_suggesstions{

  static List<String> states = <String>["Baden-Württemberg",
    "Bayern",
    "Berlin",
    "Brandenburg",
    "Bremen",
    "Hamburg",
    "Hessen",
    "Mecklenburg-Vorpommern",
    "Niedersachsen",
    "Nordrhein-Westfalen",
    "Rheinland-Pfalz",
    "Saarland",
    "Sachsen",
    "Sachsen-Anhalt",
    "Schleswig-Holstein",
    "Thüringen"
  ];

  static getStateSuggesstions(String pattern) {
    RegExp exp = new RegExp("$pattern");

    List<String> matches = new List<String>();

    for (String c in states) {
      if (exp.hasMatch(c))
        matches.add(c);
    }

    return matches;
  }
}