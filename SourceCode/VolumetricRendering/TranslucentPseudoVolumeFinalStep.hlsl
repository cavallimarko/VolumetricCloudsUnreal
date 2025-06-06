float numFrames = XYFrames * XYFrames;
float accumdist = 0;

float3 localcamvec = normalize( mul(CameraVector, GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal) );

float StepSize = 1 / MaxSteps;

for (int i = 0; i < MaxSteps; i++)
{
    float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;
    accumdist += cursample * StepSize;
    CurPos += -localcamvec * StepSize;
	}
 CurPos += localcamvec * StepSize;
CurPos +=localcamvec * (1-FinalStep)* StepSize;
float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;
if(MaxSteps<30){
accumdist +=cursample;
}

return accumdist;