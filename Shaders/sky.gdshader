shader_type sky;
uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;
void sky() {
    float gradientFactor = clamp(EYEDIR.y / 0.25, 0.7, 0.9);
    vec3 finalColor = mix(horizonColor, skyColor, gradientFactor);
    COLOR = finalColor;
}