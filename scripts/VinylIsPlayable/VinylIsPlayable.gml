/// Returns if the given pattern/asset exists and can be played by Vinyl
/// 
/// @param pattern/asset

function VinylIsPlayable(_id)
{
    static _globalData = __VinylGlobalData();
    
    //Simple asset existence check
    if (is_numeric(_id)) return audio_exists(_id);
    
    var _patternDict = _globalData.__patternDict; //Don't use a static here because this struct can be recreated
    return variable_struct_exists(_patternDict, _id);
}