class VaderQuotes {
  static const List<String> quotes = [
    "I find your lack of notes disturbing.",
    "The Force is strong with this one.",
    "Join the Dark Side... and take some notes.",
    "I am altering the note. Pray I don't alter it any further.",
    "Impressive. Most impressive.",
    "You have failed me for the last time... write it down!",
    "Be careful not to choke on your aspirations.",
    "The circle is now complete.",
    "Your destiny lies with me.",
    "There is no escape. Don't make me destroy you.",
    "You underestimate the power of the Dark Side.",
    "All too easy.",
  ];

  static String getRandomQuote() {
    return (List<String>.from(quotes)..shuffle()).first;
  }
}
