float numFrames = XYFrames * XYFrames;
float accumdist = 0;
float StepSize = 1 / MaxSteps;
float3 localcamvec = normalize( mul(CameraVector, GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal) );



for (int i = 0; i < MaxSteps; i++)
{
    float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;
	if(cursample>0.001){
		accumdist += cursample * StepSize;
	}
    
    CurPos += -localcamvec * StepSize;
}
 CurPos += 1*localcamvec* StepSize;
CurPos +=-localcamvec * (1-FinalStep)* StepSize;
float cursample = PseudoVolumeTexture(Tex, TexSampler, saturate(CurPos), XYFrames, numFrames).r;

//accumdist +=cursample* StepSize*Jitter;
//if(MaxSteps==20){accumdist=1;}
return accumdist;