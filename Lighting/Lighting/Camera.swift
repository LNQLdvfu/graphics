

import Foundation

//The Camera class is defined as a subclass of Node.

class Camera: Node {
//  fovDegrees: A Float value representing the field of view in degrees. Default value is 70.
//fovRadians: A computed property that converts the fovDegrees value to radians using the degreesToRadians extension.
  var fovDegrees: Float = 70
  var fovRadians: Float {
    return fovDegrees.degreesToRadians
  }
    
//aspect: A Float value representing the aspect ratio of the camera. Default value is 1.
//near: A Float value representing the near clipping plane of the camera. Default value is 0.001.
//far: A Float value representing the far clipping plane of the camera. Default value is 100.
  var aspect: Float = 1
  var near: Float = 0.001
  var far: Float = 100
  
  
  var projectionMatrix: float4x4 {
//      The projectionMatrix property is a computed property of type float4x4.
//      It calculates the projection matrix of the camera using the projectionFov initializer of float4x4.
//      The fovRadians property is used as the field of view value.
//      The near, far, and aspect properties are used as parameters for the initializer.
    return float4x4(projectionFov: fovRadians,
                    near: near,
                    far: far,
                    aspect: aspect)
  }
  
  var viewMatrix: float4x4 {
      
//      The viewMatrix property is a computed property of type float4x4.
//      It calculates the view matrix of the camera by combining translation, rotation, and scale matrices.
//      The translation matrix is based on the position property inherited from Node.
//      The rotation matrix is based on the rotation property inherited from Node.
//      The scale matrix is based on the scale property inherited from Node.

    let translateMatrix = float4x4(translation: position)
    let rotateMatrix = float4x4(rotation: rotation)
    let scaleMatrix = float4x4(scaling: scale)
    return (translateMatrix * scaleMatrix * rotateMatrix).inverse
  }
    //      The final view matrix is calculated by multiplying the three matrices in the order of translation, scale, and rotation.
    //      The zoom(delta:) and rotate(delta:) methods are empty placeholders that can be overridden in subclasses.
  func zoom(delta: Float) {}
  func rotate(delta: float2) {}
}

//The ArcballCamera class is defined as a subclass of Camera.
//It introduces additional properties and behavior specific to an arcball-style camera control.
class ArcballCamera: Camera {
    
//    minDistance and maxDistance: Float values representing the minimum and maximum distance from the camera to the target point. Default values are 0.5 and 10, respectively.
//    target: A float3 vector representing the target point that the camera looks at. Default value is [0, 0, 0].
//    distance: A Float value representing the distance between the camera and the target point. Default value is 0.
  
  var minDistance: Float = 0.5
  var maxDistance: Float = 10
  var target: float3 = [0, 0, 0] {
    didSet {
      _viewMatrix = updateViewMatrix()
    }
  }
  
  var distance: Float = 0 {
    didSet {
      _viewMatrix = updateViewMatrix()
    }
  }
  
  override var rotation: float3 {
    didSet {
      _viewMatrix = updateViewMatrix()
    }
  }
//    The _viewMatrix property is a private variable that stores the cached view matrix for efficiency.
  override var viewMatrix: float4x4 {
    return _viewMatrix
  }
    
  private var _viewMatrix = float4x4.identity()
  
  override init() {
    super.init()
    _viewMatrix = updateViewMatrix()
  }
//  The initializer overrides the superclass initializer and calls updateViewMatrix() to set the initial view matrix.
  private func updateViewMatrix() -> float4x4 {
//      The updateViewMatrix() method calculates the view matrix based on the current target, distance, and rotation values.
//      It uses translation and rotation matrices to position the camera relative to the target point.
//      The resulting matrix is inverted to obtain the correct view matrix.
//      The position of the camera is updated based on the rotation and the translation matrix.
    let translateMatrix = float4x4(translation: [target.x, target.y, target.z - distance])
    let rotateMatrix = float4x4(rotationYXZ: [-rotation.x,
                                              rotation.y,
                                              0])
    let matrix = (rotateMatrix * translateMatrix).inverse
    position = rotateMatrix.upperLeft * -matrix.columns.3.xyz
    return matrix
  }
  
  override func zoom(delta: Float) {
      
//      The zoom(delta:) method adjusts the distance property based on the provided delta value.
//      The sensitivity is set to control the zoom speed.
//      The view matrix is updated after adjusting the distance.

    let sensitivity: Float = 0.05
    distance -= delta * sensitivity
    _viewMatrix = updateViewMatrix()
  }
  
  override func rotate(delta: float2) {
      
//      The sensitivity is set to control the rotation speed.
//      The rotation property is updated based on the delta values multiplied by the sensitivity.
//      The rotation angles are clamped between -π/2 and π/2 to limit the vertical rotation.
//      The view matrix is updated after adjusting the rotation.
    let sensitivity: Float = 0.005
    rotation.y += delta.x * sensitivity
    rotation.x += delta.y * sensitivity
    rotation.x = max(-Float.pi/2,
                     min(rotation.x,
                         Float.pi/2))
    _viewMatrix = updateViewMatrix()
  }
}
