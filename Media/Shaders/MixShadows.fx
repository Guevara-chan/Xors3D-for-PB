//================================================================
//=                                                              =
//=                 Xors3D Engine sapmles shaders                =
//=                                                              =
//= Shadows mixing shader. See 'Forest sample'                   =
//=                                                              =
//================================================================

// world * view * projectin matrix
const float4x4 worldViewProj;

// shadow texture
const texture shadowsTexture;
sampler shadowsSampler = sampler_state
{
    Texture   = <shadowsTexture>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = NONE;
    MINFILTER = NONE;
    MIPFILTER = NONE;
};

// scene diffuse texture
const texture sceneTexture;
sampler sceneSampler = sampler_state
{
    Texture   = <sceneTexture>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = NONE;
    MINFILTER = NONE;
    MIPFILTER = NONE;
};

// Vertex shader input structure
struct VSInput
{
    float4 Position  : POSITION0;
    float2 TexCoords : TEXCOORD0;
};

// Vertex shader output structure
struct VSOutput
{
    float4 Position  : POSITION0;
    float2 TexCoords : TEXCOORD0;
};

// Vertex shader
void VSMain(in VSInput IN, out VSOutput OUT)
{
    // compute screen-space vertex position
    OUT.Position  = mul(IN.Position, worldViewProj);
    // rewrite texture coords
    OUT.TexCoords = IN.TexCoords;
}

// Pixel shader
float4 PSMain(in VSOutput IN) : COLOR
{
    float4 c1 = tex2D(shadowsSampler, IN.TexCoords);
    float4 c2 = tex2D(sceneSampler,   IN.TexCoords);
    return (c1 + 0.5) * c2;
}

// Mixing scene
technique ApplyShadows
{
    pass p0
    {
        VertexShader = compile vs_2_0 VSMain();
        PixelShader  = compile ps_2_0 PSMain();
    }
}