float4x4		worldViewProjMatrix	: MATRIX_WORLDVIEWPROJ;
float4x4		worldMatrix			: MATRIX_WORLD;
int				textureFiltering    : TEXTURE_FILTERING;
int				anisotropyLevel     : ANISOTROPY_LEVEL;

const float 	darkenFactor = 0.85f;
const float		refractPow	 = 0.25f;

const texture tReflection : TEXTURE_0;
sampler TexReflect	= sampler_state {
    Texture   		= <tReflection>;
    /*ADDRESSU  		= MIRROR;
    ADDRESSV  		= MIRROR;
    ADDRESSW		= MIRROR;*/
	ADDRESSU  		= CLAMP;
    ADDRESSV  		= CLAMP;
    ADDRESSW		= CLAMP;
    MAGFILTER		= textureFiltering;
    MINFILTER		= textureFiltering;
    MIPFILTER		= textureFiltering;
	MAXANISOTROPY	= anisotropyLevel;
};

const texture tCrackNorm : TEXTURE_1;
sampler TexCrackNorm= sampler_state {
    Texture   		= <tCrackNorm>;
    ADDRESSU  		= CLAMP;
    ADDRESSV  		= CLAMP;
    ADDRESSW		= CLAMP;
    MAGFILTER		= textureFiltering;
    MINFILTER		= textureFiltering;
    MIPFILTER		= textureFiltering;
	MAXANISOTROPY	= anisotropyLevel;
};

const texture tCrackDiff : TEXTURE_2;
sampler TexCrackDiff= sampler_state {
    Texture   		= <tCrackDiff>;
    ADDRESSU  		= CLAMP;
    ADDRESSV  		= CLAMP;
    ADDRESSW		= CLAMP;
    MAGFILTER		= textureFiltering;
    MINFILTER		= textureFiltering;
    MIPFILTER		= textureFiltering;
	MAXANISOTROPY	= anisotropyLevel;
};

struct VSInput_Main {
   float4 position	: POSITION0;
   float3 coords	: TEXCOORD0;
};

struct VSOutput_Main {
	float4 position 	: POSITION0;
	float3 coordsProj	: TEXCOORD0;
};

struct VSOutput_Main_Broken {
	float4 position 	: POSITION0;
	float3 coordsProj	: TEXCOORD0;
	float2 coords		: TEXCOORD1;
};

void VS_Main( in VSInput_Main IN, out VSOutput_Main OUT )
{
	OUT.position		= mul(float4(IN.position.xyz, 1.0f), worldViewProjMatrix);	
	OUT.coordsProj.xy	= 0.5f * (OUT.position.w - OUT.position.xy);
	OUT.coordsProj.z	= OUT.position.w;
}

void VS_Main_Broken( in VSInput_Main IN, out VSOutput_Main_Broken OUT )
{
	OUT.position		= mul(float4(IN.position.xyz, 1.0f), worldViewProjMatrix);
	OUT.coordsProj.xy	= 0.5f * (OUT.position.w - OUT.position.xy);
	OUT.coordsProj.z	= OUT.position.w;
	OUT.coords			= IN.coords.xy;
}

float4 PS_Main( in VSOutput_Main IN ) : COLOR
{
	// projecting the reflection texture
	IN.coordsProj.xy /= IN.coordsProj.z;
	return float4 ( tex2D(TexReflect, IN.coordsProj.xy).rgb * darkenFactor, 1.0);
}

float4 PS_Main_Broken( in VSOutput_Main_Broken IN ) : COLOR
{	
	// the diffuse map is grayscale, so in the future we can put ir into the alpha-channel of the normal map
	float	crack 		= tex2D(TexCrackDiff, IN.coords.xy).r * 1.0f;
	
	// pow is not necessary, however it provides harder edges.. i hope
	float2	coordOffset = pow((tex2D(TexCrackNorm, IN.coords.xy).rg * 2.0f - 1.0f), float2(2.0, 2.0)) * refractPow;
	//float2	coordOffset = (tex2D(TexCrackNorm, IN.coords.xy).rg * 2.0f - 1.0f) * refractPow	;
	//float2	coordOffset = pow((tex2D(TexCrackNorm, IN.coords.xy).rg * 2.0f - 1.0f), 2.0f) * refractPow;
	IN.coordsProj.xy 	/= IN.coordsProj.z;
	float3 color		= (tex2D(TexReflect, IN.coordsProj.xy + coordOffset.rg).rgb + crack ) * darkenFactor;
	return float4 (color, 1.0);
}

technique Mirror {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 VS_Main();
		pixelshader		= compile ps_2_0 PS_Main();
	}
}

technique Mirror_Broken {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 VS_Main_Broken();
		pixelshader		= compile ps_2_0 PS_Main_Broken();
	}
}