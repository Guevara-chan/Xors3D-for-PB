
//##################  Varriables  ##################
const float4x4 MatViewProj;
const float4x4 MatWorld;

// Light
float3 DirL = float3(0.5,-0.5,0);

const float4 posAndSize[250];

// Positions
float4 PosCam;

// Other
static float3 Color;
static float4 cD;

static float3 nFallOff;



//##################  Textures  ##################
const texture tDiffuse;
sampler TexDiffuse=sampler_state {
    Texture   = <tDiffuse>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


//##################  Input VS  ##################
struct vi {
  	float4 Position : POSITION0;
   	float2 TexCoords : TEXCOORD0;
	float2 TC : TEXCOORD1;
	float3 Normal : NORMAL;
};
//##################  Output VS  ##################
struct pi {
	float4 Position : POSITION0;
	float2 TexCoords : TEXCOORD2;
	float3 Normal : TEXCOORD3;
};


//##################  VS  ##################
void vs( in vi IN, out pi OUT ) {

	IN.Position= IN.Position + posAndSize[IN.TC.x];

	OUT.Position	= mul(IN.Position, MatViewProj);
	OUT.TexCoords	= IN.TexCoords;
	OUT.Normal		= normalize(mul(IN.Normal,MatViewProj));
}

//##################  PS  ##################
float4 ps( in pi IN ) : COLOR {
	return float4(0,0.5,0,1)*dot(DirL, IN.Normal)+float4(0,0.3,0,1);
}


//##################  Technique  ##################
technique Inst{
	pass p0 {
		vertexshader	= compile vs_2_0 vs();
		pixelshader		= compile ps_2_0 ps();
	}
}
