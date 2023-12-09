// Feather disable all
/// Enables and disables live update
/// 
///   N.B. This function only works when running from the IDE for the Windows, Mac, or Linux export targets
/// 
/// @param state

function VinylLiveUpdateSet(_state)
{
    static _globalData = __VinylGlobalData();
    
    if (!__VinylGetLiveUpdateEnabled()) return;
    
    if (_state != _globalData.__liveUpdate)
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(_state? "Turned live update on" : "Turned live update off");
        _globalData.__liveUpdate = _state;
    }
}
