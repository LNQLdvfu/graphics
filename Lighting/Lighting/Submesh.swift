

import MetalKit

//The Submesh class represents a submesh, which is a distinct part of a larger mesh. It encapsulates the MetalKit submesh (MTKSubmesh) associated with the submesh.

class Submesh {
//    mtkSubmesh: A MTKSubmesh object representing the MetalKit submesh.
  var mtkSubmesh: MTKSubmesh
//  The initializer takes an MDLSubmesh object (mdlSubmesh) and its corresponding MTKSubmesh object (mtkSubmesh) as parameters.
//    It assigns the mtkSubmesh parameter to the mtkSubmesh property.
  init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
    self.mtkSubmesh = mtkSubmesh
  }
}
//The Submesh class provides a container for the submesh data and allows access to the MetalKit submesh for rendering purposes or other operations related to the submesh.
