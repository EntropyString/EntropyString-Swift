//: [Previous](@previous)
//:
//:Thus far we've avoided the mathematics behind the calculation of the entropy bits required to specify a risk that some number random strings will not have a repeat. As noted in the [Overview](#Overview), the posting [Hash Collision Probabilities](http://preshing.com/20110504/hash-collision-probabilities/) derives an expression, based on the well-known [Birthday Problem](https://en.wikipedia.org/wiki/Birthday_problem#Cast_as_a_collision_problem), for calculating the probability of a collision in some number of hashes (denoted by `k`) using a perfect hash with an output of `M` bits:
//:
//: ![Hash Collision Probability](HashCollision.png)
//:
//: There are two slight tweaks to this equation as compared to the one in the referenced posting. `M` is used for the total number of possible hashes and an equation is formed by explicitly specifying that the expression in the posting is approximately equal to `1/n`.
//:
//: More importantly, the above equation isn't in a form conducive to our entropy string needs. The equation was derived for a set number of possible hashes and yields a probability, which is fine for hash collisions but isn't quite right for calculating the bits of entropy needed for our random strings.
//:
//: The first thing we'll change is to use `M = 2^N`, where `N` is the number of entropy bits. This simply states that the number of possible strings is equal to the number of possible values using `N` bits:
//:
//: ![N-Bit Collision Probability](NBitCollision.png)
//:
//: Now we massage the equation to represent `N` as a function of `k` and `n`:
//:
//: ![Entropy Bits Equation](EntropyBits.png)
//:
//: The final line represents the number of entropy bits `N` as a function of the number of potential strings `k` and the risk of repeat of 1 in `n`, exactly what we want. Furthermore, the equation is in a form that avoids really large numbers in calculating `N` since we immediately take a logarithm of each large value `k` and `n`.
//:
//: [Next](@next)
