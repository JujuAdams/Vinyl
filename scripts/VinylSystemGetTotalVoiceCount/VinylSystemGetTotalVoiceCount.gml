function VinylSystemGetTotalVoiceCount()
{
    static _topLevelArray = __VinylGlobalData().__topLevelArray;
    
    var _count = 0;
    
    var _i = 0;
    repeat(array_length(_topLevelArray))
    {
        _count += _topLevelArray[_i].__GetCount();
        ++_i;
    }
    
    return _count;
}