function VinylSystemGetTopLevelVoiceCount()
{
    static _topLevelArray = __VinylGlobalData().__topLevelArray;
    
    return array_length(_topLevelArray);
}