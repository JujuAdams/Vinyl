/// Enables and disables live update
///   N.B. This function only works when running from the IDE for the Windows, Mac, or Linux export targets
/// 
/// @param state

function VinylLiveUpdateSet(_state)
{
    if (!__VinylGetLiveUpdateEnabled()) return;
    
    if (_state != global.__vinylLiveUpdate)
    {
        __VinylTrace(_state? "Turned live update on" : "Turned live update off");
        global.__vinylLiveUpdate = _state;
    }
}