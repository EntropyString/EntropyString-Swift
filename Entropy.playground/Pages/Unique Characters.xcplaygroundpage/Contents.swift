//: [Previous](@previous)
//: ## Unique Characters
//:
//: As noted in [Custom Characters](Custom%20Characters), specifying the characters to use for a
//: base can fail if the number of characters is invalid or if any character repeats.  The desire
//: for unique characters is due to the calculation of entropy, which includes the probability of
//: the occurrence of each character. `EntropyString` assumes the characters are unique so that each
//: has the exact same probability of occurrence.
//:
import EntropyString

let randomString = RandomString()
do {
  try randomString.use("0120", for: .base4)
}
catch {
  print(error)
}
//: * callout(error): charsNotUnique
//:
//: You can force the use of repeat characters. (BTW, don't do this unless you really know what you
//: are doing.)
try! randomString.use("0120", for: .base4, force: true)
//: Now we'll create a string by specifying an __entropy__ of __128__ bits and print the result.
let string = randomString.entropy(of: 128, using: .base4)

print("string: \(string)\n")
//: * callout(string): 2201121012112100012022010002011020212002200212100110022121201221
//:
//: Looking at the string may not reveal a problem, but the display of the various character counts
//: sure does!
let zeros = string.characters.filter { $0 == "0" }.count
let ones = string.characters.filter { $0 == "1" }.count
let twos = string.characters.filter { $0 == "2" }.count

print("counts:  0 -> \(zeros)  |  1 -> \(ones)  |  2 -> \(twos)\n")
//: * callout(counts):  0 -> 32  |  1 -> 15  |  2 -> 17
//:
//: The string *does not have* __128 bits of entropy__! If all 4 characters in use are unique, we
//: would expect each character in the string to provide __2 bits__ of information (entropy).  But
//: since the character __0__ is *twice* as likely to occur as either __1__ or __2__, the actual
//: entropy per character has been reduced to __1.5 bits__. So the strings generated only have
//: __96__ bits of entropy.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
