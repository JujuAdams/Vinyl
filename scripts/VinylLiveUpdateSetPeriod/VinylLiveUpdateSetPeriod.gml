/// @param frames

function VinylLiveUpdateSetPeriod(_frames)
{
    if (!__VinylGetLiveUpdateEnabled()) return;
    
    if (_frames != global.__vinylLiveUpdatePeriod)
    {
        if (_frames > 0)
        {
            time_source_resume(global.__vinylLiveUpdateTS);
            time_source_reconfigure(global.__vinylLiveUpdateTS, _frames, time_source_units_frames, __VinylUpdateData, [], -1);
        }
        else
        {
            time_source_pause(global.__vinylLiveUpdateTS);
        }
        
        global.__vinylLiveUpdatePeriod = _frames;
        __VinylTrace("Turned live update period set to ", _frames);
    }
}