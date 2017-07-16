//: [Previous](@previous)
//: ## Efficiency
//:
//: To efficiently create random strings, `EntropyString` generates the necessary number of
//: bytes needed for each the string and uses those bytes in a bit shifting scheme to index into
//: a character set. For example, consider generating strings from the `.charSet32` character
//: set. There are __32__ characters in the set, so an index into an array of those characters
//: would be in the range `[0,31]`. Generating a random string of `.charSet32` characters is thus
//: reduced to generating a random sequence of indices in the range `[0,31]`.
//:
//: To generate the indices, `EntropyString` slices just enough bits from the array of bytes to create
//: each index. In the example at hand, 5 bits are needed to create an index in the range
//: `[0,31]`. `EntropyString` processes the byte array 5 bits at a time to create the indices. The first
//: index comes from the first 5 bits of the first byte, the second index comes from the last 3 bits of
//: the first byte combined with the first 2 bits of the second byte, and so on as the byte array is
//: systematically sliced to form indices into the character set. And since bit shifting and addition
//: of byte values is really efficient, this scheme is quite fast.
//:
//: The `EntropyString` scheme is also efficient with regard to the amount of randomness used. Consider
//: the following common Swift solution to generating random strings. To generated a character, an index
//: into the available characters is create using `arc4random_uniform`. The code looks something like:
//:
//:    for _ in 0 ..< len {
//:      let offset = Int(arc4random_uniform(charCount))
//:      let index = chars.index(chars.startIndex, offsetBy: offset)
//:      let char = chars[index]
//:      string += String(char)
//:    }
//:
//: In the code above, `arc4random_uniform` generates 32 bits of randomness, returned as an `UInt32`. The
//: returned value is used to create an **index**. Suppose we're creating strings with **len=16** and
//: **charCount=32**. Each **char** consumes 32 bits of randomness (`UInt32`) while only injecting 5 bits
//: (`log2(32)`) of entropy into **string**. The resulting string has an information carrying capacity of
//: 80 bits. So creating each **string** requires a *total* of 512 bits of randomness while only actually
//: *carrying* 80 bits of that entropy forward in the string itself. That means 432 bits (84% of the total!)
//: of the generated randomness is simply wasted away.
//:
//: Compare that to the `EntropyString` scheme. For the example above, slicing off 5 bits at a time
//: requires a total of 80 bits (10 bytes). Creating the same strings as above, `EntropyString` uses 80
//: bits of randomness per string with no wasted bits. In general, the `EntropyString` scheme can waste
//: up to 7 bits per string, but that's the worst case scenario and that's *per string*, not *per
//: character*!
//:
//: Fortunately you don't need to really understand how the bytes are efficiently sliced and diced to get
//: the string. But you may want to know that [Secure Bytes](#SecureBytes) are used, and that's the next
//: topic.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
