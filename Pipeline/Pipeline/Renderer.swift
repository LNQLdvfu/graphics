
import MetalKit

class Renderer: NSObject {

  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  var mesh: MTKMesh!
  var vertexBuffer: MTLBuffer!
  var pipelineState: MTLRenderPipelineState!
  var timer: Float = 0
    
//MTLDevice: The software reference to the GPU hardware device.
// MTLCommandQueue: Responsible for creating and organizing MTLCommandBuf f ers every frame.
// MTLLibrary: Contains the source code from your vertex and fragment shader functions.
// MTLRenderPipelineState: Sets the information for the draw — such as which shader functions to use, what depth and color settings to use and how to read the vertex data.
// MTLBuffer: Holds data — such as vertex information — in a form that you can send to the GPU.

  init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
      
//     Still in Renderer.swift, add the following code to init (metalView:) before super.init():
//      This code initializes the GPU and creates the command queue.
    Renderer.device = device
    Renderer.commandQueue = commandQueue
    metalView.device = device
      
//      created a sphere and a cone using Model I/O; now it’s time to create a cube.
//      > In init(metalView:), before calling super. init(), add this:
    
    let mdlMesh = Primitive.makeCube(device: device, size: 1)
    do {
      mesh = try MTKMesh(mesh: mdlMesh, device: device)
    } catch let error {
      print(error.localizedDescription)
    }
//      Then, set up the MTLBuf f e r that contains the vertex data you’ll send to the GPU.
    vertexBuffer = mesh.vertexBuffers[0].buffer
      
//      set up the MTLLibrary and ensure that the vertex and fragment shader functions are present.
//      > Continue adding code before super, init():

    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction = library?.makeFunction(name: "fragment_main")
      
//      To configure the GPU’s state, you create a pipeline state object (PSO). This pipeline state can be a render pipeline state for rendering vertices, or a compute pipeline state for running a compute kernel.
//      >- Continue adding code before super, in it ():

    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.vertexDescriptor =
      MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
    pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
    do {
      pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
      
//      > Finally, after super, init(), add this:
    
    super.init()
    metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0,
                                         blue: 0.8, alpha: 1.0)
    metalView.delegate = self
  }
}

extension Renderer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
  }
    
  
  func draw(in view: MTKView) {
//      MTKView calls draw(in:) for every frame; this is where you’ll set up your GPU render commands.
//      > In draw(in:), replace the print statement with this:
    guard
      let descriptor = view.currentRenderPassDescriptor,
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let renderEncoder =
      commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
        return
    }
    
    // 1
    timer += 0.05
    var currentTime = sin(timer)
    // 2
    renderEncoder.setVertexBytes(&currentTime,
                                 length: MemoryLayout<Float>.stride,
                                 index: 1)
      
//      It’s time to set up the list of commands that the GPU will need to draw your frame. In other words, you’ll:
//      • Set the pipeline state to configure the GPU hardware.
//      • Give the GPU the vertex data.
//      • Issue a draw call using the mesh’s submesh groups.

    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    for submesh in mesh.submeshes {
      renderEncoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: submesh.indexCount,
                                          indexType: submesh.indexType,
                                          indexBuffer: submesh.indexBuffer.buffer,
                                          indexBufferOffset: submesh.indexBuffer.offset)
    }
    
    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
