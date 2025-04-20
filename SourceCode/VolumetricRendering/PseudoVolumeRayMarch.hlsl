float stepsize = 1.0 / Samples;
float opacity = 0;
float TotalSlices=256;
float SliceCountInOneRow=16;
for (int i=0; i<Samples; i++)
{
opacity+= PseudoVolumeTextureSingle(Tex , TexSampler, Pos - (CameraVector * (stepsize * i)), SliceCountInOneRow , TotalSlices);
}

return opacity;