import Foundation
import SpriteKit

extension MZ {

    @objc public class Nodes: Action, MZPTransform {

        public var position: CGPoint {
            get { return _position }
            set { _position = newValue; _updatePosition() }
        }
        private var _position: CGPoint = CGPoint.zero

        public var scaleXY: CGPoint {
            get { return _scaleXY }
            set { _scaleXY = newValue; _updateScale() }
        }
        private var _scaleXY: CGPoint = CGPoint.one

        public var scale: MZFloat {
            get { return MZFloat(_scaleXY.x) }
            set { scaleXY = CGPoint(x: MZFloat(newValue), y: MZFloat(newValue)); }
        }

        public var rotation: MZFloat {
            get { return _rotation }
            set { _rotation = newValue; _updateRotation(); _updatePosition() }
        }
        private var _rotation: MZFloat = 0.0

        public var nodeInfosDict : [String: NodeInfo] {
            get {
                return _nodeInfosDict
            }
        }

        public func addNewNodeInfo(#node: SKNode, name: String, settingAction: ((NodeInfo)->())? = nil) -> NodeInfo {
            var nodeInfo = NodeInfo()
            nodeInfo.node = node

            settingAction?(nodeInfo)

            _nodeInfosDict[name] = nodeInfo

            return nodeInfo
        }

        public func nodeInfoWithName(name: String) -> NodeInfo? {
            return _nodeInfosDict[name]
        }

        // TODO: not support now
//        public func removeNodeInfo(nodeInfo: NodeInfo) {
//
//        }

        public func removeNodeInfoWithName(name: String) {
            _nodeInfosDict.removeValueForKey(name)
        }

        // MARK: Private

        private var _nodeInfosDict: [String: NodeInfo] = [String: NodeInfo]()

        deinit {
            _nodeInfosDict.removeAll(keepCapacity: false)
        }

        private func _updatePosition() {
            for (name, nodeInfo) in _nodeInfosDict {
                if nodeInfo.node == nil { continue }

                var offset = CGVector(
                    dx: nodeInfo.originPosition.x * _scaleXY.x,
                    dy: nodeInfo.originPosition.y * _scaleXY.y
                )

                let resultRot = nodeInfo.node!.zRotation;

                let resultOffset = offset.mapToRadians(resultRot)

                var resultPos = _position + resultOffset.toCGPoint()

                nodeInfo.node!.position = resultPos;
            }
        }

        private func _updateScale() {
            for (name, nodeInfo) in _nodeInfosDict {
                if nodeInfo.node == nil { continue }

                nodeInfo.node!.xScale = nodeInfo.originScaleXY.x * _scaleXY.x
                nodeInfo.node!.yScale = nodeInfo.originScaleXY.y * _scaleXY.y
            }
        }

        private func _updateRotation() {
            for (name, nodeInfo) in _nodeInfosDict {
                if nodeInfo.node == nil { continue }
                var rot = MZ.Maths.radiansFromDegrees(nodeInfo.originRotation + _rotation)
                nodeInfo.node!.zRotation = CGFloat(rot);
            }
        }
    }



    @objc public class NodeInfo: MZPTransform {

        public weak var node: SKNode? {
            get { return _node }
            set {
                if _node != nil {
                    _node!.returnToPool()
                }
                _node = newValue
            }
        }
        private weak var _node: SKNode?

        public var position: CGPoint {
            get { return node!.position }
            set { MZ.assertAlwayFalse("do't set me, use origin") }
        }

        public var scaleXY: CGPoint {
            get { return CGPoint(x: node!.xScale, y: node!.yScale) }
            set { MZ.assertAlwayFalse("do't set me, use origin") }
        }

        public var scale: MZFloat  {
            get { return MZFloat(node!.xScale) }
            set { MZ.assertAlwayFalse("do't set me, use origin") }
        }

        public var rotation: MZFloat {
            get { return MZ.Maths.degreesFromRadians(MZFloat(node!.zRotation)) }
            set { MZ.assertAlwayFalse("do't set me, use origin") }
        }

        public var originPosition: CGPoint = CGPoint.zero

        public var originScaleXY: CGPoint = CGPoint.one

        public var originScale: MZFloat {
            get { return MZFloat(originScaleXY.x) }
            set { originScaleXY.x = CGFloat(newValue) }
        }

        public var originRotation: MZFloat = 0.0

        deinit {
            _node?.remove()
            _node = nil
        }
    }
}
