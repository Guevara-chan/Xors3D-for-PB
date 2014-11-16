// use regular or irregular hexagons. Regular hexagons look better and work faster.
#define USE_REGULAR_HEXAGONS

// view * projection matrix
float4x4 viewProjMatrix : MATRIX_VIEWPROJ;

const float4 clipPoint;

// Input VS structure
struct VSInput
{
   float4 position  : POSITION0;
   float2 texCoords : TEXCOORD0;
   float4 matrixC1  : TEXCOORD2;
   float4 matrixC2  : TEXCOORD3;
   float4 matrixC3  : TEXCOORD4;
};

// Output VS structure
struct VSOutput
{
	float4 position  : POSITION0;
	float3 normal    : TEXCOORD2;
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
#ifdef USE_REGULAR_HEXAGONS
	float dist = distance(mul(float4(0.0f, 0.0f, 0.0f, 1.0f), worldMatrix), clipPoint.xyz) - clipPoint.w;
#else
	float dist = distance(mul(IN.position, worldMatrix), clipPoint.xyz) - clipPoint.w;
#endif
	dist = clamp(dist / abs(clipPoint.w), 0.0f, 1.0f);
	float4 position = float4(IN.position.xy * dist, IN.position.zw);
	OUT.position  = mul(position, worldMatrix);
	OUT.position  = mul(OUT.position, viewProjMatrix);
	OUT.normal.rg    = normalize(IN.position.xy) * 0.5 + 0.5;
	OUT.normal.b  = length(normalize(IN.position.xy));
}

// Pixel shaders
float4 PSMain(in VSOutput IN) : COLOR
{
	return float4(IN.normal, 1.0f);
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