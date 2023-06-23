
import MetalKit
//The Model class represents a 3D model in the scene. It extends the functionality of the Node class and adds additional properties and methods specific to rendering a model using Metal.

class Model: Node {
//pipelineState: A MTLRenderPipelineState object representing the render pipeline state used for rendering the model.
//meshes: An array of Mesh objects representing the individual meshes that make up the model.

  let pipelineState: MTLRenderPipelineState
  let meshes: [Mesh]
    
//    The initializer takes a name parameter, which is used to load the model asset from the app's bundle.
//    It creates a MTKMeshBufferAllocator for allocating mesh buffers on the Metal device.
//    It loads the model asset using MDLAsset and converts it into MetalKit meshes using MTKMesh.newMeshes(asset:device:).
//    The MetalKit meshes are then used to create Mesh objects, which encapsulate the rendering data for each mesh.
//    The render pipeline state is built by invoking the buildPipelineState() method.
//    The name of the model is set, and the super.init() is called to initialize the parent Node class.
  
  init(name: String) {
    guard
      let assetUrl = Bundle.main.url(forResource: name, withExtension: nil) else {
        fatalError("Model: \(name) not found")
    }
    let allocator = MTKMeshBufferAllocator(device: Renderer.device)
    let asset = MDLAsset(url: assetUrl,
                         vertexDescriptor: MDLVertexDescriptor.defaultVertexDescriptor,
                         bufferAllocator: allocator)
    let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset,
                                                        device: Renderer.device)
    meshes = zip(mdlMeshes, mtkMeshes).map {
      Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
    }
    pipelineState = Model.buildPipelineState()
    super.init()
    self.name = name
  }
  
  private static func buildPipelineState() -> MTLRenderPipelineState {
      
//      This method is responsible for creating and configuring the render pipeline state used for rendering the model.
//      It retrieves the Metal library from the Renderer class.
//      It obtains the vertex and fragment shader functions from the library.
//      It creates a MTLRenderPipelineDescriptor object and sets the vertex and fragment functions.
//      The vertex descriptor is obtained from MDLVertexDescriptor.defaultVertexDescriptor and converted to a MetalKit-compatible descriptor.
//      The pixel format for the color attachment is set to .bgra8Unorm.
//      Finally, the render pipeline state is created by calling makeRenderPipelineState(descriptor:) on the Metal device.
    let library = Renderer.library
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction = library?.makeFunction(name: "fragment_main")
    
    var pipelineState: MTLRenderPipelineState
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    let vertexDescriptor = MDLVertexDescriptor.defaultVertexDescriptor
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(vertexDescriptor)
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    do {
      pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return pipelineState
  }
}



