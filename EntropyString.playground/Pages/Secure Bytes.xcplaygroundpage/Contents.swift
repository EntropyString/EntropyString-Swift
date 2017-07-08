//: [Previous](@previous)
//: ## Secure Bytes
//:
//: As described in [Efficiency](Efficiency), `EntropyString` uses an underlying array of
//: bytes to generate strings. The entropy of the resulting strings is, of course, directly
//: tied to the randomness of the bytes used. That's an important point. Strings are only capable
//: of carrying information (entropy), it's the random bytes that actually provide the entropy
//: itself.
//:
//: `EntropyString` automatically generates the necessary number of bytes needed for the
//: strings using either `SecRandomCopyBytes` or `arc4random_buf`, both of which produce
//: cryptographically-secure random byte. `SecRandomCopyBytes` is the stronger of the two,
//: but can fail. Rather than propagate that failure, if `SecRandomCopyBytes` fails
//: `EntropyString` falls back and uses`arc4random_buf` to generate the bytes. Though not as
//: secure, `arc4random_buf` does not fail.
//:
//: You may, however, want to know which routine was used to generate the underlying bytes for a
//: string. `RandomString` provides an additional `inout` parameter in the
//: `RandomString.entropy(for:using:secure)` function for this purpose.
import EntropyString

var secure = true
RandomString.entropy(of: 20, using: .charSet32, secure: &secure)
print("secure: \(secure)")
//: * callout(secure): true
//:
//: If `SecRandomCopyBytes` is used, the __secure__ parameter will remain `true`; otherwise it
//: will be flipped to `false`.
//:
//: You can also pass in __secure__ as `false`, in which case the `entropy` call will not
//: attempt to use `SecRandomCopyBytes` and will use `arc4random_buf` instead.
secure = false
RandomString.entropy(of: 20, using: .charSet32, secure: &secure)
//: Rather than have `EntropyString` generate bytes automatically, you can provide your own [Custom
//: Bytes](Custom%20Bytes) to create a string, which is the next topic.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
