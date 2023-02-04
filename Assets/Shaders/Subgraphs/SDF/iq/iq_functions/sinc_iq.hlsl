#ifndef SINC_IQ
#define SINC_IQ
// Sinc curve
/*
A phase shifted sinc curve can be useful if it starts at zero and ends at zero, for some
bouncing behaviors (suggested by Hubert-Jan). Give k different integer values to tweak
the amount of bounces. It peaks at 1.0, but that take negative values, which can make it
unusable in some applications.
*/
float sinc( float x, float k )
{
    const float a = PI*((k*x-1.0);
    return sin(a)/a;
}
#endif