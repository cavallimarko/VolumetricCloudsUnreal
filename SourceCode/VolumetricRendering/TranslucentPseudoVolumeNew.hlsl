float numFrames = XYFrames * XYFrames;

float transmittance = 1;
float3 lightEnergy = 0;
float3 localcamvec = normalize( mul(Parameters.CameraVector, LWCToFloat(GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal)) ) * StepSize;

CurPos += localcamvec * Jitter;


float shadowstepsize = 1 / ShadowSteps;
LightVector *= shadowstepsize;




for (int i = 0; i < MaxSteps; i++)
{
    float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;

    //Sample Light Absorption and Scattering
    if( cursample > 0.001)
    {
		
		float3 lpos = CurPos;
		
		float totalDensity = 0;
		for (int step = 0; step < ShadowSteps; step ++) 
		{
			lpos += LightVector;
			
			float3 shadowboxtest = floor( 0.5 + ( abs( 0.5 - lpos ) ) );
            float exitshadowbox = shadowboxtest .x + shadowboxtest .y + shadowboxtest .z;
			
			if(exitshadowbox >= 1) break;
			
			float lsample = PseudoVolumeTexture(Tex, TexSampler, saturate(lpos), XYFrames, numFrames).r;
			totalDensity += max(0, lsample * shadowstepsize);
			
			
		}
		
		float transmittance1 = exp(-totalDensity * lightAbsorptionTowardSun);
	    float lightTransmittance = darknessThreshold + transmittance1 * (1-darknessThreshold);
		
		lightEnergy += cursample*ShadowDensity * StepSize * transmittance * lightTransmittance * phaseVal;
		transmittance *= exp(-cursample*Density * StepSize * lightAbsorptionThroughCloud);
		
		// Exit early if T is close to zero as further samples won't affect the result much
		if (transmittance < 0.01) {
			break;
		}
    }
    CurPos -= localcamvec;
}

return float4( lightEnergy, transmittance);