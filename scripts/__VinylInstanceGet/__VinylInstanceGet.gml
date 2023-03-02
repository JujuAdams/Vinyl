function __VinylInstanceGet(_id)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    return _idToVoiceDict[? _id];
}