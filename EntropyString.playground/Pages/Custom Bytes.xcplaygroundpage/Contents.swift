//: [Previous](@previous)
//: ## Custom Bytes
//:
//: As described in [Secure Bytes](Secure%20Bytes), `EntropyString` automatically generates random
//: bytes using either `SecRandomCopyBuf` or `arc4random_buf`. These functions are fine, but you
//: may have a need to provide your own btyes, say for deterministic testing or to use a
//: specialized byte genterator. The `RandomString.entropy(of:using:bytes)` function allows 
//: passing in your own bytes to create a string.
import EntropyString

let bytes: RandomString.Bytes = [250, 200, 150, 100]
let string = try! RandomString.entropy(of: 30, using: .charSet32, bytes: bytes)
print("String: \(string)\n")
//: * callout(string): Th7fjL
//:
//: The __bytes__ provided can come from any source. However, the number of bytes must be
//: sufficient to generate the string as described in the [Efficiency](Efficiency) section.
//: `RandomString.entropy(of:using:bytes)` throws `RandomString.RandomError.tooFewBytes` if
//: the string cannot be formed from the passed bytes.
do {
  try RandomString.entropy(of: 32, using: .charSet32, bytes: bytes)
}
catch {
  print(error)
}
//: * callout(error): tooFewBytes
//:
//: [TOC](Table%20of%20Contents)
