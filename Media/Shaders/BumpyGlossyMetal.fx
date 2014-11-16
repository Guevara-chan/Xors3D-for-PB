float Script = 0.8;
float4x4 WorldITXf;
float4x4 WVPXf;
float4x4 WorldXf;
float4x4 ViewIXf;
float4 LightPos1 = {1.0f, 1.0f, -1.0f, 0.0f};
float4 LightColor1 = {1.0f, 1.0f, 1.0f, 1.0f};
float LightIntensity1 = 2.0;
float4 LightPos2 = {-1.0f, 0.0f, 1.0f, 0.0f};
float4 LightColor2 = {0.5f, 0.5f, 1.0f, 1.0f};
float LightIntensity2 = 0.5;
float4 AmbiColor = {0.07f, 0.07f, 0.07f, 1.0f};
float4 SurfColor = {1.0f, 1.0f, 1.0f, 1.0f};
float Kd = 0.1;
float Ks = 0.8;
float SpecExpon = 1.0;
float Bumpy = 1.0;
float Kr = 1.0;
texture colorTexture;
texture normalTexture;
texture glossTexture;
texture envTexture;

sampler2D colorSampler = sampler_state
{
    Texture = <colorTexture>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

sampler2D normalSampler = sampler_state
{
    Texture = <normalTexture>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

sampler2D glossSampler = sampler_state
{
    Texture = <glossTexture>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU  = Wrap;
    AddressV  = Wrap;
};

samplerCUBE envSampler = sampler_state
{
    Texture = <envTexture>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU  = clamp;
    AddressV  = clamp;
    AddressW  = clamp;
};

struct appdata
{
    float3 Position	: POSITION;
    float4 UV		: TEXCOORD0;
    float4 Normal	: NORMAL;
    float4 Tangent	: TANGENT0;
    float4 Binormal	: BINORMAL0;
};

struct vertexOutput
{
    float4 HPosition	: POSITION;
    float4 TexCoord	: TEXCOORD0;
    float3 WorldNormal	: TEXCOORD1;
    float3 WorldPos	: TEXCOORD2;
    float3 WorldEyeVec	: TEXCOORD3;
    float3 WorldTangent	: TEXCOORD4;
    float3 WorldBinorm	: TEXCOORD5;
    float3 LightVec1	: TEXCOORD6;
    float3 LightVec2	: TEXCOORD7;
};

vertexOutput mainVS(appdata IN)
{
    vertexOutput OUT = (vertexOutput)0;
    OUT.WorldNormal = mul(IN.Normal, WorldITXf).xyz;
    OUT.WorldTangent = mul(IN.Tangent, WorldITXf).xyz;
    OUT.WorldBinorm = mul(IN.Binormal, WorldITXf).xyz;
    float4 Po = float4(IN.Position.xyz,1.0);
    float3 Pw = mul(Po, WorldXf).xyz;
    OUT.WorldPos = Pw;
    OUT.LightVec1 = LightPos1.xyz - Pw;
    OUT.LightVec2 = LightPos2.xyz - Pw;
    OUT.TexCoord = IN.UV;
    OUT.WorldEyeVec = ViewIXf[3].xyz - Pw;
    OUT.HPosition = mul(Po, WVPXf);
    return OUT;
}


float4 mainPS(vertexOutput IN) : COLOR
{
    float3 map = tex2D(colorSampler, IN.TexCoord.xy).rgb;
    float3 bumps = Bumpy * (tex2D(normalSampler, IN.TexCoord.xy).xyz - (0.5).xxx);
    float  gloss = Ks * tex2D(glossSampler, IN.TexCoord.xy).x;
    float3 Nn = normalize(IN.WorldNormal);
    float3 Tn = normalize(IN.WorldTangent);
    float3 Bn = normalize(IN.WorldBinorm);
    float3 Nb = Nn + (bumps.x * Tn + bumps.y * Bn);
    Nb = normalize(Nb);
    float3 Vn = normalize(IN.WorldEyeVec);
    float falloff = LightIntensity1 / dot(IN.LightVec1, IN.LightVec1);
    float3 Ln = normalize(IN.LightVec1);
    float3 Hn = normalize(Vn + Ln);
    float hdn = dot(Hn, Nb);
    float ldn = dot(Ln, Nb);
    float4 litV = lit(ldn, hdn, SpecExpon);
    float3 incident = falloff * litV.y * LightColor1.rgb;
    float3 diffContrib = incident;
    float3 specContrib = litV.z * gloss * incident;
    falloff = LightIntensity2 / dot(IN.LightVec2, IN.LightVec2);
    Ln = normalize(IN.LightVec2);
    Hn = normalize(Vn + Ln);
    hdn = dot(Hn, Nb);
    ldn = dot(Ln, Nb);
    litV = lit(ldn, hdn, SpecExpon);
    incident = falloff * litV.y * LightColor2.rgb;
    diffContrib += incident;
    specContrib += litV.z * gloss * incident;
    float3 reflVect = reflect(Vn, Nb);
    float3 reflColor = Kr * texCUBE(envSampler, float4(reflVect.x, -reflVect.y, -reflVect.z, 1)).rgb;
    float3 result = (SurfColor.rgb * map) * (Kd * diffContrib + AmbiColor.rgb + specContrib + reflColor);
    return float4(result.rgb, 1.0);
}

technique Main
{
    pass p0
    {
        VertexShader = compile vs_2_0 mainVS();
        ZEnable      = true;
        ZWriteEnable = true;
        PixelShader  = compile ps_2_b mainPS();
    }
}