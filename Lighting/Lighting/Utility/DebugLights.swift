

import MetalKit

// debug drawing
extension Renderer {
//   buildLightPipelineState(): This method creates a render pipeline state for rendering lights. It retrieves the default library from the Metal device, creates vertex and fragment functions named "vertex_light" and "fragment_light" respectively, and sets them in a render pipeline descriptor. It also specifies the pixel format for the color attachment and the depth attachment pixel format. Finally, it creates and returns the render pipeline state.
  
  func buildLightPipelineState() -> MTLRenderPipelineState {
    let library = Renderer.device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "vertex_light")
    let fragmentFunction = library?.makeFunction(name: "fragment_light")
    
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
    let lightPipelineState: MTLRenderPipelineState
    do {
      lightPipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return lightPipelineState
  }
  
//    uncomment when you have defined `lights`
  
//  func debugLights(renderEncoder: MTLRenderCommandEncoder, lightType: LightType) {
//    for light in lights where light.type == lightType {
//      switch light.type {
//      case Pointlight:
//        drawPointLight(renderEncoder: renderEncoder, position: light.position,
//                       color: light.color)
//      case Spotlight:
//        drawPointLight(renderEncoder: renderEncoder, position: light.position,
//                       color: light.color)
//
////        leave this commented until you define spotlights
//        drawSpotLight(renderEncoder: renderEncoder, position: light.position,
//                      direction: light.coneDirection, color: light.color)
//      case Sunlight:
//        drawDirectionalLight(renderEncoder: renderEncoder, direction: light.position,
//                             color: [1, 0, 0], count: 5)
//      default:
//        break
//      }
//    }
//  }
//
  
//    drawPointLight(renderEncoder:position:color:): This method draws a point light in the debug mode. It takes a render encoder, a position vector, and a color vector as parameters. The method creates an array of vertices containing only the position vector. It then creates a buffer using the vertex data, sets the necessary uniforms and fragment parameters, and configures the render encoder with the appropriate vertex buffer, render pipeline state, and primitive type. Finally, it draws the primitives.
  func drawPointLight(renderEncoder: MTLRenderCommandEncoder, position: float3, color: float3) {
    var vertices = [position]
    let buffer = Renderer.device.makeBuffer(bytes: &vertices,
                                            length: MemoryLayout<float3>.stride * vertices.count,
                                            options: [])
    uniforms.modelMatrix = float4x4.identity()
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride, index: 1)
    var lightColor = color
    renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<float3>.stride, index: 1)
    renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
    renderEncoder.setRenderPipelineState(lightPipelineState)
    renderEncoder.drawPrimitives(type: .point, vertexStart: 0,
                                 vertexCount: vertices.count)
    
  }
  
//    drawDirectionalLight(renderEncoder:direction:color:count:): This method draws a directional light in the debug mode. It takes a render encoder, a direction vector, a color vector, and a count as parameters. The count parameter specifies the number of lines to draw for the directional light. The method generates the vertices for the lines based on the direction vector and count. It creates a buffer using the vertex data, sets the uniforms and fragment parameters, and configures the render encoder with the vertex buffer, render pipeline state, and primitive type. Finally, it draws the primitives.
  func drawDirectionalLight (renderEncoder: MTLRenderCommandEncoder,
                             direction: float3,
                             color: float3, count: Int) {
    var vertices: [float3] = []
    for i in -count..<count {
      let value = Float(i) * 0.4
      vertices.append(float3(value, 0, value))
      vertices.append(float3(direction.x+value, direction.y, direction.z+value))
    }

    let buffer = Renderer.device.makeBuffer(bytes: &vertices,
                                            length: MemoryLayout<float3>.stride * vertices.count,
                                            options: [])
    uniforms.modelMatrix = float4x4.identity()
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride, index: 1)
    var lightColor = color
    renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<float3>.stride, index: 1)
    renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
    renderEncoder.setRenderPipelineState(lightPipelineState)
    renderEncoder.drawPrimitives(type: .line, vertexStart: 0,
                                 vertexCount: vertices.count)
    
  }
//    drawSpotLight(renderEncoder:position:direction:color:): This method draws a spot light in the debug mode. It takes a render encoder, a position vector, a direction vector, and a color vector as parameters. The method creates an array of vertices containing the position vector and a point offset by the direction vector from the position. It creates a buffer using the vertex data, sets the uniforms and fragment parameters, and configures the render encoder with the vertex buffer, render pipeline state, and primitive type. Finally, it draws the primitives.


  
  func drawSpotLight(renderEncoder: MTLRenderCommandEncoder, position: float3, direction: float3, color: float3) {
    var vertices: [float3] = []
    vertices.append(position)
    vertices.append(float3(position.x + direction.x, position.y + direction.y, position.z + direction.z))
    let buffer = Renderer.device.makeBuffer(bytes: &vertices,
                                            length: MemoryLayout<float3>.stride * vertices.count,
                                            options: [])
    uniforms.modelMatrix = float4x4.identity()
    renderEncoder.setVertexBytes(&uniforms,
                                 length: MemoryLayout<Uniforms>.stride, index: 1)
    var lightColor = color
    renderEncoder.setFragmentBytes(&lightColor, length: MemoryLayout<float3>.stride, index: 1)
    renderEncoder.setVertexBuffer(buffer, offset: 0, index: 0)
    renderEncoder.setRenderPipelineState(lightPipelineState)
    renderEncoder.drawPrimitives(type: .line, vertexStart: 0,
                                 vertexCount: vertices.count)
  }
  
  
}

