Vinyl
@jujuadams    2022-12-25

---

Vinyl is an audio playback tool targeting professional use cases, allowing sound
designers who are familiar with standard tooling to more easily complete a  mix for
GameMaker games. In contrast to GameMaker's native functions, Vinyl uses a different
system of units to control audio gain. Vinyl is *not* a drop-in replacement for
GameMaker's audio system therefore and, if you've not worked with audio software before,
you'll need to learn a bit about audio before implementing it.

Vinyl uses the decibel (dB) scale to control playback volume. A value of 0 dB in Vinyl
is equivalent to a value of 1 for GameMaker's native audio functions. Using negative gain
values in Vinyl reduces the volume. -10 dB halves the perceived loudness, -20 dB halves
it again and so on. By default, -60 dB is considered "silent" and is functionally
equivalent to a value of 0 for GameMaker's native audio functions. Vinyl also supports
increasing the volume of audio beyond what GameMaker can normally achieve.

---

Whilst GameMaker's functions use a so-called "gain" parameter, this is unfortunately
incorrectly named. GameMaker's gain parameters control the *amplitude* of the output
audio signal, not the actual signal gain. Using a "gain" value of 0.5, for example,
causes GameMaker to halve the amplitude of the output signal. This isn't the same thing
as the signal being half as loud though! Humans don't perceive loudness on a linear
scale and instead we perceive loudness on a roughly logarithmic scale.

We have a system of measurement that reflects this quirk of human perception; this is
called the decibel scale. The unit of a "decibel" is absolutely everywhere in audio
engineering and design because it's so useful. Vinyl uses this decibel system throughout
the library and all gain values are in decibels. This not only makes Vinyl much more
natural to use for audio professionals.

Converting from GameMaker's native amplitude "gain" to real gain value takes a bit of
getting used to.

    - Amplitude value of 2   = gain value of +6 db (approx.)
    - Amplitude value of 1   = gain value of +0 db
    - Amplitude value of 0.5 = gain value of -6 db (approx.)
    - Amplitude value of 0   = gain value of -∞ db (negative infinity)

In reality, of course, -∞ db isn't a sensible value (not least because we can never
reach that value when fading out audio!) so we choose another value instead to act as
the functional lower bound instead. This is defined by VINYL_GAIN_SILENCE which defaults
to -60 dB.

Unlike GameMaker, Vinyl supports making audio louder than what would normally be possible
with GameMaker's native functions. We do need to set an upper limit however to prevent
clipping and other distortion; this is controlled by VINYL_SYSTEM_MAX_GAIN which defaults
to +12 dB.