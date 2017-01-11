// demo0.ck
// basic demo showing time and duration

SinOsc s => dac;

3::second + now => time later;

while( now < later )
{
    s.freq() + 60 => s.freq;
    <<<now>>>;
    0.5::second => now;
}

<<<now>>>;