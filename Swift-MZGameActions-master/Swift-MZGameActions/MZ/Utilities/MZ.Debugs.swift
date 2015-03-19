import Foundation

extension MZ {

    class public func log(format: String, _ args: CVarArgType...) {
        let message = String(format: format, arguments: args)
        println(message)
    }

    class public func assert(predicate: @autoclosure () -> Bool, _ format: String, _ args: CVarArgType...) {
        if predicate() { return }

        let message = String(format: format, arguments: args)
        println(message)
        abort()
    }

    class public func assertAlwayFalse(format: String, _ args: CVarArgType...) {
        let message = String(format: format, arguments: args)
        println(message)
        abort()
    }

    class public func assertOverrideMe() {
        assertAlwayFalse("Override Me")
    }

    class func printFileLine(file: String = __FILE__, line: Int = __LINE__) {
        println("at \(file): \(line)")
    }
}