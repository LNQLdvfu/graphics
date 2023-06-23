


#include <metal_stdlib>
using namespace metal;
//1. Create a struct Vertexln to describe the vertex attributes that match the vertex descriptor you set up earlier. In this case, just position.
//2. Implement a vertex shader, vertex_main, that takes in Vertexln structs and returns vertex positions as f loat4 types.
struct VertexIn {
  float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertexIn [[ stage_in ]],
                          constant float &timer [[ buffer(1) ]]) {
  float4 position = vertexIn.position;
  position.y += timer;
  return position;
}


//This is the simplest fragment function possible.  return the interpolated color red in the form of a f loat4. All the fragments that make up the cube will be red. The GPU takes the fragments and does a series of post-processing tests:
//• alpha-testing determines which opaque objects are drawn (and which are not) based on depth testing.
//• In the case of translucent objects, alpha-blending will combine the color of the new object with that already saved in the color buffer previously.
//• scissor testing checks whether a fragment is inside of a specified rectangle; this test is useful for masked rendering.
//• stencil testing checks how the stencil value in the framebuffer where the fragment is stored, compares to a specified value we choose.
//•  now a late-Z testing is done to solve more visibility issues; stencil and depth tests are also useful for ambient occlusion and shadows.
//• Finally, antialiasing is also calculated here so that final images that get to the screen do not look jagged.


fragment float4 fragment_main() {
  return float4(1, 0, 0, 1);
}

