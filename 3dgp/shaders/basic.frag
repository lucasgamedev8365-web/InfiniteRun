#version 330

// Input Variables (received from Vertex Shader)
in vec4 color;
in vec4 position;
in vec3 normal;

// Output Variable (sent down through the Pipeline)
out vec4 outColor;

uniform sampler2D texture0;
in vec2 texCoord0;

uniform vec3 fogColour;
in float fogFactor;

void main(void) 
{
	outColor = color;
	outColor *= texture(texture0, texCoord0);
	outColor = mix(vec4(fogColour, 1), outColor, fogFactor);
}
