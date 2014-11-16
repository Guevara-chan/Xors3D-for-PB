// view * projection matrix
const float4x4 viewProjMatrix : MATRIX_VIEWPROJ;
const float3   lightDir       : LIGHT0_DIRECTION;
const float3   lightColor = float3(0.2f, 0.5f, 1.0f);
const float4   uvShift; // .x - 0-th set, .y - 1-th set

const texture  side0Texture : TEXTURE_0;
const texture  side1Texture : TEXTURE_1;

sampler side0Sampler = sampler_state
{
    Texture       = <side0Texture>;
    ADDRESSU      = CLAMP;
    ADDRESSV      = CLAMP;
    ADDRESSW      = CLAMP;
    MAGFILTER     = LINEAR;
    MINFILTER     = LINEAR;
    MIPFILTER     = LINEAR;
};

sampler side1Sampler = sampler_state
{
    Texture       = <side1Texture>;
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
   float3 normal    : NORMAL;
};

// Output VS structure
struct VSOutput
{
	float4 position   : POSITION0;
	float2 texCoords0 : TEXCOORD0;
	float2 texCoords1 : TEXCOORD1;
	float4 diffColor  : TEXCOORD2;
	float3 normal     : TEXCOORD3;
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
	OUT.diffColor = IN.diffColor;
	OUT.normal    = IN.normal;
	
	float2 size = float2(1.0f / (IN.diffColor.b * 255.0f * 2.0f), 1.0f / (IN.diffColor.b * 255.0f));	
	IN.texCoords.y  = 1.0f - IN.texCoords.y;
	OUT.texCoords0 = abs(IN.texCoords - uvShift.x);
	OUT.texCoords1 = abs(IN.texCoords - uvShift.y);
	OUT.texCoords0   = (IN.diffColor.rg * 255.0f + OUT.texCoords0) * size;
	OUT.texCoords1   = (IN.diffColor.rg * 255.0f + OUT.texCoords1) * size;
	OUT.texCoords0.y = 1.0f - OUT.texCoords0.y;
	OUT.texCoords1.y = 1.0f - OUT.texCoords1.y;
}

// Pixel shaders
float4 PSMain(in VSOutput IN) : COLOR
{	
	float4 side0 = tex2D(side0Sampler, IN.texCoords0);
	float4 side1 = tex2D(side1Sampler, IN.texCoords1);
	float4 result = lerp(side0, side1, saturate(IN.normal.z));
	return result;
}

//  Techniques
technique Instancing
{
	pass p0
	{
		/*AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;*/
		AlphaBlendEnable = 0;
		CullMode         = CCW;
		VertexShader     = compile vs_3_0 VSMain();
		PixelShader      = compile ps_3_0 PSMain();
	}
}