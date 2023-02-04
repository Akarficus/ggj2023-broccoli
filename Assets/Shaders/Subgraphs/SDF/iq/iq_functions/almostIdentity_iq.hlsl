#ifndef ALMOST_ID_IQ
#define ALMOST_ID_IQ
// Almost Identity (I)
/*
Imagine you don't want to modify a signal unless it's drops to zero or close to it, in which case
you want to replace the value with a small possitive constant. Then, rather than clamping the value
and introduce a discontinuity, you can smoothly blend * the signal into the desired clipped value.
So, let m be the threshold (anything above m stays unchanged), and n the value things will take when
the signal is zero. Then, the following function does the soft clipping (in a cubic fashion):
*/
float almostIdentity( float x, float m, float n )
{
    if( x>m ) return x;
    const float a = 2.0*n - m;
    const float b = 2.0*m - 3.0*n;
    const float t = x/m;
    return (a*t + b)*t*t + n;
}

// Almost Identity (II)
/*
A different way to achieve a near identity is through the square root of a biased square. I
saw this technique first in a shader by user "omeometo" in Shadertoy. This approach can
be a bit slower than the cubic above, depending on the hardware, but I find myself using
it a lot these days. While it has zero derivative, it has a non-zero second derivative, so
keep an eye in case it causes problems in your application.

An extra nice thing is that this function can be used, unaltered, as an smooth-abs()
function, which comes handy for symmetric funtions such as mirrored SDFs.
*/
float almostIdentity( float x, float n )
{
    return sqrt(x*x+n);
}

// Almost Unit Identity
/*
This is a near-identiy function that maps the unit interval into itself. It is the cousin of
smoothstep(), in that it maps 0 to 0, 1 to 1, and has a 0 derivative at the origin, just like
smoothstep. However, instead of having a 0 derivative at 1, it has a derivative of 1 at
that point. It's equivalent to the Almost Identiy above with n=0 and m=1. Since it's a
cubic just like smoothstep() it is very fast to evaluate:
*/
float almostUnitIdentity( float x )
{
    return x*x*(2.0-x);
}
#endif // ALMOST_ID_FUNC