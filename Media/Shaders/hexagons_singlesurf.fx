// use regular or irregular hexagons. Regular hexagons look better and work faster.
#define USE_REGULAR_HEXAGONS

float4x4		worldViewProjMatrix	: MATRIX_WORLDVIEWPROJ;
float4x4		worldMatrix			: MATRIX_WORLD;

const float4 clipPoint;

// Input VS structure
struct VSInput
{
   float4 position  : POSITION0;
   float3 texCoords : TEXCOORD0;
};

// Output VS structure
struct VSOutput
{
	float4 position  : POSITION0;	
	float3 normal    : TEXCOORD0;
};

// Vertex shader for hardware instancing
void VSMain(in VSInput IN, out VSOutput OUT)
{
#ifdef USE_REGULAR_HEXAGONS
	float4 position = float4(IN.position.xy - IN.texCoords.xy, IN.position.zw);
	float dist = distance(mul(position, worldMatrix), clipPoint.xyz) - clipPoint.w;
#else
	float dist = distance(mul(IN.position, worldMatrix), clipPoint.xyz) - clipPoint.w;
#endif
	dist = 1.0f - clamp(dist / abs(clipPoint.w), 0.0f, 1.0f);
	float3 offset = mul(float3(IN.texCoords.xy, 0.0f) * dist, worldViewProjMatrix);
	OUT.position  = mul(IN.position, worldViewProjMatrix) - float4(offset, 0.0f);
	OUT.normal    = normalize(float3(IN.texCoords.xy, 0.0f)) * 0.5 + 0.5;
	OUT.normal.z  = IN.texCoords.z;	// pack W-coordinate of the texture into the Z-coordinate of the normal
	OUT.normal.z  = length(normalize(IN.texCoords.xy));
}

// Pixel shaders
float4 PSMain(in VSOutput IN) : COLOR
{	
	return float4(IN.normal, 1.0f);
}

//  Techniques
technique Main
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