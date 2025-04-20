	float sceneDepth = CalcSceneDepth(ScreenAlignedPosition(GetScreenPosition(Parameters)));
	float3 rayVec = -normalize(Parameters.CameraVector);
	float3 rayOrigin = ResolvedView.WorldCameraOrigin;
	//Bounding Box
	float3 boundMin = TransformLocalPositionToWorld(Parameters, MaterialFloat4(GetPrimitiveData(Parameters.PrimitiveId).LocalObjectBoundsMin,1.00000000).xyz).xyz;
	float3 boundMax = TransformLocalPositionToWorld(Parameters, MaterialFloat4(GetPrimitiveData(Parameters.PrimitiveId).LocalObjectBoundsMax,1.00000000).xyz).xyz;
	rayVec = normalize(rayVec);
	
	float3 dist1 = (boundMin - rayOrigin)/rayVec;
	float3 dist2 = (boundMax - rayOrigin)/rayVec;
	
	float3 closeDist = min(dist1, dist2);
	float3 farDist = min(max(dist1, dist2), sceneDepth); //don't draw parts of volume, that's occluded by something
	
	//Check if ray intersects box
	float distA = max(max(closeDist.x, closeDist.y), closeDist.z); //If distA < 0, camera is in Volume
	float distB = min( min(farDist.x, farDist.y), farDist.z); //If distB <= distA, no hit
	
	float distToBox = max(0, distA);
	float distInsideBox	 = max(0, distB - distToBox);
	float3 entrypos = rayOrigin + (distToBox * rayVec);
	
	return float4(entrypos, distInsideBox);		
