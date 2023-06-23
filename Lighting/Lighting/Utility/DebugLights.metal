
#include <metal_stdlib>
using namespace metal;

#import "../Common.h"

//vertex_light: This function is the vertex shader responsible for transforming the input vertices and preparing the output for further processing. It takes two input buffers: vertices, which contains the vertex positions, and uniforms, which holds the uniform data including the projection matrix, view matrix, and model matrix. The id parameter represents the index of the vertex being processed.
//
//Inside the function, the model-view-projection (MVP) matrix is computed by multiplying the projection matrix, view matrix, and model matrix. The vertex position is transformed by the MVP matrix using matrix-vector multiplication. The resulting transformed position is stored in the position field of the VertexOut structure.
//
//Additionally, the point_size field is set to a constant value of 20.0, indicating the size of the point when rendering point lights.
//
//Finally, the function returns the VertexOut structure, which contains the transformed position and point size.
struct VertexOut {
  float4 position [[ position ]];
  float point_size [[ point_size ]];
};

vertex VertexOut vertex_light(constant float3 *vertices [[ buffer(0) ]],
                             constant Uniforms &uniforms [[ buffer(1) ]],
                              uint id [[vertex_id]])
{
  matrix_float4x4 mvp = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix;
  VertexOut out {
    .position = mvp * float4(vertices[id], 1),
    .point_size = 20.0
  };
  return out;
}

//fragment_light: This function is the fragment shader responsible for determining the color of each fragment (pixel) in the debug rendering. It takes the point parameter, which represents the normalized coordinates of the current fragment within the render target, and the color buffer, which holds the color information for the light being rendered.

//Inside the function, the distance between the current fragment and the center of the render target (float2(0.5, 0.5)) is calculated using the distance function. If the distance is greater than 0.5, indicating that the fragment is outside a specified radius, the discard_fragment() function is called to discard the fragment and prevent it from being rendered.
fragment float4 fragment_light(float2 point [[ point_coord]],
                               constant float3 &color [[ buffer(1) ]]) {
  float d = distance(point, float2(0.5, 0.5));
  if (d > 0.5) {
    discard_fragment();
  }
  return float4(color ,1);
}

