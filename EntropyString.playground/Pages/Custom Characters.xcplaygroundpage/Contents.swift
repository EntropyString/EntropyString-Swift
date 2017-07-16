//: [Previous](@previous)
//: ## Custom Characters
//:
//: Being able to easily generate random strings is great, but what if you want to specify your
//: own characters? For example, suppose you want to visualize flipping a coin to produce 10 bits
//: of entropy.
import EntropyString

let randomString = RandomString()
var flips = randomString.entropy(of: 10, using: .charSet2)
print("flips: \(flips)\n")
//: * callout(flips): 0101001110
//:
//: The resulting string of __0__'s and __1__'s doesn't look quite right. You want to use the
//: characters __H__ and __T__ instead.
try! randomString.use("HT", for: .charSet2)
flips = randomString.entropy(of: 10, using: .charSet2)
print("flips: \(flips)\n")
//: * callout(flips): HTTTHHTTHH
//:
//: Note that setting custom characters in the above code requires using an *instance* of
//: `RandomString`, wheras in the previous sections we used *class* functions for all calls. The
//: function signatures are the same in each case, but you can't change the static character sets
//: used in the class `RandomString` (i.e., there is no `RandomString.use(_,for:)` function).
//:
//: As another example, we saw in [Character Sets](Character%20Sets) the default characters for
//: charSet 16 are **0123456789abcdef**. Suppose you like uppercase hexadecimal letters instead.
try! randomString.use("0123456789ABCDEF", for: .charSet16)
let hex = randomString.entropy(of: 48, using: .charSet16)
print("hex: \(hex)\n")
//: * callout(hex): 4D20D9AA862C
//:
//: Or suppose you want a random password with numbers, lowercase letters and special characters.
try! randomString.use("1234567890abcdefghijklmnopqrstuvwxyz-=[];,./~!@#$%^&*()_+{}|:<>?", for: .charSet64)
let password = randomString.entropy(of: 64, using: .charSet64)
print("password: \(password)")
//: * callout(password): }4?0x*$o_=w
//:
//: Note that `randomString.use(_,for:)` throws a `RandomStringError` if the number of characters
//: doesn't match the number required for the character set or if the characters are not unique.
do {
  try randomString.use("abcdefg", for: .charSet8)
}
catch {
  print(error)
}
//: * callout(error): invalidCharCount
//:
do {
  try randomString.use("01233210", for: .charSet8)
}
catch {
  print(error)
}
//: * callout(error): charsNotUnique
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
