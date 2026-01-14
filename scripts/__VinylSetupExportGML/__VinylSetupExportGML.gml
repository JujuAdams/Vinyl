// Feather disable all

/// Exports the current Vinyl setup as JSON expressed in GML code. The root node of this JSON is
/// always an array. This function returns a string that can be copy-pasted into your codebase, for
/// example so that the inylSetupImportJSON() function can be called on boot with the required
/// Vinyl setup information.
/// 
/// You can read more about the JSON format that Vinyl exports in the "Vinyl Setup JSON Format"
/// note asset included with the library code.
/// 
/// @param [useMacros=false]
/// @param [ignoreEmpty=true]

function __VinylSetupExportGML(_useMacros = false, _ignoreEmpty = true)
{
    static _duckerDict   = __VinylSystem().__duckerDict;
    static _mixDict      = __VinylSystem().__mixDict;
    static _patternMap   = __VinylSystem().__patternMap;
    static _soundMap     = __VinylSystem().__soundMap;
    static _metadataDict = __VinylSystem().__metadataDict;
    
    if (not VINYL_LIVE_EDIT)
    {
        __VinylError("VINYL_LIVE_EDIT must be set to <true>");
        return;
    }
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_text, "[\n");
    
    var _patternExportedMap = ds_map_create();
    var _soundExportedMap   = ds_map_create();
    
    //Export ducker definitions
    var _namesArray = struct_get_names(_duckerDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        _duckerDict[$ _namesArray[_i]].__ExportGML(_buffer, "    ");
        ++_i;
    }
    
    //Export mix definitions
    var _namesArray = struct_get_names(_mixDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        _mixDict[$ _namesArray[_i]].__ExportGML(_buffer, _useMacros, _soundExportedMap, _patternExportedMap, _ignoreEmpty);
        ++_i;
    }
    
    //Export pattern definitions
    var _namesArray = ds_map_keys_to_array(_patternMap);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        
        if (not ds_map_exists(_patternExportedMap, _name))
        {
            _patternMap[? _name].__ExportGML(_buffer, "    ", _useMacros);
        }
        
        ++_i;
    }
    
    //Export sound definitions
    var _namesArray = ds_map_keys_to_array(_soundMap);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        
        if (not ds_map_exists(_soundExportedMap, _name))
        {
            _soundMap[? _name].__ExportGML(_buffer, "    ", _ignoreEmpty);
        }
        
        ++_i;
    }
    
    //Export metadata definitions
    var _namesArray = struct_get_names(_metadataDict);
    array_sort(_namesArray, true);
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        
        buffer_write(_buffer, buffer_text, "    {\n");
        buffer_write(_buffer, buffer_text, "        metadata: \"");
        buffer_write(_buffer, buffer_text, _name);
        buffer_write(_buffer, buffer_text, "\",\n");
        
        buffer_write(_buffer, buffer_text, "        data: ");
        __VinylBufferWriteGML(_buffer, _metadataDict[$ _name], true, "        ");
        buffer_write(_buffer, buffer_text, ",\n");
        buffer_write(_buffer, buffer_text, "    },\n");
        
        ++_i;
    }
    
    buffer_write(_buffer, buffer_text, "]");
    
    //Get the string
    var _string = buffer_peek(_buffer, 0, buffer_string);
    buffer_delete(_buffer);
    
    //Clean up
    ds_map_destroy(_patternExportedMap);
    ds_map_destroy(_soundExportedMap);
    
    return _string;
}