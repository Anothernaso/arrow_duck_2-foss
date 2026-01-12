shader_type canvas_item;

uniform float speed : hint_range(0.0, 300.0) = 1.0; // Speed of the scrolling

void fragment() {
    // Get the texture coordinates
    vec2 uv = UV;

    // Calculate the horizontal offset for scrolling
    uv.x += TIME * speed * 0.01; // Adjust the scaling factor to control the speed

    // Wrap the texture coordinates to create a seamless scrolling effect
    uv.x = mod(uv.x, 1.0);

    // Sample the texture using the built-in TEXTURE variable
    vec4 texColor = texture(TEXTURE, uv);

    // Output the final color
    COLOR = texColor;
}
