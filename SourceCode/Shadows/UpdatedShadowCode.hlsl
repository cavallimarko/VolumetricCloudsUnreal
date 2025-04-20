float numFrames = XYFrames * XYFrames;
float accumdist = 0;
float curdensity = 0;
float transmittance = 1;
float3 localcamvec = normalize( mul(Parameters.CameraVector, GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal) ) * StepSize;

float shadowstepsize = 1 / ShadowSteps;
LightVector *= shadowstepsize;
ShadowDensity *= shadowstepsize;

Density *= StepSize;
float3 lightenergy = 0;
float shadowthresh = -log(ShadowThreshold) / ShadowDensity;

for (int i = 0; i < MaxSteps; i++)
{
    float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;

    //Sample Light Absorption and Scattering
    if( cursample > 0.001)
    {
        float3 lpos = CurPos;
        float shadowdist = 0;

        for (int s = 0; s < ShadowSteps; s++)
        {
            lpos += LightVector;
            float lsample = PseudoVolumeTexture(Tex, TexSampler, saturate(lpos), XYFrames, numFrames).r;

            float3 shadowboxtest = floor( 0.5 + ( abs( 0.5 - lpos ) ) );
            float exitshadowbox = shadowboxtest .x + shadowboxtest .y + shadowboxtest .z;
            shadowdist += lsample;

            if(shadowdist > shadowthresh || exitshadowbox >= 1) break;
        }

        curdensity = saturate(cursample * Density);
        float shadowterm = exp(-shadowdist * ShadowDensity);
        float3 absorbedlight = shadowterm * curdensity;
        lightenergy += absorbedlight * transmittance;
        transmittance *= 1-curdensity;
    }
    CurPos -= localcamvec;
}

CurPos += localcamvec * (1 - FinalStep);
float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;

//Sample Light Absorption and Scattering
if( cursample > 0.001)
{
    float3 lpos = CurPos;
    float shadowdist = 0;

    for (int s = 0; s < ShadowSteps; s++)
    {
        lpos += LightVector;
        float lsample = PseudoVolumeTexture(Tex, TexSampler, saturate(lpos), XYFrames, numFrames).r;

        float3 shadowboxtest = floor( 0.5 + ( abs( 0.5 - lpos ) ) );
        float exitshadowbox = shadowboxtest .x + shadowboxtest .y + shadowboxtest .z;
        shadowdist += lsample;
        if(shadowdist > shadowthresh || exitshadowbox >= 1) break;
    }
    curdensity = saturate(cursample) * Density;
    float shadowterm = exp(-shadowdist * ShadowDensity);
    float3 absorbedlight = shadowterm * curdensity;
    lightenergy += absorbedlight * transmittance;
    transmittance *= 1-curdensity;
}

return float4( lightenergy, transmittance);

