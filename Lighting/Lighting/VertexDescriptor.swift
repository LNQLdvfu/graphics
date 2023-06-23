

import ModelIO

//It defines a static computed property defaultVertexDescriptor using a closure.
//Inside the closure, it creates an instance of MDLVertexDescriptor.
//It initializes the offset variable to 0, which will be used to keep track of the attribute offsets.
//It adds the first attribute for position using MDLVertexAttribute. The attribute has a name (MDLVertexAttributePosition), format (.float3), offset (0), and buffer index (0). The offset variable is updated to the stride of float3 to ensure proper alignment.
//It leaves a placeholder comment for adding the normal attribute. This indicates that the code is expected to include additional code to define the normal attribute.
//Finally, it sets the vertex descriptor's layout at index 0 using MDLVertexBufferLayout, passing the calculated stride as the parameter.

extension MDLVertexDescriptor {
  static var defaultVertexDescriptor: MDLVertexDescriptor = {
    let vertexDescriptor = MDLVertexDescriptor()
    var offset = 0
    vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                        format: .float3,
                                                        offset: 0, bufferIndex: 0)
    offset += MemoryLayout<float3>.stride
    
    // add the normal attribute here

    vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: offset)
    return vertexDescriptor
  }()
}

