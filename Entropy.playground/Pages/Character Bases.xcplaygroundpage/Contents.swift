//: [Previous](@previous)
//: ## Character Bases
//:
//: As we've seen in the previous sections, `EntropyString` provides default characters for each of
//: the supported bases. Let's see what's under the hood.
import EntropyString

print("Base 64: \(RandomString.characters(for: .base64))\n")
//: The call to `RandomString.characters(for:)` returns the characters used for any of the
//: bases defined by the `RandomString.CharBase enum`. The following code reveals all the
//: character bases.
print("Base 32: \(RandomString.characters(for: .base32))\n")
print("Base 16: \(RandomString.characters(for: .base16))\n")
print("Base  8: \(RandomString.characters(for: .base8))\n")
print("Base  4: \(RandomString.characters(for: .base4))\n")
print("Base  2: \(RandomString.characters(for: .base2))\n")
//: The default character bases were chosen as follows:
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
//: You may, of course, want to choose the characters used, which is covered next in [Custom
//: Characters](Custom%20Characters).
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
