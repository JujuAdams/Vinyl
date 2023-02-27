function __VinylInstanceGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    return _idToInstanceDict[? _id];
}