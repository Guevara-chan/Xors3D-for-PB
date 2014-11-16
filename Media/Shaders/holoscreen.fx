#define USE_CHROMATIC_ABERRATION

const float4x4 worldViewProj  : MATRIX_WORLDVIEWPROJ;
const float time              : CURRENT_TIME;
const float4 diffColor        : COLOR_DIFFUSE;

const float speed   = 0.05;
const int scanlines = 128;
const float intensityPow = 0.075f;

texture MainTex_ : TEXTURE_0;
sampler MainTex = sampler_state 
{
    texture   = <MainTex_>;
	AddressU  = BORDER;
    AddressV  = BORDER;    
	BorderColor = 0;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

texture NoiseTex_ : TEXTURE_1;
sampler NoiseTex = sampler_state 
{
    texture   = <NoiseTex_>;    
	AddressU  = WRAP;
    AddressV  = WRAP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

struct vertexInput {
    float3 position   : POSITION;    
    float4 uv         : TEXCOORD0;
};

struct vertexOutput {
    float4 position   : POSITION;    
    float4 uv         : TEXCOORD0;
};

vertexOutput VS(vertexInput IN) 
{
	vertexOutput OUT;
	OUT.position = mul(float4(IN.position, 1.0f), worldViewProj);
	OUT.uv       = IN.uv;
	return OUT;
}

float4 PS( vertexOutput IN): COLOR0
{
	float2 uv = IN.uv;
	float noise = tex2D(NoiseTex, uv.yy * 4.0f - time * speed * 8).r;
	float4 color = float4(0.0f, 0.0f, 0.0f, 0.0f);
	#ifdef USE_CHROMATIC_ABERRATION
		color.a = tex2D(MainTex, uv).a;
		color.r = tex2D(MainTex, uv + float2(0.0f, 0.011f) * noise).r;
		color.g = tex2D(MainTex, uv + float2(-0.01f, 0.0f) * cos(time * 2) * noise).g;
		color.b = tex2D(MainTex, uv + float2(0.01f, 0.0f) * sin(time * 5) * noise).b;
	#else
		color = tex2D(MainTex, uv + float2(0.01f, 0.0025f) * noise);
	#endif
	float scan = (abs((time * speed) - IN.uv.y) % 1 * scanlines);
	float intensity = (scan % 2) * intensityPow + (1.0f - intensityPow);
	return color * intensity * diffColor;
}


technique Holoscreen
{
	pass
    {      
      VertexShader = compile vs_3_0 VS();
      PixelShader  = compile ps_3_0 PS();
      AlphaBlendEnable = true;
	  SrcBlend  = SrcAlpha;
      DestBlend = InvSrcAlpha;
	}
}