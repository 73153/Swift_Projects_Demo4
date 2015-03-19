import Foundation
import CoreGraphics

extension MZ {

    public class Maths {

        // MARK: ETC

        public class func lerp(numerator n: MZFloat, denominator d: MZFloat) -> MZFloat {
            if d == 0.0 { return 1.0 }
            let base = n / d
            return base > 1 ? 1 : base
        }

        // MARK: Degrees and Radians

        public class func degreesFromRadians(radians: MZFloat) -> MZFloat {
            return radians * 180 / M_PI
        }

        public class func radiansFromDegrees(degrees: MZFloat) -> MZFloat {
            return degrees * M_PI / 180
        }

        public class func formatDegrees(origin: MZFloat) -> MZFloat {
            if 0 <= origin && origin < 360 { return origin }

            let _origin = fmodf(origin.toFloat(), 360.0)
            return MZFloat(_origin >= 0 ? _origin : 360.0 + _origin)
        }

        public class func randomInt(range: Range<Int>) -> Int {
            if range.startIndex >= range.endIndex { return range.startIndex }

            let length = range.endIndex - range.startIndex
            return range.startIndex + Int(arc4random_uniform(UInt32(length)))
        }

        public class func randomFloat(min: MZFloat = 0.0, max: MZFloat = 1.0) -> MZFloat {
            if min >= max { return min }

            let r =  MZFloat(arc4random()) / MZFloat(UInt32.max)
            return ((r * (max - min)) + min)
        }

        public class func degreesFromVector1(vector1: CGPoint, toVector2 vector2:CGPoint) -> MZFloat {
            let v1Dotv2 = MZ.Maths.dot(p1: vector1, p2: vector2)
            let v1lenMulv2len = MZ.Maths.lengthOfVector(vector1) * MZ.Maths.lengthOfVector(vector2)

            if v1lenMulv2len == 0.0 { return 0 }

            var result = acos(v1Dotv2 / v1lenMulv2len)
            result = MZ.Maths.degreesFromRadians(result)

            return result
        }

        public class func degreesFromXAxisToVector(vector :CGPoint) -> MZFloat {
            if vector.x == 0 {
                if vector.y > 0 { return 90.0 }
                if vector.y < 0 { return 270.0 }
            }

            if vector.y == 0 {
                if vector.x > 0 { return 0.0 }
                if vector.x < 0 { return 180.0 }
            }

            let result = MZ.Maths.degreesFromVector1(CGPointMake(1, 0), toVector2: vector)
            return vector.y >= 0 ? result : 360 - result
        }

        public class func degressFromP1(p1: CGPoint, toP2 p2: CGPoint) -> MZFloat {
            return MZ.Maths.degreesFromXAxisToVector(p2 - p1)
        }

        // MARK: Distance

        public class func distancePow2(#p1: CGPoint, p2: CGPoint) -> CGFloat {
            return (p2.x-p1.x)*(p2.x-p1.x) + (p2.y-p1.y)*(p2.y-p1.y)
        }

        public class func distance(#p1: CGPoint, p2: CGPoint) -> CGFloat {
            return sqrt(distancePow2(p1: p1, p2: p2))
        }

        // MARK: Vectors

        public class func unitVectorFromDegrees(degrees: MZFloat) -> CGPoint {
            let degrees_ = Int(degrees) % 360

            if degrees_ == 90   { return CGPoint(x:  0, y:  1) }
            if degrees_ == 270  { return CGPoint(x:  0, y: -1) }
            if degrees_ == 0    { return CGPoint(x:  1, y:  0) }
            if degrees_ == 180  { return CGPoint(x: -1, y:  0) }

            let radians = Maths.radiansFromDegrees(degrees)
            return CGPoint(x: cos(radians), y: sin(radians))
        }

        public class func unitVectorFromRadians(radians: MZFloat) -> CGPoint {
            return CGPoint(x: cos(radians), y: sin(radians))
        }

        public class func vectorMapToRadians(vector v: CGPoint, mapToRadians radians: MZFloat) -> CGPoint {
            let c = CGFloat(cos(radians))
            let s = CGFloat(sin(radians))

            return CGPoint(x: v.x*c - v.y*s, y: v.x*s + v.y*c)
        }

        public class func vectorMapToDegrees(vector v: CGPoint, degrees: MZFloat) -> CGPoint {
            let _deg = fmod(degrees, 360.0)

            if _deg ==   0.0 { return v }
            if _deg ==  90.0 { return CGPoint(x:  v.y, y:  v.x) }
            if _deg == 180.0 { return CGPoint(x: -v.x, y: -v.y) }
            if _deg == 270.0 { return CGPoint(x:  v.y, y: -v.x) }

            let radians = MZ.Maths.radiansFromDegrees(degrees)

            return MZ.Maths.vectorMapToRadians(vector: v, mapToRadians: radians)
        }

        public class func vectorFromVector(v: CGPoint, mapToRadians radians: MZFloat) -> CGPoint {
            let c = cos(radians).toCGFloat()
            let s = sin(radians).toCGFloat()

            let v2 = CGPoint(x: v.x*c - v.y*s, y: v.x*s + v.y*c)

            return v2
        }

        public class func vectorFromVector(v: CGPoint, mapToDegrees degrees: MZFloat) -> CGPoint {
            let _deg = fmodf(degrees.toFloat(), 360.0)

            if _deg ==   0.0 { return v }
            if _deg ==  90.0 { return CGPoint(x:  v.y, y:  v.x) }
            if _deg == 180.0 { return CGPoint(x: -v.x, y: -v.y) }
            if _deg == 270.0 { return CGPoint(x:  v.y, y: -v.x) }

            let radians = MZ.Maths.radiansFromDegrees(degrees)

            let c = cos(radians).toCGFloat()
            let s = sin(radians).toCGFloat()

            let v2 = CGPoint(x: v.x*c - v.y*s, y: v.x*s + v.y*c)
            
            return v2
        }

        public class func unitVectorFromPoint1(p1: CGPoint, toPoint2 p2: CGPoint) -> CGPoint {
            let diffY = p2.y - p1.y
            let diffX = p2.x - p1.x

            if diffY == 0 {
                if diffX > 0 { return CGPoint(x: 1, y: 0) }
                else if diffX < 0 { return CGPoint(x: -1, y: 0) }
                else { return CGPoint.zero }
            }

            let length = sqrt(pow(diffX, 2) + pow(diffY, 2))

            return CGPoint(x: diffX / length, y: diffY / length)
        }

        // MARK: Degrees distance
        // (暫定)

        public class func shortestDistanceFromDegrees(from: MZFloat, toDegrees to: MZFloat) -> MZFloat {
            let fromDeg = Maths.formatDegrees(from)
            var toDeg = Maths.formatDegrees(to)

            if toDeg < fromDeg { toDeg = toDeg + 360 }

            var distance = toDeg - fromDeg
            if abs(distance) > 180 { distance = -(360 - distance) }
        
            return distance
        }

        // MARK: Vector calculation

        public class func dot(#p1: CGPoint, p2: CGPoint) -> MZFloat {
            return ((p1.x * p2.x) + (p1.y * p2.y)).toMZFloat()
        }

        public class func lengthOfVector(vector: CGPoint) -> MZFloat {
            return sqrt(pow(vector.x, 2) + pow(vector.y, 2)).toMZFloat()
        }
    }
}