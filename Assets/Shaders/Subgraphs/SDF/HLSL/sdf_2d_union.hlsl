// https://www.ronja-tutorials.com/post/035-2d-sdf-combination/#union

#ifndef SDF_2D_UNION
#define SDF_2D_UNION
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/common.hlsl"

// transforms

real2 rotate(real2 samplePosition, real rotation)
{
    real angle = rotation * PI * 2 * -1;
    real sine, cosine;
    sincos(angle, sine, cosine);
    return real2(cosine * samplePosition.x + sine * samplePosition.y,
                  cosine * samplePosition.y - sine * samplePosition.x);
}

real2 translate(real2 samplePosition, real2 offset)
{
    //move samplepoint in the opposite direction that we want to move shapes in
    return samplePosition - offset;
}

real2 scale(real2 samplePosition, real scale)
{
    return samplePosition / scale;
}

// combinations

/// basic
real _union(real shape1, real shape2)
{
    return min(shape1, shape2);
}

real intersection(real shape1, real shape2)
{
    return max(shape1, shape2);
}

real difference(real base, real subtraction)
{
    return intersection(base, -subtraction);
}

real interpolate(real shape1, real shape2, real amount)
{
    return lerp(shape1, shape2, amount);
}

/// round
real round_union(real shape1, real shape2, real radius)
{
    real2 intersectionSpace = real2(shape1 - radius, shape2 - radius);
    intersectionSpace = min(intersectionSpace, 0);
    real insideDistance = -length(intersectionSpace);
    real simpleUnion = _union(shape1, shape2);
    real outsideDistance = max(simpleUnion, radius);
    return insideDistance + outsideDistance;
}

real round_intersection(real shape1, real shape2, real radius)
{
    real2 intersectionSpace = real2(shape1 + radius, shape2 + radius);
    intersectionSpace = max(intersectionSpace, 0);
    real outsideDistance = length(intersectionSpace);
    real simpleIntersection = intersection(shape1, shape2);
    real insideDistance = min(simpleIntersection, -radius);
    return outsideDistance + insideDistance;
}

real round_difference(real base, real subtraction, real radius)
{
    return round_intersection(base, -subtraction, radius);
}

///chamfer
real chamfer_union(real shape1, real shape2, real chamferSize)
{
    const real SQRT_05 = 0.70710678118;
    real simpleMerge = _union(shape1, shape2);
    real chamfer = (shape1 + shape2) * SQRT_05;
    chamfer = chamfer - chamferSize;
    return _union(simpleMerge, chamfer);
}

real chamfer_intersection(real shape1, real shape2, real chamferSize)
{
    const real SQRT_05 = 0.70710678118;
    real simpleIntersect = intersection(shape1, shape2);
    real chamfer = (shape1 + shape2) * SQRT_05;
    chamfer = chamfer + chamferSize;
    return intersection(simpleIntersect, chamfer);
}

real chamfer_difference(real base, real subtraction, real chamferSize)
{
    return chamfer_intersection(base, -subtraction, chamferSize);
}

/// round border intersection
real round_border(real shape1, real shape2, real radius)
{
    real2 position = real2(shape1, shape2);
    real distanceFromBorderIntersection = length(position);
    return distanceFromBorderIntersection - radius;
}

real groove_border(real base, real groove, real width, real depth)
{
    real circleBorder = abs(groove) - width;
    real grooveShape = difference(circleBorder, base + depth);
    return difference(base, grooveShape);
}

// shadergraph functions
void _union_float(float shape1, float shape2, out float o)
{
    o = _union(shape1, shape2);
}

void intersection_float(float shape1, float shape2, out float o)
{
    o = intersection(shape1, shape2);
}

void difference_float(float base, float subtraction, out float o)
{
    o = difference(base, subtraction);
}

void interpolate_float(float shape1, float shape2, float amount, out float o)
{
    o = interpolate(shape1, shape2, amount);
}

void round_union_float(float shape1, float shape2, float radius, out float o)
{
    o = round_union(shape1, shape2, radius);
}

void round_intersection_float(float shape1, float shape2, float radius, out float o)
{
    o = round_intersection(shape1, shape2, radius);
}

void round_difference_float(float base, float subtraction, float radius, out float o)
{
    o = round_difference(base, subtraction, radius);
}

void chamfer_union_float(float shape1, float shape2, float chamferSize, out float o)
{
    o = chamfer_union(shape1, shape2, chamferSize);
}

void chamfer_intersection_float(float shape1, float shape2, float chamferSize, out float o)
{
    o = chamfer_intersection(shape1, shape2, chamferSize);
}

void chamfer_difference_float(float shape1, float shape2, float chamferSize, out float o)
{
    o = chamfer_difference(shape1, shape2, chamferSize);
}

void round_border_float(float shape1, float shape2, float radius, out float o)
{
    o = round_border(shape1, shape2, radius);
}

void groove_border_float(float base, float groove, float width, float depth, out float o)
{
    o = groove_border(base, groove, width, depth);
}

#endif
