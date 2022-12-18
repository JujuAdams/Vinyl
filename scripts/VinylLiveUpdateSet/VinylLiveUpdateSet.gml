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