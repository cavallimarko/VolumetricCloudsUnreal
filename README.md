# Volumetric Clouds - Unreal Engine Project

A comprehensive collection of ray marching and shader techniques for creating volumetric effects, clouds, and advanced visual effects in Unreal Engine.

## Overview

This project contains a wide variety of custom shaders and materials focused on real-time volumetric rendering techniques, with a particular emphasis on clouds and atmospheric effects. It demonstrates various approaches to volumetric rendering, ray marching, parallax mapping, noise-based effects, and advanced shader techniques.


https://github.com/user-attachments/assets/c8ab7846-bb51-4c74-818d-faa19d4f24b5


https://github.com/user-attachments/assets/fda983de-d2a6-4130-9ed4-3aacc51b8b46



https://github.com/user-attachments/assets/ca5e530b-6e51-4737-9929-b7f6d4ece383



https://github.com/user-attachments/assets/4ef24be2-e22c-49b6-8f9d-13ce538a2117



## Content Structure

The project is organized into two main directories:

### RayMarching (70 materials)

- **BasicShapes**: Fundamental ray-marched primitives (spheres, boxes, capsules) 3D-SDF
- **Combinations**: Techniques for combining shapes
  - Boolean operations (union, intersection, subtraction)
  - Lerp combinations
  - Smooth blending
- **Debug**: Materials for visualizing ray marching step count(shader complexity)
- **Fractals**: Procedural fractal implementations
- **Noise**: Procedural noise-based effects and textures
- **Phong**: Lighting models for ray-marched surfaces
- **PseudoVolume**: Techniques for efficient volumetric rendering
  - Opacity handling
  - Sampling, encoding, and baking approaches
  - Shading implementations with shadows
- **Repetition**: Pattern repetition techniques
- **SkySphere**: Sky rendering materials
- **VolumeTexture**: 3D texture-based volumetric rendering

### Shaders (22 materials)

- **Base Materials**: Fundamental shader implementations
- **CloudCards**: Specialized 4 way lighting cloud card rendering techniques, with a focus on volumetric lighting, textures are generated in houdini with 4 point light colors one for each channel
- **fBM**: Fractal Brownian Motion implementations
  - Height field with normal mapping
  - Various parallax mapping approaches:
    - Basic parallax
    - Steep parallax
    - Parallax occlusion mapping (POM)
    - Relief mapping
    - Self-shadowing techniques

### SourceCode

The `SourceCode` directory contains raw HLSL shader code snippets organized by technique:

- **VolumetricRendering**: Volumetric and pseudo-volume rendering techniques
  - Translucent pseudo-volume implementations
  - Fog and atmospheric effects
  - Layered volume techniques
  
- **RayMarching**: Ray marching algorithms for various shapes and scenarios
  - Box and sphere ray marching functions
  - Scene SDF (Signed Distance Field) implementations
  - Optimization techniques for ray traversal
  
- **NoiseTexturing**: Procedural noise generation for texturing
  - 3D Perlin noise implementation
  
- **Shadows**: Shadow implementation techniques
  - Optimized shadow algorithms
  - Layered shadow approaches
  - Light transmission effects
  
- **Utilities**: Helper functions and utilities
  - Normal estimation
  - Global shader functions
  - Plane alignment tools
  - Complexity visualization
  
- **ParralaxMapping**: Parallax techniques for depth effects
  - Steep parallax mapping
  - Relief mapping
  - Parallax occlusion mapping
  - Self-shadowing implementations

## Key Techniques

This project explores and implements several advanced rendering techniques:

- **Ray Marching**: Creating 3D shapes using signed distance fields
- **Volume Rendering**: Various approaches to rendering volumetric data
- **Boolean Operations**: Combining shapes using CSG operations
- **Lighting Models**: Including Phong shading for ray-marched objects
- **Shadow Techniques**: From basic shadows to advanced self-shadowing
- **Noise Functions**: Procedural noise for natural-looking effects
- **Parallax Effects**: Various parallax mapping techniques for depth illusion

## Getting Started

1. Open the project in Unreal Engine
2. Explore the `Content/RayMarching/Levels` directory for example scenes
3. Examine `SkyLevel.umap` for volumetric cloud implementations

## Requirements

- Unreal Engine 5.0 or later
- Hardware supporting compute shaders and advanced rendering features

## Examples and Use Cases

- Volumetric cloud rendering
- Atmospheric effects
- Procedural shape generation
- Advanced material effects
- GPU-based procedural generation

## Notes

This project is primarily a collection of shader techniques and experiments. The materials are organized by technique and can be used as reference or starting points for your own implementations.

---

*Total materials in project: 92* 
