function VinylFastLiveUpdateGet()
{
    if (!__VinylGetLiveUpdateEnabled()) return 0;
    return global.__vinylLiveUpdatePeriod;
}