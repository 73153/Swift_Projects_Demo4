import Foundation
import CoreGraphics

// MARK: CGPoint

extension CGPoint {
    static var zero: CGPoint { get { return CGPoint.zeroPoint } }

    static var one: CGPoint { get { return CGPoint(x: 1, y: 1) } }

    init(x: Float, y: Float) {
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }

    init(x: MZFloat, y: MZFloat) {
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }

    init(size: CGSize) {
        self.x = CGFloat(size.width)
        self.y = CGFloat(size.height)
    }

    func toCGSize() -> CGSize { return CGSize(width: self.x, height: self.y) }

    func toCGVector() -> CGVector { return CGVector(dx: self.x, dy: self.y) }
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x + rhs.x, lhs.y + rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x - rhs.x, lhs.y - rhs.y)
}

public func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPointMake(lhs.x * rhs, lhs.y * rhs)
}

public func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x * rhs.x, lhs.y * rhs.y)
}

public func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPointMake(lhs.x / rhs, lhs.y / rhs)
}

public func / (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x / rhs.x, lhs.y / rhs.y)
}

public func += (inout lhs: CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
}

public func -= (inout lhs: CGPoint, rhs: CGPoint) {
    lhs = lhs - rhs
}



// MARK: CGSize

extension CGSize {
    static var zero: CGSize { get { return CGSize(width: 0, height: 0) } }
    static var one: CGSize { get { return CGSize(width: 1, height: 1) } }
}

public func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

public func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

public func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

public func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}



// MARK: CGRect

extension CGRect {

    static var one: CGRect {
        get { return CGRect(center: CGPoint.zero, size: CGSize(width: 1, height: 1)) }
    }

    init(center: CGPoint, size: CGSize) {
        self.origin = CGPoint.zero
        self.size = size
        self.center = center
    }

    init(cx: CGFloat, cy: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(center: CGPoint(x: cx, y: cy), size: CGSize(width: width, height: height))
    }

    init(size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }

    var center: CGPoint {
        get { return self.origin + CGPoint(size: self.size / 2) }
        set { self.origin = newValue - CGPoint(size: self.size / 2) }
    }
}



// MARK: CGVector

extension CGVector {

    func mapToRadians(radians: CGFloat) -> CGVector {
        let c = cos(radians);
        let s = sin(radians);

        return CGVector(dx: self.dx*c - self.dy*s, dy: self.dx*s + self.dy*c)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVectorMake(lhs.dx + rhs.dx, lhs.dy + rhs.dy)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVectorMake(lhs.dx - rhs.dx, lhs.dy - rhs.dy)
}

public func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVectorMake(lhs.dx * rhs, lhs.dy * rhs)
}

public func * (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVectorMake(lhs.dx * rhs.dx, lhs.dy * rhs.dy)
}

public func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVectorMake(lhs.dx / rhs, lhs.dy / rhs)
}

public func / (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVectorMake(lhs.dx / rhs.dx, lhs.dy / rhs.dy)
}

public func += (inout lhs: CGVector, rhs: CGVector) {
    lhs = lhs + rhs
}

public func -= (inout lhs: CGVector, rhs: CGVector) {
    lhs = lhs - rhs
}

public func *= (inout lhs: CGVector, rhs: CGFloat) {
    lhs = lhs * rhs
}

public func /= (inout lhs: CGVector, rhs: CGFloat) {
    lhs = lhs / rhs
}