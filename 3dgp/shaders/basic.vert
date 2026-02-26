#version 330

// Bone Transforms
#define MAX_BONES 100
uniform mat4 bones[MAX_BONES];

// Uniforms: Transformation Matrices
uniform mat4 matrixProjection;
uniform mat4 matrixView;
uniform mat4 matrixModelView;

// Uniforms: Material Colours
uniform vec3 materialAmbient;
uniform vec3 materialDiffuse;
uniform float fogDensity;

in vec3 aVertex;
in vec3 aNormal;
in vec2 aTexCoord;
in vec4 aBoneId;
in vec4 aBoneWeight;

out vec4 color;
out vec4 position;
out vec3 normal;
out vec2 texCoord0;
out float fogFactor;

// Light declarations
struct AMBIENT
{	
	vec3 color;
};
uniform AMBIENT lightAmbient;

struct DIRECTIONAL
{	
	vec3 direction;
	vec3 diffuse;
};
uniform DIRECTIONAL lightDir1, lightDir2;

vec4 AmbientLight(AMBIENT light)
{
	// Calculate Ambient Light
	return vec4(materialAmbient * light.color, 1);
}

vec4 DirectionalLight(DIRECTIONAL light)
{
	// Calculate Directional Light
	vec4 color = vec4(0, 0, 0, 0);
	vec3 L = normalize(mat3(matrixView) * light.direction);
	float NdotL = dot(normal, L);
	color += vec4(materialDiffuse * light.diffuse, 1) * max(NdotL, 0);
	return color;
}

void main(void) 
{
	mat4 matrixBone;
	if (aBoneWeight[0] == 0.0)
	{
		matrixBone = mat4(1);
	}
	else
	{
		matrixBone = (bones[int(aBoneId[0])] * aBoneWeight[0] +
					  bones[int(aBoneId[1])] * aBoneWeight[1] +
					  bones[int(aBoneId[2])] * aBoneWeight[2] +
					  bones[int(aBoneId[3])] * aBoneWeight[3]);
	}
		

	// calculate position
	position = matrixModelView * matrixBone * vec4(aVertex, 1.0);
	gl_Position = matrixProjection * position;

	// calculate normal
	normal = normalize(mat3(matrixModelView) * mat3(matrixBone) * aNormal);

	// calculate texture coordinate
	texCoord0 = aTexCoord;

	fogFactor = exp2(-fogDensity * length(position)); // fog factor

	// calculate light
	color = vec4(0, 0, 0, 1);
	color += AmbientLight(lightAmbient);
	color += DirectionalLight(lightDir1);
	color += DirectionalLight(lightDir2);
}
