function VinylLiveUpdateGet()
{
    if (!__VinylGetLiveUpdateEnabled()) return false;
    return global.__vinylLiveUpdate;
}