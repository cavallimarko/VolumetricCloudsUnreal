// Plane Alignment
// get object scale factor
//NOTE: This assumes the volume will only be UNIFORMLY scaled. Non uniform scale would require tons of little changes.
float scale = length( TransformLocalVectorToWorld(Parameters, float3(1.00000000,0.00000000,0.00000000)).xyz);
float worldstepsize = scale * GetPrimitiveData(Parameters.PrimitiveId).LocalObjectBoundsMax.x*2 / MaxSteps;

float camdist = length( ResolvedView.WorldCameraOrigin - GetObjectWorldPosition(Parameters) );
float planeoffset = GetScreenPosition(Parameters).w / worldstepsize;
float actoroffset = camdist / worldstepsize;
planeoffset = frac( planeoffset - actoroffset);

float3 localcamvec = normalize( mul(Parameters.CameraVector, GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal) );

float3 offsetvec = localcamvec * StepSize * planeoffset;



return float4(offsetvec, planeoffset * worldstepsize);