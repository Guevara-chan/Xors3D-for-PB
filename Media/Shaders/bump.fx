//================================================================
//=                                                              =
//=                 Xors3D Engine sapmles shaders                =
//=                                                              =
//= specular bump mapping shader. See 'Bump-mapping sample'      =
//=                                                              =
//================================================================

// world matrix
float4x4 matrixWorld : MATRIX_WORLD;
// world * view * project matrix
float4x4 matrixWorldViewProject : MATRIX_WORLDVIEWPROJ;

// light data
float3 lightPosition : LIGHT0_POSITION;
float  lightRange : LIGHT0_RANGE;
float4 lightColor : LIGHT0_COLOR;

// camera data
float3 cameraPosition;

// object data
float shininess : COLOR_SPECULAR;

// Vertex shader input structure
struct VSInput
{
    float4 Position  : POSITION0;
    float3 Tangent   : TANGENT;
    float3 Binormal  : BINORMAL;
    float3 Normal    : NORMAL;
    float2 TexCoords : TEXCOORD0;
};

// Vertex shader output structure
struct VSOutput
{
    float4 Position  : POSITION0;
    float4 pWorld    : TEXCOORD0;
    float3 Tangent   : TEXCOORD1;
    float3 Binormal  : TEXCOORD2;
    float3 Normal    : TEXCOORD3;
    float2 TexCoords : TEXCOORD4;
};

// diffuse map
const texture texDiffuse : TEXTURE_0;
sampler samplerDiffuse = sampler_state
{
    Texture   = <texDiffuse>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

// normal map
const texture texNormal : TEXTURE_1;
sampler samplerNormal = sampler_state
{
    Texture   = <texNormal>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

// Vertex shader
void VSMain(in VSInput IN, out VSOutput OUT)
{
    // compute screen vertex position
    OUT.Position = mul(IN.Position, matrixWorldViewProject);
    // compute world vertex position
    OUT.pWorld = mul(IN.Position, matrixWorld);
    // compute tangent vector in world space
    OUT.Tangent = normalize(mul(IN.Tangent, matrixWorld));
    // compute binormal vector in world space
    OUT.Binormal = normalize(mul(IN.Binormal, matrixWorld));
    // compute normal vector in world space
    OUT.Normal = normalize(mul(IN.Normal, matrixWorld));
    // write texture coords
    OUT.TexCoords = IN.TexCoords;
}

float4 PSMain(in VSOutput IN) : COLOR0
{
    // getting diffuse color from texture
    float4 cD = tex2D(samplerDiffuse, IN.TexCoords);
    // getting normal vector from normal-map
    float3 cN = tex2D(samplerNormal, IN.TexCoords) * 2.0f - 1.0f;
    // compute object-to-tangent space matrix
    float3x3 objToTangent;
    objToTangent[0] = IN.Tangent;
    objToTangent[1] = IN.Binormal;
    objToTangent[2] = IN.Normal;
    // transform normal to tangent space
    cN = normalize(mul(cN, objToTangent));
    // compute attenuation factor
    float atten = saturate(1.0f - distance(IN.pWorld.xyz, lightPosition) / lightRange);
    // compute specular factor
    float3 nspec = normalize((cameraPosition - IN.pWorld.xyz) + (lightPosition - IN.pWorld.xyz));
    half  spec  = pow(dot(nspec, cN), 100);
    // compute light factor
    float light = dot(cN, normalize(lightPosition - IN.pWorld.xyz));
    // compute result color
    return (spec + cD) * light * atten * lightColor;
}

//bump-mapping technique
technique Bump
{
    pass p0
    {
        AlphaBlendEnable = false;
        VertexShader = compile vs_2_0 VSMain();
        PixelShader  = compile ps_2_0 PSMain();
    }
}