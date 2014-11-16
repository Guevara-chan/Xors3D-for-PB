float4x4 view_proj_matrix;
float4x4 world_matrix;
float4   view_position;
struct VS_OUTPUT
{
   float4 Pos    : POSITION;
   float3 pos    : TEXCOORD0;
   float3 normal : TEXCOORD1;
   float3 vVec   : TEXCOORD2;
};

float freq;

VS_OUTPUT VSMain(float4 Pos: POSITION, float3 normal: NORMAL)
{
    VS_OUTPUT Out;
    Pos.y = sin(freq + Pos.x * 500 + Pos.z * 300) * 1.9;
    float4 wPos = mul(Pos,  world_matrix);
    Out.Pos     = mul(wPos, view_proj_matrix);
    Out.pos     = wPos.xyz * 0.01;
    Out.vVec    = normalize(view_position - wPos);
    Out.normal  = normal;
    return Out;
}

float time_0_X;
float waveSpeed   = 0.34;
float noiseSpeed  = 0.18;
float4 waterColor = {0.20, 0.35, 0.68, 1.0};

texture Noise_Tex;
sampler Noise = sampler_state
{
    Texture   = <Noise_Tex>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
texture envBox_Tex;
sampler envBox = sampler_state
{
    Texture   = <envBox_Tex>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

float4 PSMain(float3 pos: TEXCOORD0, float3 normal: TEXCOORD1, float3 vVec: TEXCOORD2) : COLOR
{
    pos.x += waveSpeed  * time_0_X;
    pos.z += noiseSpeed * time_0_X;
    float4 noisy = tex3D(Noise, pos);
    noisy = float4(normalize(normal + noisy), 1.0);
    float3 reflVec = normalize(vVec * noisy);
    float4 refl = texCUBE(envBox, float4(-reflVec.x, reflVec.y, -reflVec.z, 1.0));
    return float4(lerp(waterColor, refl, 0.8).xyz, 0.6);
}

technique Water
{
    pass p0
    {
        AlphaBlendEnable = true;
        VertexShader     = compile vs_1_1 VSMain();
        PixelShader      = compile ps_2_0 PSMain();
    }
}