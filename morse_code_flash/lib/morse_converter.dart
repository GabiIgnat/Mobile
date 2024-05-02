/*
This is a morse converter class that will be used to convert a string to morse code and back.
 */

class MorseConverter {
  static final Map<String, String> _morseCodeMap = {
    ' ': '/',
    'A': '.-',
    'B': '-...',
    'C': '-.-.',
    'D': '-..',
    'E': '.',
    'F': '..-.',
    'G': '--.',
    'H': '....',
    'I': '..',
    'J': '.---',
    'K': '-.-',
    'L': '.-..',
    'M': '--',
    'N': '-.',
    'O': '---',
    'P': '.--.',
    'Q': '--.-',
    'R': '.-.',
    'S': '...',
    'T': '-',
    'U': '..-',
    'V': '...-',
    'W': '.--',
    'X': '-..-',
    'Y': '-.--',
    'Z': '--..',
    '1': '.----',
    '2': '..---',
    '3': '...--',
    '4': '....-',
    '5': '.....',
    '6': '-....',
    '7': '--...',
    '8': '---..',
    '9': '----.',
    '0': '-----',
    '.': '.-.-.-',
    ',': '--..--',
    '?': '..--..',
    '!': '-.-.--',
    '/': '-..-.',
    '(': '-.--.',
    ')': '-.--.-',
    '&': '.-...',
    ':': '---...',
    ';': '-.-.-.',
    '=': '-...-',
    '+': '.-.-.',
    '-': '-....-',
    '_': '..--.-',
    '"': '.-..-.',
    '\$': '...-..-',
    '@': '.--.-.',
  };

  static Map<String, String> get morseCodeMap => _morseCodeMap;

  static String encodeLetter(String letter) {
    letter = letter.toUpperCase();

    return _morseCodeMap[letter] ?? '';
  }

  // Encode a string to morse code -> each letter is converted to morse code and separated by a space
  static String encodeString(String text) {
    return text
        .split('')
        .map((letter) => encodeLetter(letter))
        .join(' ');
  }

  static String decodeMorseLetter(String morseCode) {
    return _morseCodeMap.keys.firstWhere((key) => _morseCodeMap[key] == morseCode, orElse: () => '');
  }

  // Decode a morse code string -> each morse code letter is converted to a letter and separated by a space
  static String decodeMorseString(String morseCode) {
    return morseCode
        .split(' ')
        .map((morseLetter) => decodeMorseLetter(morseLetter))
        .join('');
  }
}