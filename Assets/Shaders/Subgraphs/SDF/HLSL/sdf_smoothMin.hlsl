#ifndef SDF_SMOOTHMIN
#define SDF_SMOOTHMIN

// exponential smooth min (k=32)
float smin_exp(float a, float b, float k)
{
    float res = exp2(-k * a) + exp2(-k * b);
    return -log2(res) / k;
}

// power smooth min (k=8)
float smin_pow(float a, float b, float k)
{
    a = pow(a, k);
    b = pow(b, k);
    return pow((a * b) / (a + b), 1.0 / k);
}

// root smooth min (k=0.01)
float smin_rt(float a, float b, float k)
{
    float h = a - b;
    return 0.5 * ((a + b) - sqrt(h * h + k));
}

/*
The last two functions, the two "polynomial smooth min" functions are really the same function
(they are mathematically equivalent) but have different implementations (more of that later). So in reality we are
looking here to four functions that produce smooth results only, all of which have different properties. They all
accept a parameter k that controls the radious/distance of the smoothness. From these four, probably the polynomial
is the fastest, and also the most intuitive to control, for k maps directly to a blending band size/distance. 
*/

// polynomial smooth min 1 (k=0.1)
float smin_quadratic_c1(float a, float b, float k)
{
    float h = clamp(0.5 + (0.5 * (b - a)) / k, 0.0, 1.0);
    return lerp(b, a, h) - k * h * (1.0 - h);
}

// quadratic polynomial smooth min 2 (k=0.1)
float smin_quadratic_c2(float a, float b, float k)
{
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * k * (1.0 / 4.0);
}

/*
As noted by Shadertoy user TinyTexel, this can be generalized to higher levels of continuity than the quadratic
polynomial offers (C1), which might be important for preventing lighting artifacts.
Moving on to a cubic curve gives us C2 continuity, and doesn't get a lot more expensive than the quadratic one anyways:
*/

// cubic polynomial smooth min
float smin_cubic(float a, float b, float k)
{
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * h * k * (1.0 / 6.0);
}

/* Mix factor
Besides smoothly blending values, it might be useful to compute also a blending factor that can be used for shading.
For example, if the smooth-minimum is being used to blend SDF shapes, having a blend factor could be useful to blend
the material properties of the two shapes during the transition area.

This the code for the quadratic and cubic smooth-minimum that returns the smooth-minimum in .x and the blend factor in .y:
*/

// Quadratic smooth-minimum with blending factor: k
float2 smin_blend(float a, float b, float k)
{
    float h = max(k - abs(a - b), 0.0) / k;
    float m = h * h * 0.5;
    float s = m * k * (1.0 / 2.0);
    return (a < b) ? float2(a - s, m) : float2(b - s, m - 1.0);
}

// Cubic smooth-minimum with blending factor: k
float2 sminCubic_blend(float a, float b, float k)
{
    float h = max(k - abs(a - b), 0.0) / k;
    float m = h * h * h * 0.5;
    float s = m * k * (1.0 / 3.0);
    return (a < b) ? float2(a - s, m) : float2(b - s, 1.0 - m);
}

// Generalization to any power
float2 sminN(float a, float b, float k, float n)
{
    float h = max(k - abs(a - b), 0.0) / k;
    float m = pow(h, n) * 0.5;
    float s = m * k / n;
    return (a < b) ? float2(a - s, m) : float2(b - s, m - 1.0);
}

// Blender interpretation

/* See: https://www.iquilezles.org/www/articles/smin/smin.htm */
float math_smoothmin(float a, float b, float k)
{
    if (k != 0.0)
    {
        return smin_cubic(a, b, k);
    }
    return min(a, b);
}

float math_smoothmax(float a, float b, float k)
{
    const float result = math_smoothmin(-a, -b, k);
    return -result;
}

// Shader Graph functions

void smin_exp_float(float a, float b, float k, out float o)
{
    o = smin_exp(a, b, k);
}

void smin_pow_float(float a, float b, float k, out float o)
{
    o = smin_pow(a, b, k);
}

void smin_rt_float(float a, float b, float k, out float o)
{
    o = smin_rt(a, b, k);
}

void smin_poly_float(float a, float b, float k, out float o)
{
    o = smin_quadratic_c2(a, b, k);
}

void smin_float(float a, float b, float k, out float2 o)
{
    o = smin_blend(a, b, k);
}

void sminCubic_float(float a, float b, float k, out float2 o)
{
    o = sminCubic_blend(a, b, k);
}

void sminN_float(float a, float b, float k, float n, out float2 o)
{
    o = sminN(a, b, k, n);
}

void math_smoothmin_float(float a, float b, float c, out float result)
{
    result = math_smoothmin(a, b, c);
}

void math_smoothmax_float(float a, float b, float c, out float result)
{
    result = math_smoothmax(a, b, c);
}
#endif
