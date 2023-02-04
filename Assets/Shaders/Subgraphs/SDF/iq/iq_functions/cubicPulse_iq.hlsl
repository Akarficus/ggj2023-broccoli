#ifndef CUBIC_PULSE_IQ
#define CUBIC_PULSE_IQ
// Cubic Pulse
/*
Chances are you found yourself doing smoothstep(c-w,c,x)-smoothstep(c,c+w,x) very
often. I do, for example when I need to isolate some features in a signal. For those cases,
this cubicPulse() below is my new friend and will be yours too soon. Bonus - you can
also use it as a performant replacement for a gaussian.
*/
float cubicPulse( float c, float w, float x )
{
    x = fabs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}
#endif // CUBIC_PULSE_IQ