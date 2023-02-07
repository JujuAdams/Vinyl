function VinylGlobalTransposeGet()
{
    static _globalData = __VinylGlobalData();
    return _globalData.__transposeSemitones;
}