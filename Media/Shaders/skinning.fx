//================================================================
//=                                                              =
//=                 Xors3D Engine sapmles shaders                =
//=                                                              =
//= Skinning shader. See 'Skinning sample'                       =
//=                                                              =
//================================================================

// array for bones matrices
float4x4 bonesMatrixArray[60];

// camera view projection matrix
float4x4 matViewProj : MATRIX_VIEWPROJ;

// object diffuse texture
texture diffuseTexture : TEXTURE_0;
sampler diffuseSampler = sampler_state
{
    Texture = <diffuseTexture>;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

// ambeint light
float4 ambientLight : COLOR_AMBIENT;

// Vertex shader input data structure
struct VSINPUT
{
    float4 Position     : POSITION;
    float4 BlendWeights : BLENDWEIGHT;
    float4 BlendIndices : BLENDINDICES;
    float3 Normal       : NORMAL;
    float3 texCoords    : TEXCOORD0;
};

// Vertex shader output data structure
struct VSOUTPUT
{
    float4 Position  : POSITION;
    float3 Normal    : COLOR0;
    float2 texCoords : TEXCOORD0;
};

// skinning vertex shader
VSOUTPUT VSMain(VSINPUT Input)
{
    // Output object
    VSOUTPUT Output;
    // Clear vertex position and normal
    Output.Normal               = float3(0.0f, 0.0f, 0.0f);
    Output.Position             = float4(0.0f, 0.0f, 0.0f, 0.0f);
    // extract bones indicies and weights from vertex
    int    IndexArray[4]        = (int[4])D3DCOLORtoUBYTE4(Input.BlendIndices);
    float  BlendWeightsArray[4] = (float[4])Input.BlendWeights;
    // variable for computing last bone weight
    float LastWeight            = 0.0f;
    // cycle around bones
    [unroll] for(int i = 0; i < 3; i++)
    {
        // compute total bones weight
        LastWeight  = LastWeight + BlendWeightsArray[i];
        // compute position for this bone, multiply by bone weight and add it to output vertex position
        Output.Position += mul(Input.Position, bonesMatrixArray[IndexArray[i]]) * BlendWeightsArray[i];
        // compute normal for this bone, multiply by bone weight and add it to output vertex normal
        Output.Normal   += mul(Input.Normal,   bonesMatrixArray[IndexArray[i]]) * BlendWeightsArray[i];
    }
    // compute weight for last bone (all bones weights must have 1.0 in sum)
    LastWeight  = 1.0f - LastWeight; 
    // compute position for last bone
    Output.Position += mul(Input.Position, bonesMatrixArray[IndexArray[3]]) * LastWeight;
    // compute nprmal for last bone
    Output.Normal   += mul(Input.Normal, bonesMatrixArray[IndexArray[3]]) * LastWeight;
    // transform vertex position in screen space
    Output.Position  = mul(Output.Position, matViewProj);
    // normalize normal
    Output.Normal    = normalize(Output.Normal);
    // rewrite texture coords
    Output.texCoords = Input.texCoords;
    // return result
    return Output;
}

// skinning simple pixel shader
float4 PSMain(float2 texCoords : TEXCOORD0) : COLOR0
{
    // just return diffuse color
    return ambientLight * tex2D(diffuseSampler, texCoords);
}

// skinning tchnique
technique Skinned
{
    pass p1
    {
        VertexShader = compile vs_2_0 VSMain();
        PixelShader  = compile ps_2_0 PSMain();
    }
}