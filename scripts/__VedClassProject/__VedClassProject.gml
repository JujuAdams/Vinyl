// Feather disable all

function __VedClassProject() constructor
{
    __pathYY        = undefined;
    __pathVinyl     = undefined;
    __pathGenMacros = undefined;
    __pathGenCode   = undefined;
    
    __ident = undefined;
    
    __libYYPAssets   = new __VedClassLibrary();
    __libVinylAssets = new __VedClassLibrary();
    __libTriggers    = new __VedClassLibrary();
    
    __changesArray = [];
    
    
    
    static __Update = function()
    {
        
    }
    
    static __Serialize = function()
    {
        var _output = {
            ident: __ident,
            assets: [],
            triggers: [],
        };
        
        __libVinylAssets.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__Serialize(_metadata.__array);
        },
        {
            __array: _output.assets,
        });
        
        __libTriggers.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__Serialize(_metadata.__array);
        },
        {
            __array: _output.triggers,
        });
        
        return _output;
    }
    
    static __Deserialize = function(_input)
    {
        __ident = _input.ident;
        __libVinylAssets.__ImportArray(__VedDeserializeArray(__VedClassVinylAsset, _input.assets));
        __libTriggers.__ImportArray(__VedDeserializeArray(__VedClassTrigger, _input.triggers));
    }
    
    
    
    
    
    static __SetPaths = function(_yyPath)
    {
        __pathYY        = _yyPath;
        __pathVinyl     = filename_dir(__pathYY) + "/" + __VED_PROJECT_FILENAME;
        __pathGenMacros = filename_dir(__pathYY) + "/scripts/__VinylGenMacros/__VinylGenMacros.gml";
        __pathGenCode   = filename_dir(__pathYY) + "/scripts/__VinylGenCode/__VinylGenCode.gml";
    }
    
    static __CreateFromGameMakerProject = function(_yyPath)
    {
        __SetPaths(_yyPath);
        __VedLog("Creating \"", __pathVinyl, "\" next to \"", __pathYY, "\"");
        
        if (not file_exists(__pathYY))
        {
            __VedWarning("GameMaker project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        __ident = __VedGenerateUUID();
        
        __LoadGameMakerProject();
        __Correlate();
        __Save();
        __VedLog("Create \"", __pathVinyl, "\" successful!");
        
        __VedModalOpen(__VedClassModalCreateSuccess).__path = __pathVinyl;
        
        return true;
    }
    
    static __LoadFromGameMakerProject = function(_yyPath, _showPopUp)
    {
        __SetPaths(_yyPath);
        __VedLog("Loading \"", __pathYY, "\" + \"", __pathVinyl, "\"");
        
        if (not __LoadGameMakerProject()) return false;
        if (not __LoadVinylProject()) return false;
        
        __Correlate();
        
        __VedLog("Load successful!");
        if (_showPopUp) __VedModalOpen(__VedClassModalLoadSuccess).__path = __pathYY;
        
        return true;
    }
    
    static __LoadGameMakerProject = function()
    {
        if (not file_exists(__pathYY))
        {
            __VedWarning("GameMaker project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        var _buffer = buffer_load(__pathYY);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = undefined;
        try
        {
            _json = json_parse(_string);
        }
        catch(_error)
        {
            show_debug_message(_error);
        }
        
        if (_json == undefined)
        {
            __VedWarning("Failed to parse GameMaker project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        //Unpack sounds assets we find the .yyp file
        var _libYYPAssets = __libYYPAssets;
        var _resourcesArray = _json.resources;
        var _i = 0;
        repeat(array_length(_resourcesArray))
        {
            var _resourceData = _resourcesArray[_i];
            var _id = _resourceData.id;
            var _path = _id.path;
            var _name = _id.name;
            
            if (string_copy(_path, 1, 6) == "sounds")
            {
                var _yypAsset = new __VedClassYYPAsset();
                _yypAsset.__partialPath = _path;
                _yypAsset.__name = _name;
                
                _libYYPAssets.__Add(_name, _yypAsset);
            }
            
            ++_i;
        }
        
        __libYYPAssets.__SortNames(true);
        
        try
        {
            return true;
        }
        catch(_error)
        {
            show_debug_message(_error);
            __VedWarning("Failed to deserialize GameMaker project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
    }
    
    static __LoadVinylProject = function()
    {
        if (not file_exists(__pathVinyl))
        {
            __VedWarning("Vinyl project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathVinyl;
            return false;
        }
        
        var _buffer = buffer_load(__pathVinyl);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = undefined;
        try
        {
            _json = json_parse(_string);
        }
        catch(_error)
        {
            show_debug_message(_error);
        }
        
        if (_json == undefined)
        {
            __VedWarning("Failed to parse Vinyl project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathVinyl;
            return false;
        }
        
        try
        {
            __Deserialize(_json);
            return true;
        }
        catch(_error)
        {
            show_debug_message(_error);
            __VedWarning("Failed to deserialize Vinyl project");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathVinyl;
            return false;
        }
    }
    
    static __Unload = function()
    {
        __VedLog("Unloading \"", __pathYY, "\" + \"", __pathVinyl, "\"");
    }
    
    static __Save = function()
    {
        var _output = __Serialize();
        var _string = json_stringify(_output, true);
        
        var _buffer = buffer_create(string_byte_length(_string), buffer_grow, 1);
        buffer_write(_buffer, buffer_text, _string);
        buffer_save(_buffer, __pathVinyl);
        buffer_delete(_buffer);
        
        __Compile();
        
        __VedLog("Save \"", __pathVinyl, "\" successful!");
    }
    
    static __Correlate = function()
    {
        var _yypNameArray = __libYYPAssets.__GetNameArray();
        var _yypDict      = __libYYPAssets.__GetDictionary();
        
        var _vinylNameArray = __libVinylAssets.__GetNameArray();
        var _vinylDict      = __libVinylAssets.__GetDictionary();
        
        var _missingInVinyl = [];
        var _missingInYYP   = [];
        
        var _i = 0;
        repeat(array_length(_yypNameArray))
        {
            var _yypName = _yypNameArray[_i];
            if (not variable_struct_exists(_vinylDict, _yypName))
            {
                __VedLog("\"", _yypName, "\" is missing in Vinyl project");
                array_push(_missingInVinyl, _yypDict[$ _yypName]);
            }
            
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(_vinylNameArray))
        {
            var _vinylName = _vinylNameArray[_i];
            if (not variable_struct_exists(_yypDict, _vinylName))
            {
                __VedLog("\"", _vinylName, "\" is missing in GameMaker project");
                array_push(_missingInYYP, _vinylDict[$ _vinylName]);
            }
            
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(_missingInVinyl))
        {
            var _yypAsset = _missingInVinyl[_i];
            __VedLog("Creating Vinyl asset for GameMaker sound \"", _yypAsset.__GetName(), "\"");
            __libVinylAssets.__Add(_yypAsset.__GetName(), _yypAsset.__GenerateVinylAsset());
            ++_i;
        }
    }
    
    static __Compile = function()
    {
        var _buffer = buffer_create(2048, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "/// Autogenerated on ");
        buffer_write(_buffer, buffer_text, date_datetime_string(date_current_datetime()));
        buffer_write(_buffer, buffer_text, " by Vinyl Editor ");
        buffer_write(_buffer, buffer_text, __VED_VERSION);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __VED_DATE);
        buffer_write(_buffer, buffer_text, "\n\n");
        buffer_write(_buffer, buffer_text, "#macro VINYL_VERSIONED_IDENT  \"");
        buffer_write(_buffer, buffer_text, string(__ident));
        buffer_write(_buffer, buffer_text, "\"\n");
        buffer_save_ext(_buffer, __pathGenMacros, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
        
        
        
        var _buffer = buffer_create(2048, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "/// Autogenerated on ");
        buffer_write(_buffer, buffer_text, date_datetime_string(date_current_datetime()));
        buffer_write(_buffer, buffer_text, " by Vinyl Editor ");
        buffer_write(_buffer, buffer_text, __VED_VERSION);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __VED_DATE);
        buffer_write(_buffer, buffer_text, "\n");
        buffer_write(_buffer, buffer_text, "\n");
        buffer_write(_buffer, buffer_text, "function __VinylGenPlay()\n");
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, "    static _data = undefined;\n");
        buffer_write(_buffer, buffer_text, "    \n");
        buffer_write(_buffer, buffer_text, "    if (_data == undefined)\n");
        buffer_write(_buffer, buffer_text, "    {\n");
        buffer_write(_buffer, buffer_text, "        _data = {};\n");
        buffer_write(_buffer, buffer_text, "        \n");
        
        __libVinylAssets.__ForEach(function(_index, _name, _scope, _metadata)
        {
            _scope.__CompilePlay(_metadata.__buffer);
        },
        {
            __buffer: _buffer,
        });
        
        //__libTriggers.__ForEach(function(_index, _name, _scope, _metadata)
        //{
        //    _scope.__CompilePlay(_metadata.__buffer);
        //},
        //{
        //    __buffer: _buffer,
        //});
        
        buffer_write(_buffer, buffer_text, "    }\n");
        buffer_write(_buffer, buffer_text, "    \n");
        buffer_write(_buffer, buffer_text, "    return _data;\n");
        buffer_write(_buffer, buffer_text, "}\n");
        buffer_write(_buffer, buffer_text, "\n");
        
        buffer_save_ext(_buffer, __pathGenCode, 0, buffer_tell(_buffer));
        buffer_delete(_buffer);
    }
}