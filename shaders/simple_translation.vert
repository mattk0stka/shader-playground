in vec2 position;

void main() {
    vec2 translation = vec2(1.0, 0.0);
    gl_Position = vec4(position + translation, 0.0, 1.0);
}