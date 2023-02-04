#ifndef SDF_UTIL
#define SDF_UTIL

#include "SDF_2D_UNION.hlsl";
static float dot2(in float2 v) { return dot(v, v); }
static float dot2(in float3 v) { return dot(v, v); }
static float ndot(in float2 a, in float2 b) { return a.x * b.x - a.y * b.y; }

#endif
