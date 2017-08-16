//: [Previous](@previous)
//: ## Character Sets
//:
//: As we\'ve seen in the previous sections, `EntropyString` provides default characters for each of the supported character sets. Let\'s see what\'s under the hood. The available `CharSet`s are *.charSet64*, *.charSet32*, *.charSet16*, *.charSet8*, *.charSet4* and *.charSet2*. The default characters for each were chosen as follows:
  import EntropyString

  print("Base 64 chars: \(CharSet.charSet64.chars)\n")
  print("Base 32 chars: \(CharSet.charSet32.chars)\n")
  print("Base 16 chars: \(CharSet.charSet16.chars)\n")
  print("Base  8 chars: \(CharSet.charSet8.chars)\n")
  print("Base  4 chars: \(CharSet.charSet4.chars)\n")
  print("Base  2 chars: \(CharSet.charSet2.chars)\n")
//: The default character sets were chosen as follows:
//:  - Base 64: **ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_**
//:     - The file system and URL safe char set from
//:       [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5).
//:  - Base 32: **2346789bdfghjmnpqrtBDFGHJLMNPQRT**
//:      * Remove all upper and lower case vowels (including y)
//:      * Remove all numbers that look like letters
//:      * Remove all letters that look like numbers
//:      * Remove all letters that have poor distinction between upper and lower case values.
//:      * The resulting strings don't look like English words and are easy to parse visually.
//:  - Base 16: **0123456789abcdef**
//:     - Hexadecimal
//:  - Base  8: **01234567**
//:     - Octal
//:  - Base  4: **ATCG**
//:     - DNA alphabet. No good reason; just wanted to get away from the obvious.
//:  - Base  2: **01**
//:     - Binary
//:
//: You may, of course, want to choose the characters used, which is covered next in [Custom Characters](Custom%20Characters).
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
