#version 410

in vec2 position;
in vec3 barycentric; // NEW: Barycentric coordinate per vertex

out vec3 v_barycentric; // Pass to fragment shader

void main() {
  v_barycentric = barycentric;
  gl_Position = vec4(position, 0.0, 1.0);
}