/// @param state

function VinylMasterSetMute(_state)
{
    static _system = __VinylSystem();
    
    if (_state == undefined) return;
    
    _system.__masterMute = _state;
    audio_set_master_gain(0, _state? 0 : _system.__masterGain);
}