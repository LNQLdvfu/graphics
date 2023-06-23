

import MetalKit
//makeCube(device:size:) that creates a cube-shaped MDLMesh object. Let's break down the code:
//
//The Primitive class is responsible for generating basic geometric shapes using Model I/O, which is a framework provided by Apple for working with 3D models.
//The makeCube(device:size:) method takes two parameters: device of type MTLDevice and size of type Float. It returns an MDLMesh object representing a cube.

class Primitive {
    
//    A MTKMeshBufferAllocator is created with the provided device. This allocator is used to allocate buffers for vertex and index data.
//    The MDLMesh initializer boxWithExtent:segments:inwardNormals:geometryType:allocator: is called to create a cube-shaped mesh. It takes the following parameters:
//    extent: An array of three Float values specifying the size of the cube in each dimension (width, height, depth).
//    segments: An array of three Int values specifying the number of subdivisions in each dimension.
//    inwardNormals: A Bool value indicating whether the cube's normals should point inward.
//    geometryType: A value of type MDLGeometryType specifying the type of geometry, which is .triangles in this case.
//    allocator: The mesh buffer allocator used to allocate buffers for the mesh.
  static func makeCube(device: MTLDevice, size: Float) -> MDLMesh {
    let allocator = MTKMeshBufferAllocator(device: device)
    let mesh = MDLMesh(boxWithExtent: [size, size, size],
                       segments: [1, 1, 1],
                       inwardNormals: false, geometryType: .triangles,
                       allocator: allocator)
    return mesh
  }
}
