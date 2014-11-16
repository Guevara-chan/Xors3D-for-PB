
//##################  Varriables  ##################
const float4x4 MatWorldViewProj;

// Depth
const half dRange;
const float dFar;



//##################  Textures  ##################
const texture tDiffuse;
sampler TexDiffuse=sampler_state {
    Texture   = <tDiffuse>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
};

const texture tEmissive;
sampler TexEmissive=sampler_state {
    Texture   = <tEmissive>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


static const int g_cKernelSize = 13;
static const float sw = 256;

float2 PixelKernel[g_cKernelSize] =
{
    { -6/sw , 0 },
    { -5/sw , 0 },
    { -4/sw , 0 },
    { -3/sw , 0 },
    { -2/sw , 0 },
    { -1/sw , 0 },
    {  0, 0 },
    {  1/sw , 0 },
    {  2/sw , 0 },
    {  3/sw , 0 },
    {  4/sw , 0 },
    {  5/sw , 0 },
    {  6/sw , 0 },
};

float2 PixelKernelV[g_cKernelSize] =
{
    { 0, -6/sw },
    { 0, -5/sw },
    { 0, -4/sw },
    { 0, -3/sw },
    { 0, -2/sw },
    { 0, -1/sw },
    {  0, 0 },
    { 0,  1/sw },
    { 0,  2/sw },
    { 0,  3/sw },
    { 0,  4/sw },
    { 0,  5/sw },
    { 0,  6/sw },
};

float2 TexelKernel[g_cKernelSize]
<
    string ConvertPixelsToTexels = "PixelKernel";
>;


static const float BlurWeights[g_cKernelSize] = 
{
    0.002216,
    0.008764,
    0.026995,
    0.064759,
    0.120985,
    0.176033,
    0.199471,
    0.176033,
    0.120985,
    0.064759,
    0.026995,
    0.008764,
    0.002216,
};




float BloomScale = 1.5f;


//###############  Input VS  ###############
struct vis {
	float4 Position : POSITION0;
	float2 TexCoords : TEXCOORD0;
};
struct vid {
	float4 Position : POSITION0;
	float2 TexCoords : TEXCOORD0;
};
//###############  Output VS  ##############
struct pis {
	float4 Position : POSITION0;
	float2 TexCoords : TEXCOORD0;
};
struct pid {
	float4 Position : POSITION0;
	float Depth : TEXCOORD0;
	float3 ProjTex : TEXCOORD1;
};


//##################  VS  ##################
void vs( in vis IN, out pis OUT ) {
	OUT.Position		= mul(IN.Position,MatWorldViewProj);
	OUT.TexCoords		= IN.TexCoords;
}
void vsd( in vid IN, out pid OUT ) {
	OUT.Position		= mul(IN.Position,MatWorldViewProj);
	OUT.Depth			= OUT.Position.z;
	OUT.ProjTex.x		= 0.5f*(OUT.Position.w+OUT.Position.x);
	OUT.ProjTex.y		= 0.5f*(OUT.Position.w-OUT.Position.y);
	OUT.ProjTex.z		= OUT.Position.w;
}


//##################  PS  ##################
//===============  Diffuse  ================
float4 psDiffuse( in pis IN ) : COLOR {
    float4 Color = tex2D( TexDiffuse, IN.TexCoords);

    return 4*(Color-0.75);//float4(normalize(Color.rgb-0.5),1);
}

float4 psDiffuseH( in pis IN ) : COLOR {
    float4 Color = 0;

    for (int i = 0; i < g_cKernelSize; i++)
    {    
        Color += tex2D( TexDiffuse, IN.TexCoords + PixelKernel[i].xy ) * BlurWeights[i];
    }

    return Color * 1.5 ;
}

float4 psDiffuseV( in pis IN ) : COLOR {
    float4 Color = 0;

    for (int i = 0; i < g_cKernelSize; i++)
    {    
        Color += tex2D( TexDiffuse, IN.TexCoords + PixelKernelV[i].xy ) * BlurWeights[i];
    }

    return Color * 1.5 + tex2D(TexEmissive, IN.TexCoords);
}
//==========================================




//##############  Technique  ###############
//------------------------------------------
technique Diffuse {
	pass p0 {
		//AlphaBlendEnable= 1;
		vertexshader	= compile vs_2_0 vs();
		pixelshader		= compile ps_2_0 psDiffuse();
	}
}

technique DiffuseH {
	pass p0 {
		//AlphaBlendEnable= 1;
		vertexshader	= compile vs_2_0 vs();
		pixelshader		= compile ps_2_0 psDiffuseH();
	}
}
technique DiffuseV {
	pass p0 {
		//AlphaBlendEnable= 1;
		vertexshader	= compile vs_2_0 vs();
		pixelshader		= compile ps_2_0 psDiffuseV();
	}
}
