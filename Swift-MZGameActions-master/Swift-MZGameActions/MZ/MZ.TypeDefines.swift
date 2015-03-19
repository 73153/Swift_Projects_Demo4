import Foundation
import CoreGraphics

public typealias MZFloat = Double

extension MZFloat {
    func toFloat() -> Float { return Float(self) }
    func toCGFloat() -> CGFloat { return CGFloat(self) }
}

extension Float {
    func toMZFloat() -> MZFloat { return Double(self) }
    func toCGFloat() -> CGFloat { return CGFloat(self) }
}

extension CGFloat {
    func toMZFloat() -> MZFloat { return toDouble() }
    func toDouble() -> Double { return Double(self) }
    func toFloat() -> Float { return Float(self) }
}
