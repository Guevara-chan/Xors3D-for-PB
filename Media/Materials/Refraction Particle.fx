//##########################################
//    mSL
//
// Bump Light + Specular + FallOff
//		with 3 Light Source Types
//
// Open Source, for Free Using
// Author: MoKa (Maxim Miheyev)
// Mail: mokadwod@gmail.com
// Visit: RubuX.net
//##########################################


//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatWorld;

// Refract
const float Refract;		// Refraction Intensity
const float Offset;			// Offset

// Positions
float3 PosCamera;			// Camera Position

// Other
static float3 Color;
static float cA;
static float3 cN;
static float3 cS;

static float3 nCamera;


//##################  Textures  ##################
const texture tAlpha;			// AlphaMap Texture
sampler TexAlpha=sampler_state {
    Texture   = <tAlpha>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tNormalS;			// First NormalMap Texture
sampler TexNormalS=sampler_state {
    Texture   = <tNormalS>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tNormalF;			// Second NormalMap Texture
sampler TexNormalF=sampler_state {
    Texture   = <tNormalF>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tScreen;			// Screen Texture
sampler TexScreen=sampler_state {
    Texture   = <tScreen>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    ADDRESSW  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


//###############  Input VS  ###############
struct sv_TBN_TC {
    float4 Position	: POSITION0;
	float3 Tangent : TANGENT;
	float3 Binormal : BINORMAL;
	float3 Normal : NORMAL;
	float2 TexCoords : TEXCOORD0;
};
//###############  Output VS  ##############
struct sp_PW_TBN_TC_TP {
    float4 Position	: POSITION0;
	float4 pWorld : TEXCOORD0;
	float3 Tangent : TEXCOORD1;
	float3 Binormal : TEXCOORD2;
	float3 Normal : TEXCOORD3;
	float2 TexCoords : TEXCOORD4;
	float3 TexProj : TEXCOORD5;
};


//##################  VS  ##################
void vs_PW_NTB_TC_TP( in sv_TBN_TC IN, out sp_PW_TBN_TC_TP OUT ) {
	OUT.Position		= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld			= mul(IN.Position,MatWorld);
	OUT.Normal			= normalize(mul(IN.Normal,MatWorld));
	OUT.Tangent			= normalize(mul(IN.Tangent,MatWorld));
	OUT.Binormal		= normalize(mul(IN.Binormal,MatWorld));
	OUT.TexCoords		= IN.TexCoords;
	OUT.TexProj.x		= 0.5f*(OUT.Position.w+OUT.Position.x);
	OUT.TexProj.y		= 0.5f*(OUT.Position.w-OUT.Position.y);
	OUT.TexProj.z		= OUT.Position.w;
}


//##################  PS  ##################
float4 psRefraction( in sp_PW_TBN_TC_TP IN ) : COLOR {
	cA			= tex2D(TexAlpha,IN.TexCoords).r;
	cN			= tex2D(TexNormalS, IN.TexCoords+float2(0,Offset));
	cN			+=tex2D(TexNormalF,IN.TexCoords-float2(0,Offset));
	cN			= normalize(cN*2.0f-1.0f);
	
	PosCamera	= normalize(PosCamera-IN.pWorld);
	
	cS			= tex2D(TexScreen,(IN.TexProj.xy/IN.TexProj.z)+(refract(PosCamera,cN,0.5f)*Refract+float2(0.0f,Refract*0.25f)));
	
	Color		= cS;
	return float4(Color,cA);
}


//##############  Technique  ###############
technique Refraction {
	pass p0 {
		AlphaBlendEnable= true;
		vertexshader	= compile vs_2_0 vs_PW_NTB_TC_TP();
		pixelshader		= compile ps_2_0 psRefraction();
	}
}
