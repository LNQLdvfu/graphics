

import MetalKit

class Node {
//    name: A string representing the name of the node. Default value is "untitled".
  var name: String = "untitled"
//    position: A float3 vector representing the position of the node in 3D space. Default value is [0, 0, 0].
  var position: float3 = [0, 0, 0]
//    rotation: A float3 vector representing the rotation angles (in radians) around the X, Y, and Z axes. Default value is [0, 0, 0].
  var rotation: float3 = [0, 0, 0]
//    scale: A float3 vector representing the scale factors along the X, Y, and Z axes. Default value is [1, 1, 1].
  var scale: float3 = [1, 1, 1]
  
//    The modelMatrix property is defined as a computed property of type float4x4.
  var modelMatrix: float4x4 {
//      translateMatrix is a float4x4 matrix representing the translation transformation based on the position property.
      
    let translateMatrix = float4x4(translation: position)
//      rotateMatrix is a float4x4 matrix representing the rotation transformation based on the rotation property.
    let rotateMatrix = float4x4(rotation: rotation)
//      scaleMatrix is a float4x4 matrix representing the scale transformation based on the scale property.
    let scaleMatrix = float4x4(scaling: scale)
//      The final model matrix is calculated by multiplying the three matrices in the order of translation, rotation, and scale.
    return translateMatrix * rotateMatrix * scaleMatrix
  }
}

