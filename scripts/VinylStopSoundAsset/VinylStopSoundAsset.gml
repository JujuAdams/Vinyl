/// Stops all playing sounds that use the given sound asset.
/// 
/// N.B. For some complex voices, such as an HLT brain, this may not stop the voice itself, only
///      one part of that voice.
/// 
/// @param soundAsset

function VinylStopSoundAsset(_soundAsset)
{
    if (audio_exists(_soundAsset))
    {
        //TODO - Stop relevant queues and HLTs too
        audio_stop_sound(_soundAsset);
    }
}