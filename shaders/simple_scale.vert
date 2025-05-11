in vec2 position;

void main() {
    vec2 scale = vec2(1.5, 1.5);
    gl_Position = vec4((position * scale), 0.0, 1.0);
}
