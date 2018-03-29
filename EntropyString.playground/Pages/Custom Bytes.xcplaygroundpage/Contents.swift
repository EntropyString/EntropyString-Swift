//: [Previous](@previous)
//: ## Custom Bytes
//:
//: As described in [Secure Bytes](Secure%20Bytes), `EntropyString` automatically generates random bytes using either `SecRandomCopyBuf` or `arc4random_buf`. These functions are fine, but you may have a need to provide your own bytes for deterministic testing or to use a specialized byte genterator. The function `entropy.string(bits:using)` allows specifying your own bytes to create a string.
//:
//: Suppose we want a string capable of 30 bits of entropy using 32 characters. We pass in 4 bytes (to cover the 30 bits):
import EntropyString

let entropy = Entropy()
let bytes: [UInt8] = [250, 200, 150, 100]
let string = try! entropy.string(bits: 30, using: bytes)

print("String: \(string)\n")
//: * callout(string): Th7fjL
//:
//: The __bytes__ provided can come from any source. However, if the number of bytes is insufficient to generate the string as described in the [Efficiency](Efficiency) section, an `EntropyStringError.tooFewBytes` is thrown.
do {
  try entropy.string(bits: 32, using: bytes)
}
catch {
  print(error)
}
//: * callout(error): tooFewBytes
//:
//: Note the number of bytes needed is dependent on the number of characters in the character set. For a string representation of entropy, we can only have multiples of the entropy bits per character. In the example above, each character represents 5 bits of entropy. So we can't get exactly 32 bits and we round up by the bits per character to a total 35 bits. We need 5 bytes (40 bits), not 4 (32 bits).
//:
//: `CharSet.bytes_needed(bits)` can be used to determine the number of bytes needed to cover a specified amount of entropy for a given character set.
let bytesNeeded = entropy.charset.bytesNeeded(bits: 32)

print("\nBytes needed: \(bytesNeeded)\n")
//: * callout(bytesNeeded): 5
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
