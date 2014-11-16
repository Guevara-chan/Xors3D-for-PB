//##########################################
//    mSL
//
// Stained Glass
//
// Open Source, for Free Using
// Author: MoKa (Maxim Miheyev)
// Mail: mokadwod@gmail.com
// Visit: RubuX.net
//##########################################


//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4	MatWorld;


// Light
float3 LightAmbientColor=float3(0.2f,0.2f,0.2f);	// Light Ambient Color
float3 LightColor=float3(1.0f,1.0f,1.0f);			// Light Color
float  LightInt=1.0f;								// Light Intensity

// Specular
float  SpecRng=40.0f;								// Specular Soft
float  SpecInt=1.0f;								// Specular Intensity

// Refract
const float Refract;								// Refraction Intensity

// Positions
float3 LightPosition;								// Light Position
float3 CameraPosition;								// Camera Position


// Other
static float3 Color;
static float3 cD;
static float  cR;
static float3 cN;
static float  cF;
static float  cS;
static float3 cRf;
static float  cL;
static float3 vecCam;
static float3 vecLight;
static float3 vecLightNM;
static float3 vecSpec;



//##################  Textures  ##################
const texture tDiffuse;			// Diffuse Texture
sampler TexDiffuse=sampler_state {
    Texture   = <tDiffuse>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tRefraction;		// Refraction Map Texture
sampler TexRefraction=sampler_state {
    Texture   = <tRefraction>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tNormal;			// NormalMap Texture
sampler TexNormal=sampler_state {
    Texture   = <tNormal>;
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
	float4 Position : POSITION0;
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
void vs_PV_TBN_TC_TP( in sv_TBN_TC IN, out sp_PW_TBN_TC_TP OUT ) {
	OUT.Position		= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld			= mul(IN.Position,MatWorld);
	OUT.Tangent			= mul(IN.Tangent,MatWorld);
	OUT.Binormal		= mul(IN.Binormal,MatWorld);
	OUT.Normal			= mul(IN.Normal,MatWorld);
	OUT.TexCoords		= IN.TexCoords;
	OUT.TexProj.x		= 0.5f*(OUT.Position.w+OUT.Position.x);
	OUT.TexProj.y		= 0.5f*(OUT.Position.w-OUT.Position.y);
	OUT.TexProj.z		= OUT.Position.w;
}


//##################  PS  ##################
float4 psRefractionNM( in sp_PW_TBN_TC_TP IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords).rgb;
	cR			= tex2D(TexRefraction,IN.TexCoords).r;
	cN			= normalize(tex2D(TexNormal,IN.TexCoords).rgb*2.0f-1.0f);
	
	cRf			= tex2D(TexScreen,(IN.TexProj.xy/IN.TexProj.z)+cN.xy*Refract);
	
	vecLight	= normalize(LightPosition-IN.pWorld);
	vecCam		= normalize(CameraPosition-IN.pWorld);
	vecSpec		= normalize(vecLight+vecCam);
	
	vecLightNM	= float3(dot(vecLight,IN.Tangent),
							dot(vecLight,IN.Binormal),dot(vecLight,IN.Normal));
	vecSpec		= float3(dot(vecSpec,IN.Tangent),
							dot(vecSpec,IN.Binormal),dot(vecSpec,IN.Normal));
	
	cF			= pow(max(dot(vecCam,IN.Normal),0.0f),0.2f);
	cL			= max(dot(vecLightNM,cN),0.0f)*LightInt;
	cS			= pow(max(dot(vecSpec,cN),0.0f),SpecRng)*SpecInt;
	cR			= cR*cF;
	
	Color		= cD*LightAmbientColor+cD*cL*LightColor*(1.0f-cR)+cD*cRf*cR+cD*cS*LightColor*cR;
	
	return float4(Color,1.0f);
}


//##############  Technique  ###############
technique RefractionNM {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PV_TBN_TC_TP();
		pixelshader		= compile ps_2_0 psRefractionNM();
	}
}
