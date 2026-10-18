/// @param stringOrData

function VinylSettingsImport(_inputData)
{
    static _system = __VinylSystem();
    static _mixGroupArray = _system.__mixGroupArray;
    
    try
    {
        VinylSettingsAssertValid(_inputData);
    }
    catch(_error)
    {
        __VinylTrace(_error);
        __VinylTrace("Vinyl settings validation failed");
    }
    
    if (is_string(_inputData))
    {
        _inputData = json_parse(_inputData);
    }
    
    if (struct_exists(_inputData, "master"))
    {
        VinylMasterSetGain(_inputData.master[$ "gain"]);
        VinylMasterSetMute(_inputData.master[$ "mute"]);
    }
    
    if (struct_exists(_inputData, "mixGroup"))
    {
        //"Pull" from input data into existing mix groups rather than "pushing" from input data
        //into mix groups that might not exist
        var _mixGroupsData = _inputData.mixGroup;
        var _i = 0;
        repeat(array_length(_mixGroupArray))
        {
            var _mixGroup = _mixGroupArray[_i];
            var _mixGroupData = _mixGroupsData[$ _mixGroup.__exportName];
            if (_mixGroupData != undefined)
            {
                VinylMixGroupSetGain(_i, _mixGroupData[$ "gain"]);
                VinylMixGroupSetMute(_i, _mixGroupData[$ "mute"]);
            }
            
            ++_i;
        }
    }
}