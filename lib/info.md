#### Infos

`enableRenderTargetUsage`

> Enable using this texture as a render pass attachment.

A Texture is stored in GPU memory. Normally, it's used for reading (sampling).
A render pass attachment is a target (such as a texture or framebuffer) that the GPU writes to during rendering.
-> Allow the GPU to write rendering output into this texture, not just read from it.
Essential for things like:
- offscreen rendering
- post-processing effects (blur,  **shadows**)
- layer caching in flutter
- shadow mapping, reflections