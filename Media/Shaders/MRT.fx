//##########################################
//    mSL
//
// Bump Specular
//		with 3 Light Source Types
//
// Open Source, for Free Using
// Visit: RubuX.net
//##########################################


//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatWorld;



//##################  Input VS  ##################
struct sv_TBN_TC {
	float4 Position		: POSITION0;
	float2 TexCoords	: TEXCOORD0;
	float2 TexCoords1	: TEXCOORD1;
};
//##################  Output VS  ##################
struct sp_PW_TBN_TC {
	float4 Position		: POSITION0;
	float4 pWorld		: TEXCOORD0;
	float2 TexCoords	: TEXCOORD4;
	float2 TexCoords1	: TEXCOORD5;
};

struct ps_OU {
	float4 oCol: COLOR0;
	float4 oCol1: COLOR1;
	float4 oCol2: COLOR2;
};

//##################  VS  ##################
void vs_PW_TBN_TC( in sv_TBN_TC IN, out sp_PW_TBN_TC OUT ) {
	OUT.Position	= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld		= mul(IN.Position,MatWorld);
	OUT.TexCoords	= IN.TexCoords;
	OUT.TexCoords1	= IN.TexCoords1;
}

//##################  PS  ##################
// просто смешиваем лайтмапу и дифузную текстуру с учётом Амбиента
ps_OU psPoint( in sp_PW_TBN_TC IN): COLOR0
 {
	ps_OU OUT;

	OUT.oCol = float4(1,0,0,1);
	OUT.oCol1.rgba = float4(0,0,1,1);
	OUT.oCol2.rgba = float4(0,1,0,1);
	return OUT; 
	
}



//##################  Technique  ##################

technique Point {
	pass p0 {
		vertexshader	= compile vs_2_0 vs_PW_TBN_TC();
		pixelshader		= compile ps_2_0 psPoint();

		CullMode = ccw;
		FillMode = solid;
		Zenable = true;
		ZWriteEnable = true;
		ZFunc = less;
		StencilEnable = false;
		AlphaBlendEnable = false;
		AlphaTestEnable = false;		
		ColorWriteEnable = red | green | blue;
	}
}

