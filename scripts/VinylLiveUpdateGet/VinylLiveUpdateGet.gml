/// Returns whether live update is enabled

function VinylLiveUpdateGet()
{
    if (!__VinylGetLiveUpdateEnabled()) return false;
    return global.__vinylLiveUpdate;
}