// Playground - noun: evlovation for fibonacci based on wwdc2014 session 404, advanced swift

import Cocoa

/*
* 1, recursive with non-memoize, middle across can't be adapted
*
func fibonacci_nonmemoize(n: Int) -> Double {
return n < 2 ? Double(n) : fibonacci_nonmemoize(n-1) + fibonacci_nonmemoize(n-2)
}
fibonacci_nonmemoize(20)
*/

/*
* 2, recursive with manual memoize
*/
var fibonacci_manualmem = Dictionary<Int, Double>()
func fibonacci_mm(n: Int) -> Double{
    if let result = fibonacci_manualmem[n] {
        return result
    }
    let result = n < 2 ? Double(n) : fibonacci_mm(n-1) + fibonacci_mm(n-2)
    fibonacci_manualmem[n] = result
    return result
}
fibonacci_mm(20)

/*
* 3, recursive with auto memoize for result to avoid type inference
*/
func memoizeAuto<T: Hashable, U>( body: (T)-> U ) -> (T)->U {
    var memo = Dictionary<T, U>();
    return {
        x in
        if let q = memo[x] {return q}
        let r = body(x)
        memo[x] = r
        return r
    }
}
/* error: variable used within its own initial value
let fibonacciAuto = memoizeAuto{
    fibonacciAuto, n in
    n < 2 ? Double(n) : fibonacciAuto(n-1) + fibonacciAuto(n-2)
}
*/
var fibonacciAuto: (Int) -> Double = { Double($0) }
fibonacciAuto = memoizeAuto {
    (n : Int) in n < 2 ? Double(n) : fibonacciAuto(n-1) + fibonacciAuto(n-2)
}
fibonacciAuto(20)


/*
* 4, recursive with auto memoize for result to avoid type inference
*/
func memoizeBodyResult<T: Hashable, U>( body: ((T)->U, T)->U ) -> (T)->U {
    var memo = Dictionary<T, U>()
    var result: ((T)->U)!
    result = {
        x in
        if let q = memo[x] {return q}
        let r = body(result, x)
        memo[x] = r
        return r
    }
    return result
}
let fibonacci = memoizeBodyResult{
    (fib, x: Int) in x < 2 ? Double(x) : fib(x-1) + fib(x-2)
}
fibonacci(20)