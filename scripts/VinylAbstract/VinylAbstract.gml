// Feather disable all

/// Creates an abstract Vinyl voice and returns its index. Abstract voices do not inherently play
/// any audio but can be controlled as though they were standard voices. Abstract voices are
/// helpful for creating custom audio behaviors that Vinyl doesn't natively support whilst also
/// allowing Vinyl to control their gain and pitch.
/// 
/// Abstract voices are always considered looping and `VinylSetLoop()` will not set state on an
/// abstract voice. `VinylGetLoop()` will always return `true`. You may use `VinylGetFinalGain()`
/// and `VinylGetFinalPitch()` to get final output values for the voice.
/// 
/// Whilst `VinylAbstract()` is good for one-off abstract voices, you may find that you'd like to
/// create abstract voices with similar properties. Please see `VinylSetupAbstract()` for more
/// information.
/// 
/// N.B. Abstract voices have no "duration" and won't stop playing by themselves. You must call
///      `VinylStop()` on the voice when you're done with the abstract voice or else you will
///      create a memory leak. You may also use `VinylAbstractStopAll()` to stop all current
///      abstract voices.
/// 
/// @param [gain=1]
/// @param [pitch=1]
/// @param [duckerName]
/// @param [duckPriority]
/// @param [mixName]

function VinylAbstract(_gainLocal = 1, _pitchLocal = 1, _duckerNameLocal = undefined, _duckPrioLocal = undefined, _mixName = undefined)
{
    return (new __VinylClassVoiceAbstract(undefined, _gainLocal, _pitchLocal, _duckerNameLocal, _duckPrioLocal, _mixName)).__voiceReference;
}