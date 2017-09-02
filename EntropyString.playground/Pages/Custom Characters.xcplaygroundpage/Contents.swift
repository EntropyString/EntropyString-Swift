//: [Previous](@previous)
//: ## Custom Characters
//:
//: Being able to easily generate random strings is great, but what if you want to specify your own characters? For example, suppose you want to visualize flipping a coin to produce 10 bits of entropy.
import EntropyString

let random = Random(.charSet2)
var flips = random.string(bits: 10)

print("flips: \(flips)\n")
//: * callout(flips): 0101001110
//:
//: The resulting string of __0__'s and __1__'s doesn't look quite right. Perhaps you want to use the characters __H__ and __T__ instead.
try! random.use("HT")
flips = random.string(bits: 10)

print("flips: \(flips)\n")
//: * callout(flips): HTTTHHTTHH
//:
//: As another example, we saw in [Character Sets](Character%20Sets) the default characters for `charSet16` are **0123456789abcdef**. Suppose you like uppercase hexadecimal letters instead.
try! random.use("0123456789ABCDEF")
let hex = random.string(bits: 48)

print("hex: \(hex)\n")
//: * callout(hex): 4D20D9AA862C
//:
//: The `Random` constructor allows for three separate cases:
//:   - No argument defauls to the `charSet32` characters.
//:   - One of six default `CharSet`s can be specified.
//:   - A string representing the characters to use can be specified.
//:
//: The 3rd option above will throw an `EntropyStringError` if the characters string isn't appropriate for creating a `CharSet`.
do {
  try random.use("abcdefg")
}
catch {
  print(error)
}
//: * callout(error): invalidCharCount
//:
do {
  try random.use("01233210")
}
catch {
  print(error)
}
//: * callout(error): charsNotUnique
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
