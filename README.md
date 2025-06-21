# shader-playground

```bash
~/Projects/flutter/bin/flutter run -d macos --enable-impeller
```

### Triangle
![alt text for screen readers](/screenshot/Screenshot%202025-05-03%20at%2022.54.27.png "Example")


### Cube
![alt text for screen readers](/screenshot/Screenshot%202025-05-04%20at%2000.14.54.png "Cube")


### 3D Engine base on Impeller 

![alt text for screen readers](/screenshot/screen_recording.gif "3D Cuboid")



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