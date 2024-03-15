// Feather disable all

function __VedClassProject() constructor
{
    __pathYY = undefined;
    __pathVinyl = undefined;
    
    __ident = undefined;
    
    
    
    
    
    static __Update = function()
    {
        
    }
    
    static __Serialize = function()
    {
        return {
            ident: __ident,
        };
    }
    
    static __Deserialize = function(_input)
    {
        __ident = _input.ident;
    }
    
    
    
    
    
    static __SetPaths = function(_yyPath)
    {
        __pathYY        = _yyPath;
        __pathVinyl     = filename_dir(__pathYY) + "/" + __VED_PROJECT_FILENAME;
        __pathGenMacros = filename_dir(__pathYY) + "/scripts/__VinylGenMacros/__VinylGenMacros.gml";
    }
    
    static __CreateFromGameMakerProject = function(_yyPath)
    {
        __SetPaths(_yyPath);
        __VedTrace("Creating \"", __pathVinyl, "\" next to \"", __pathYY, "\"");
        
        if (not file_exists(__pathYY))
        {
            __VedWarning("GameMaker project doesn't exist");
            __VedModalOpen(__VedClassModalOperationFailed).__path = __pathYY;
            return false;
        }
        
        __ident = __VedGenerateUUID();
        
        __Save();
        __VedTrace("Create successful!");
        
        __VedModalOpen(__VedClassModalCreateSuccess).__path = __pathVinyl;
        
        return true;
    }
    
    static __LoadFromGameMakerProject = function(_yyPath, _showPopUp)
    {
        __SetPaths(_yyPath);
        __VedTrace("Loading \"", __pathYY, "\" + \"", __pathVinyl, "\"");
        
        if (not __LoadGameMakerProject()) return false;
        if (not __LoadVinylProject()) return false;
        
        __VedTrace("Load successful!");
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
            _json = json_stringify(_string);
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
        __VedTrace("Unloading \"", __pathYY, "\" + \"", __pathVinyl, "\"");
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
    }
    
    static __Compile = function()
    {
        var _buffer = buffer_create(2048, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, "#macro VINYL_VERSIONED_IDENT  \"");
        buffer_write(_buffer, buffer_text, string(__ident));
        buffer_write(_buffer, buffer_text, "\"\n");
        buffer_save(_buffer, __pathGenMacros);
        buffer_delete(_buffer);
    }
}