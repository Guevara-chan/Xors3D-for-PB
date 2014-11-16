
//##################  Varriables  ##################
const float4x4 MatWorldViewProj;

// Depth
const half dRange;
const float dFar;

static float4 cD, c1, c2;


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
	c1		= tex2D(TexDiffuse,IN.TexCoords);
	c2		= tex2D(TexEmissive,IN.TexCoords);
	return c1+c2;//+float4(0.5,0,0,1.0);
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
