/// Exports the current master and mix group settings as a struct or JSON string. This data can
/// then be imported later to restore the current settings.
/// 
/// The `mode` parameter control what datatype is exported. It can be one of the following values:
/// `0` = Output raw data (struct\s)
/// `1` = Output JSON as a string
/// `2` = Output pretty JSON as a string
/// 
/// @param mode

function VinylSettingsExport(_mode)
{
    static _system = __VinylSystem();
    static _mixGroupArray = _system.__mixGroupArray;
    
    var _mixGroupsData = {};
    var _i = 0;
    repeat(array_length(_mixGroupArray))
    {
        var _mixGroup = _mixGroupArray[_i];
        
        _mixGroupsData[$ _mixGroup.__exportName] = {
            gain: _mixGroup.__gain,
            mute: _mixGroup.__mute,
        };
        
        ++_i;
    }
    
    var _outputData = {
        master: {
            gain: _system.__masterGain,
            mute: _system.__masterMute,
        },
        mixGroup: _mixGroupsData,
    };
    
    if (_mode == 1)
    {
        return json_stringify(_outputData);
    }
    else if (_mode == 2)
    {
        return json_stringify(_outputData, true);
    }
    else
    {
        return _outputData;
    }
}