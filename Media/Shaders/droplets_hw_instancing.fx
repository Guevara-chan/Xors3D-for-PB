// view * projection matrix
float4x4 viewProjMatrix : MATRIX_VIEWPROJ;
texture diffuseTexture : TEXTURE_0;

sampler samplerDiffuse = sampler_state
{
    Texture       = <diffuseTexture>;
    ADDRESSU      = CLAMP;
    ADDRESSV      = CLAMP;
    ADDRESSW      = CLAMP;
    MAGFILTER     = LINEAR;
    MINFILTER     = LINEAR;
    MIPFILTER     = LINEAR;
};

// Input VS structure
struct VSInput
{
   float4 position  : POSITION0;
   float2 texCoords : TEXCOORD0;
   float4 matrixC1  : TEXCOORD2;
   float4 matrixC2  : TEXCOORD3;
   float4 matrixC3  : TEXCOORD4;
   float4 diffColor	: TEXCOORD5;
};

// Output VS structure
struct VSOutput
{
	float4 position  : POSITION0;
	float2 texCoords : TEXCOORD0;
	float4 diffColor : TEXCOORD1;
};

// Vertex shader for hardware instancing
void VSMain(in VSInput IN, out VSOutput OUT)
{
	// restore world matrix for instance
	float4x4 worldMatrix;
	worldMatrix[0] = float4(IN.matrixC1.x, IN.matrixC2.x, IN.matrixC3.x, 0.0f);
	worldMatrix[1] = float4(IN.matrixC1.y, IN.matrixC2.y, IN.matrixC3.y, 0.0f);
	worldMatrix[2] = float4(IN.matrixC1.z, IN.matrixC2.z, IN.matrixC3.z, 0.0f);
	worldMatrix[3] = float4(IN.matrixC1.w, IN.matrixC2.w, IN.matrixC3.w, 1.0f);
	// transform position	
	OUT.position  = mul(IN.position, worldMatrix);
	OUT.position  = mul(OUT.position, viewProjMatrix);
	OUT.texCoords = IN.texCoords;
	OUT.diffColor = IN.diffColor;
}

// Pixel shaders
float4 PSMain(in VSOutput IN) : COLOR
{
	float4 diffuse = tex2D(samplerDiffuse, IN.texCoords);
	diffuse.a *= IN.diffColor.a;
	return diffuse;
}

//  Techniques
technique Instancing
{
	pass p0
	{
		/*AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;*/
		AlphaBlendEnable = 1;
		SrcBlend = SrcAlpha;
		DestBlend = InvSrcAlpha;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSMain();
		PixelShader      = compile ps_2_0 PSMain();
	}
}