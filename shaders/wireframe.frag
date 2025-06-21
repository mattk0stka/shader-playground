#version 410

in vec3 v_barycentric;
out vec4 frag_color;

float edgeFactor(vec3 bary) {
  vec3 d = fwidth(bary); // Derivative for smooth edges
  vec3 a3 = smoothstep(vec3(0.0), d * 1.5, bary);
  return min(min(a3.x, a3.y), a3.z);
}

void main() {
  float edge = edgeFactor(v_barycentric);
  vec3 bg_color = vec3(1.0);
  frag_color = vec4(vec3(1.0 - edge), 1.0); // white lines
}