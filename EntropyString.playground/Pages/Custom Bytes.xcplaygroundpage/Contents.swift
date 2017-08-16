//: [Previous](@previous)
//: ## Custom Bytes
//:
//: As described in [Secure Bytes](Secure%20Bytes), `EntropyString` automatically generates random bytes using either `SecRandomCopyBuf` or `arc4random_buf`. These functions are fine, but you may have a need to provide your own btyes for deterministic testing or to use a specialized byte genterator. The function `random.string(bits:using)` allows specifying your own bytes to create a string.
//:
//: Suppose we want a string capable of 30 bits of entropy using 32 characters. We pass in 4 bytes (to cover the 30 bits):
  import EntropyString

  let random = Random()
  let bytes: [UInt8] = [250, 200, 150, 100]
  let string = try! random.string(bits: 30, using: bytes)

  print("String: \(string)\n")
//: * callout(string): Th7fjL
//:
//: The __bytes__ provided can come from any source. However, if the number of bytes is insufficient to generate the string as described in the [Efficiency](Efficiency) section, an `EntropyStringError.tooFewBytes` is thrown.
  do {
    try random.string(bits: 32, using: bytes)
  }
  catch {
    print(error)
  }
//: * callout(error): tooFewBytes
//:
//: Note the number of bytes needed is dependent on the number of characters in our set. In using a string to represent entropy, we can only have multiples of the bits of entropy per character used. So in the example above, to get at least 32 bits of entropy using a character set of 32 characters (5 bits per char), we'll need enough bytes to cover 35 bits, not 32, so a `tooFewBytes` error is thrown.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
