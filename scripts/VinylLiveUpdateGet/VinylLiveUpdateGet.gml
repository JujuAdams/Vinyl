function VinylFastLiveUpdateGet()
{
    if (!__VinylGetLiveUpdateEnabled()) return false;
    return global.__vinylLiveUpdate;
}