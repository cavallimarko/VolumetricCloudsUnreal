float3 diffuse=DiffuseStrength*max(dot(Normals,LightDir),0);
float3 ambient=AmbientStrength;
float3 reflectedVector=reflect(LightDir,Normals);
float3 specular=SpecularStrength*pow(max(dot(reflectedVector,RayDirection),0),SpecularExponent);
return Color*(ambient+diffuse)+specular;