float numFrames = XYFrames * XYFrames;
float accumdist = 0;

float curdensity = 0;
float transmittance = 1;
float3 localcamvec = normalize( mul(Parameters.CameraVector, LWCToFloat(GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal)) ) * StepSize;
int3 randpos = int3(Parameters.SvPosition.xy, View.StateFrameIndexMod8);
float rand =float(Rand3DPCG16(randpos).x) / 0xffff;
CurPos += localcamvec * Jitter;


float shadowstepsize = 1 / ShadowSteps;
LightVector *= shadowstepsize;
ShadowDensity *= shadowstepsize;

Density *= StepSize;
float3 lightenergy = 0;
float shadowthresh = -log(ShadowThreshold) / ShadowDensity;

for (int i = 0; i < MaxSteps; i++)
{
    float cursample = PseudoVolumeTexture(NoiseTex, TexSampler, CurPos*NoiseScale, XYFrames, numFrames).r;
		
	cursample-=NoiseMul;
	if( cursample > 0.001)
	{
		if(Distance==0)
		{
			Distance=i;
		}
		float3 lpos = CurPos;
		float shadowdist = 0;

		for (int s = 0; s < ShadowSteps; s++)
		{
			lpos += LightVector;
			float lsample = PseudoVolumeTexture(NoiseTex, TexSampler, saturate(lpos), XYFrames, numFrames).r;
			lsample-=NoiseMul;
			//float cursampleNoise = PseudoVolumeTexture(NoiseTex, TexSampler, lpos*NoiseScale, XYFrames, numFrames).r;
			//if( cursampleNoise > 0.001){
			//	lsample+=cursampleNoise*NoiseMul;
			//}
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
		accumdist += cursample * StepSize;
	}
    
    CurPos -= localcamvec;
}
CurPos += localcamvec * (1 - FinalStep);
float cursample = PseudoVolumeTexture(NoiseTex, TexSampler, CurPos*NoiseScale, XYFrames, numFrames).r;
		
cursample-=NoiseMul;
	
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

return float4( lightenergy, accumdist);