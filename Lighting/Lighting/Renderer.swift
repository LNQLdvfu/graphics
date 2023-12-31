

import MetalKit

class Renderer: NSObject {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!

  var uniforms = Uniforms()
  
  // Camera holds view and projection matrices
  lazy var camera: Camera = {
    let camera = ArcballCamera()
    camera.distance = 2
    camera.target = [0, 0.5, 0]
    camera.rotation.x = Float(-10).degreesToRadians
    return camera
  }()

  // Array of Models allows for rendering multiple models
  var models: [Model] = []
  
  // Debug drawing of lights
  lazy var lightPipelineState: MTLRenderPipelineState = {
    return buildLightPipelineState()
  }()

  
  init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
    Renderer.device = device
    Renderer.commandQueue = commandQueue
    Renderer.library = device.makeDefaultLibrary()
    metalView.device = device
    
    super.init()
    metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0,
                                         blue: 0.8, alpha: 1.0)
    metalView.delegate = self
    
    // add the model to the scene
    let train = Model(name: "train.obj")
    train.position = [0, 0, 0]
    train.rotation = [0, Float(45).degreesToRadians, 0]
    models.append(train)
    
    mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
  }
}

extension Renderer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    camera.aspect = Float(view.bounds.width)/Float(view.bounds.height)
  }
  
  func draw(in view: MTKView) {
    guard
      let descriptor = view.currentRenderPassDescriptor,
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let renderEncoder =
      commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
        return
    }
    
    uniforms.projectionMatrix = camera.projectionMatrix
    uniforms.viewMatrix = camera.viewMatrix
    
    // render all the models in the array
    for model in models {
      // model matrix now comes from the Model's superclass: Node
      uniforms.modelMatrix = model.modelMatrix
      
      renderEncoder.setVertexBytes(&uniforms,
                                   length: MemoryLayout<Uniforms>.stride, index: 1)
      
      renderEncoder.setRenderPipelineState(model.pipelineState)

      for mesh in model.meshes {
        let vertexBuffer = mesh.mtkMesh.vertexBuffers[0].buffer
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0,
                                      index: 0)

        for submesh in mesh.submeshes {
          let mtkSubmesh = submesh.mtkSubmesh
          renderEncoder.drawIndexedPrimitives(type: .triangle,
                                              indexCount: mtkSubmesh.indexCount,
                                              indexType: mtkSubmesh.indexType,
                                              indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                              indexBufferOffset: mtkSubmesh.indexBuffer.offset)
        }
      }
    }

    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
