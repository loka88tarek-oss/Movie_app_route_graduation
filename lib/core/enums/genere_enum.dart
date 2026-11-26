enum GenereEnum {
  action('Action'),
  comedy('Comedy'),
  drama('Drama'),
  animation('Animation'),
  horror('Horror'),
  romance('Romance'),
  scifi('Sci-Fi');

  const GenereEnum(this.apiName);

  final String apiName;
  static GenereEnum? fromApiName(String name) {
    for (final genre in values) {
      if (genre.apiName == name) return genre;
    }
    return null;
  }
}
