// view * projection matrix
float4x4 viewProjMatrix : MATRIX_VIEWPROJ;

// texture matrix
float4x4 textureMatrix : MATRIX_TEXTURE0;

// entity diffuse texture
texture diffuseTexture : TEXTURE_0;

// texture filtering
int filtering       : TEXTURE_FILTERING;
int anisotropyLevel : ANISOTROPY_LEVEL;

// light data
float4 lightColor     : LIGHT0_COLOR;
float3 lightDirection : LIGHT0_DIRECTION;
float4 ambientColor   : COLOR_AMBIENT;

// instansing data
float4 instances[200] : INSTANCES_ARRAY;

// entity diffuse sampler
sampler samplerDiffuse = sampler_state
{
    Texture       = <diffuseTexture>;
    ADDRESSU      = WRAP;
    ADDRESSV      = WRAP;
    ADDRESSW      = WRAP;
    MAGFILTER     = filtering;
    MINFILTER     = filtering;
    MIPFILTER     = filtering;
	MAXANISOTROPY = anisotropyLevel;
};

// Input VS structure
struct VSInput
{
   float4 position  : POSITION0;
   float2 texCoords : TEXCOORD0;
   float3 normal    : NORMAL;
   float4 indices   : BLENDWEIGHT;
};

// Output VS structure
struct VSOutput
{
	float4 position  : POSITION0;
	float2 texCoords : TEXCOORD0;
	float3 normal    : TEXCOORD1;
};

// vertex shader
void VSMain(in VSInput IN, out VSOutput OUT)
{
	// restore world matrix for instance
	float4x4 worldMatrix;
	int index      = IN.indices.x;
	worldMatrix[0] = float4(instances[index * 4 + 0].x, instances[index * 4 + 1].x, instances[index * 4 + 2].x, 0.0f);
	worldMatrix[1] = float4(instances[index * 4 + 0].y, instances[index * 4 + 1].y, instances[index * 4 + 2].y, 0.0f);
	worldMatrix[2] = float4(instances[index * 4 + 0].z, instances[index * 4 + 1].z, instances[index * 4 + 2].z, 0.0f);
	worldMatrix[3] = float4(instances[index * 4 + 0].w, instances[index * 4 + 1].w, instances[index * 4 + 2].w, 1.0f);
	// transform position
	OUT.position  = mul(IN.position,  worldMatrix);
	OUT.position  = mul(OUT.position, viewProjMatrix);
	OUT.normal    = normalize(mul(IN.normal, worldMatrix));
	OUT.texCoords = mul(IN.texCoords, textureMatrix);
}

// Pixel shaders
float4 PSMain(in VSOutput IN) : COLOR
{
	float4 diffuse = tex2D(samplerDiffuse, IN.texCoords);
	float4 result  = ambientColor * diffuse + (diffuse * dot(IN.normal, -lightDirection) * lightColor);
	return float4(result.xyz, diffuse.w);
}

//  Techniques
technique Instancing
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSMain();
		PixelShader      = compile ps_2_0 PSMain();
	}
}