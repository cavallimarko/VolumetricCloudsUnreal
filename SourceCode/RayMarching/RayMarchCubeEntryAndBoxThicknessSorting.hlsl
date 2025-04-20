//bring vectors into local space to support object transforms
float3 localcampos = mul(float4( ResolvedView.WorldCameraOrigin,1.00000000), (GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal)).xyz;
float3 localcamvec = -normalize( mul(Parameters.CameraVector, GetPrimitiveData(Parameters.PrimitiveId).WorldToLocal) );

//make camera position 0-1
localcampos = (localcampos / (GetPrimitiveData(Parameters.PrimitiveId).LocalObjectBoundsMax.x * 2)) + 0.5;

float3 invraydir = 1 / localcamvec;

float3 firstintersections = (0 - localcampos) * invraydir;
float3 secondintersections = (1 - localcampos) * invraydir;
float3 closest = min(firstintersections, secondintersections);
float3 furthest = max(firstintersections, secondintersections);

float t0 = max(closest.x, max(closest.y, closest.z));
float t1 = min(furthest.x, min(furthest.y, furthest.z));

float planeoffset = 1-frac( ( t0 - length(localcampos-0.5) ) * MaxSteps );
//comment out for performance boost and disabling plane aligment
t0 += (planeoffset / MaxSteps) * PlaneAlignment;
//Sorting
float scale = length( TransformLocalVectorToWorld(Parameters, float3(1.00000000,0.00000000,0.00000000)).xyz);
float localscenedepth = CalcSceneDepth(ScreenAlignedPosition(GetScreenPosition(Parameters)));

float3 camerafwd = mul(float3(0.00000000,0.00000000,1.00000000),ResolvedView.ViewToTranslatedWorld);
localscenedepth /= (GetPrimitiveData(Parameters.PrimitiveId).LocalObjectBoundsMax.x * 2 * scale);
localscenedepth /= abs( dot( camerafwd, Parameters.CameraVector ) );

t1 = min(t1, localscenedepth);
t0 = max(0, t0);

float boxthickness = max(0, t1 - t0);
float3 entrypos = localcampos + (max(0,t0) * localcamvec);

return float4( entrypos, boxthickness );
