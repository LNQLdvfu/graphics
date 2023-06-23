

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
  float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertexIn [[ stage_in ]],
                          constant float &timer [[ buffer(1) ]]) {
    
//     the vertex position is directly assigned to position. Additionally, the timer value, accessed from a constant buffer using constant float &timer, is added to the x component of the position.
  float4 position = vertexIn.position;
  position.x += timer;
  return position;
}

fragment float4 fragment_main() {
  return float4(0, 0, 1, 1);
}

