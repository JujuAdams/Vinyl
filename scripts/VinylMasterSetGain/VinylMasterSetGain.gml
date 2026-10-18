/// @param gain

function VinylMasterSetGain(_gain)
{
    static _system = __VinylSystem();
    
    if (_gain == undefined) return;
    
    _system.__masterGain = _gain;
    audio_set_master_gain(0, _system.__masterMute? 0 : _gain);
}