float numFrames = XYFrames * XYFrames;
float accumdist = 0;
float StepSize = 1 / MaxSteps;
float3 localcamvec = normalize( mul(CameraVector, GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal) )*StepSize;



for (int i = 0; i < MaxSteps; i++)
{
    float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;
    accumdist += cursample * StepSize;
    CurPos += -localcamvec ;
	}
 CurPos += localcamvec;
CurPos +=-localcamvec * (1-FinalStep);
float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;
if(MaxSteps<20){
accumdist +=cursample*Jitter;
}if(MaxSteps==20){accumdist=1;}

return accumdist;