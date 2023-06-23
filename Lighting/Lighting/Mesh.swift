

import MetalKit
//The Mesh struct represents a single mesh within a 3D model. It contains the MetalKit mesh (MTKMesh) and an array of Submesh objects that define the individual parts or subregions of the mesh.


struct Mesh {
    
//mtkMesh: A MTKMesh object representing the MetalKit mesh.
//submeshes: An array of Submesh objects representing the submeshes or subregions of the mesh.
  let mtkMesh: MTKMesh
  let submeshes: [Submesh]
  
  init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) {
      
//      The initializer takes an MDLMesh object (mdlMesh) and its corresponding MTKMesh object (mtkMesh) as parameters.
//      It assigns the mtkMesh parameter to the mtkMesh property.
//      It maps over the zipped arrays of mdlMesh.submeshes and mtkMesh.submeshes to create Submesh objects.
//      Each pair of corresponding MDLSubmesh and MTKSubmesh objects is used to initialize a Submesh object.
//      The resulting Submesh objects are assigned to the submeshes property.
    self.mtkMesh = mtkMesh
    submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map { mesh in
      Submesh(mdlSubmesh: mesh.0 as! MDLSubmesh, mtkSubmesh: mesh.1)
    }
  }
}
