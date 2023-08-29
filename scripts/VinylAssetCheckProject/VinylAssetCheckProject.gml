// Feather disable all
function VinylAssetCheckProject()
{
    static _globalData = __VinylGlobalData();
    static _projectAssetDict = _globalData.__projectAssetNameDict;
    static _projectFileHash  = undefined;
    
    var _funcFindSource = function(_yyPath)
    {
        var _basePath = filename_change_ext(_yyPath, "");
        
        if (file_exists(_basePath + ".wav")) return _basePath + ".wav";
        if (file_exists(_basePath + ".ogg")) return _basePath + ".ogg";
        
        if (file_exists(_basePath + ".mp3")) throw ".mp3 files are not supported";
        if (file_exists(_basePath + ".wma")) throw ".wma files are not supported";
        
        return undefined;
    }
    
    var _funcAssetDictFallback = function()
    {
        static _projectAssetDict = __VinylGlobalData().__projectAssetNameDict;
        
        static _firstScan = true;
        if (_firstScan)
        {
            _firstScan = false;
            
            __VinylTrace("Using asset dictionary fallback");
            
            var _i = 0;
            repeat(1000000)
            {
                if (not audio_exists(_i)) break;
                _projectAssetDict[$ audio_get_name(_i)] = undefined;
                ++_i;
            }
        }
    }
    
    //Even if we're not doing live updates, build an index of asset names
    //This is used in VinylSystemReadConfig() to verify asset names
    if (!__VinylGetLiveUpdateEnabled())
    {
        _funcAssetDictFallback();
        return;
    }
    
    if (!file_exists(GM_project_filename))
    {
        __VinylError("Could not find \"", GM_project_filename, "\"\nTurn on the \"Disable file system sandbox\" game option for this platform");
        return;
    }
    
    var _firstUpdate = (_projectFileHash == undefined);
    
    var _foundHash = md5_file(GM_project_filename);
    if (_foundHash == _projectFileHash)
    {
        var _t = get_timer();
        
        var _projectAssetArray = variable_struct_get_names(_projectAssetDict);
        var _i = 0;
        repeat(array_length(_projectAssetArray))
        {
            var _projectAsset = _projectAssetDict[$ _projectAssetArray[_i]];
            if (is_struct(_projectAsset)) _projectAsset.__CheckForChange();
            
            ++_i;
        }
        
        __VinylTrace("Found differences in existing files in ", (get_timer() - _t)/1000, "ms");
        return;
    }
    
    _projectFileHash = _foundHash;
    
    var _projectDirectory = filename_dir(GM_project_filename) + "/";
    
    var _success = undefined;
    var _t = get_timer();
    
    try
    {
        var _buffer = buffer_load(GM_project_filename);
        if (buffer_get_size(_buffer) <= 0) throw "File is empty";
        
        var _string = buffer_peek(_buffer, 0, buffer_text);
        var _json = json_parse(_string);
        
        __VinylTrace("Parsed project file in ", (get_timer() - _t)/1000, "ms");
        
        var _t = get_timer();
        var _resourcesArray = _json.resources;
        
        //Build an easily reference dataset containing only sound resources
        var _foundResourceArray    = [];
        var _foundResourceNameDict = {};
        
        var _i = 0;
        repeat(array_length(_resourcesArray))
        {
            var _resourceData = _resourcesArray[_i].id;
            if (string_copy(_resourceData.path, 1, 6) == "sounds")
            {
                array_push(_foundResourceArray, _resourceData);
                _foundResourceNameDict[$ _resourceData.name] = _resourceData;
            }
            
            ++_i;
        }
        
        __VinylTrace("Found sound resources in ", (get_timer() - _t)/1000, "ms");
        
        //First, remove any assets from the game that have been removed from the project
        var _projectAssetArray = variable_struct_get_names(_projectAssetDict);
        var _i = 0;
        repeat(array_length(_projectAssetArray))
        {
            var _name = _projectAssetArray[_i];
            if (variable_struct_exists(_foundResourceNameDict, _name))
            {
                ++_i;
            }
            else
            {
                var _projectAsset = _projectAssetDict[$ _name];
                if (is_struct(_projectAsset)) _projectAsset.__Destroy();
            }
        }
        
        var _i = 0;
        repeat(array_length(_foundResourceArray))
        {
            var _resourceData = _foundResourceArray[_i];
            var _name = _resourceData.name;
            var _projectAsset = _projectAssetDict[$ _name];
            
            //Second, add any new files
            if (_projectAsset == undefined)
            {
                var _path = _funcFindSource(_projectDirectory + _resourceData.path);
                if (_path == undefined) throw "Sound source file not found for " + string(_resourceData.path) + " (only .wav and .ogg are supported)";
                
                var _ = new __VinylClassProjectAsset(_name, _path, _firstUpdate);
            }
            else
            {
                //Third, check for changes in any existing files
                _projectAsset.__CheckForChange();
            }
            
            ++_i;
        }
        
        _success = true;
        __VinylTrace("Found differences across new/existing files in ", (get_timer() - _t)/1000, "ms");
    }
    catch(_error)
    {
        __VinylReportError(_error, GM_project_filename, _firstUpdate);
        
        _funcAssetDictFallback();
    }
    finally
    {
        if ((_buffer != undefined) && (_buffer >= 0)) buffer_delete(_buffer);
    }
    
    return _success;
}