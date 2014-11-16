float4 lightPos = {500.00, 500.00, 0.00, 1.00};
float4x4 world_view_proj_matrix;
float4 view_position;
float4x4 inv_view_matrix;

struct VS_OUTPUT
{
    float4 Pos   : POSITION;
    float2 Tex   : TEXCOORD0;
    float3 View  : TEXCOORD1;
    float3 Light : TEXCOORD2;
    float3 Half  : TEXCOORD3;
};

VS_OUTPUT Wings_VS(float4 Pos      : POSITION,
                   float4 Normal   : NORMAL0,
                   float2 Tex      : TEXCOORD0,
                   float3 Tangent  : TANGENT0,
                   float3 Binormal : BINORMAL0)
{
    VS_OUTPUT Out = (VS_OUTPUT)0; 
    Out.Pos = mul(Pos, world_view_proj_matrix);
    Out.Tex = Tex;
    float3 vLight = normalize(mul(lightPos, inv_view_matrix) - Pos);
    float3x3 mTangentSpace;
    mTangentSpace[0] = Tangent;
    mTangentSpace[1] = Binormal;
    mTangentSpace[2] = Normal;
    Out.Light = mul(vLight, mTangentSpace);
    float3 vView = normalize(view_position - Pos);
    Out.View = mul(vView, mTangentSpace);
    Out.Half = mul(normalize(vView + vLight), mTangentSpace);
    return Out;
}

float4 ambient = {0.37, 0.37, 0.37, 1.00};
float  gloss_bias              = 0.16;
float  gloss_scale             = 0.20;
float  iridescence_speed_bias  = 0.50;
float  translucencyCoeff       = 4.00;
float  iridescence_speed_scale = 15.00;

texture baseOpacityMap_Tex;
texture bumpGlossMap_Tex;
texture gradientMap_Tex;

sampler base_opacityMap = sampler_state
{
    Texture       = <baseOpacityMap_Tex>;
    ADDRESSU      = CLAMP;
    ADDRESSV      = CLAMP;
    MAGFILTER     = LINEAR;
    MINFILTER     = LINEAR;
    MAXANISOTROPY = 16;
    MIPFILTER     = LINEAR;
};
sampler bump_glossMap = sampler_state
{
    Texture   = <bumpGlossMap_Tex>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
sampler gradientMap = sampler_state
{
    Texture   = <gradientMap_Tex>;
    ADDRESSU  = MIRROR;
    ADDRESSV  = MIRROR;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

float4 Wings_PS(float4 Diff  : COLOR0,
                float2 Tex   : TEXCOORD0,
                float3 View  : TEXCOORD1,
                float3 Light : TEXCOORD2,
                float3 Half  : TEXCOORD3) : COLOR
{
    float3 vNormal, baseColor;
    float  fGloss, fTranslucency;
    float4(vNormal, fGloss) = tex2D(bump_glossMap, Tex);
    float4(baseColor, fTranslucency) = tex2D(base_opacityMap, Tex);
    vNormal = vNormal * 2 - 1;
    float3 scatteredIllumination = saturate(dot(-vNormal, Light)) * fTranslucency * translucencyCoeff;
    float3 diffuseContribution   = saturate(dot(vNormal,Light)) + ambient;
    baseColor *= scatteredIllumination + diffuseContribution;
    float fOpacity = 1 - fTranslucency;
    baseColor *= fOpacity;
    float fGradientIndex = dot(vNormal, View) * iridescence_speed_scale + iridescence_speed_bias;
    float4 iridescence = tex1D(gradientMap, fGradientIndex);
    float fGlossIndex = fGloss * (saturate(dot(vNormal, Half)) * gloss_scale + gloss_bias);
    baseColor += fGlossIndex * iridescence;
    return float4(baseColor, fOpacity);
}


technique IridescentButterfly
{
    pass Wings
    {
        FILLMODE = SOLID;
        SRCBLEND = ONE;
        DESTBLEND = INVSRCALPHA;
        CULLMODE = CCW;
        ALPHABLENDENABLE = TRUE;
        VertexShader = compile vs_1_1 Wings_VS();
        PixelShader  = compile ps_2_0 Wings_PS();
    }
}