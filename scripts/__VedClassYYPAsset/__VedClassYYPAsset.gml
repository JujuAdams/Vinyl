// Feather disable all

function __VedClassYYPAsset() constructor
{
    static _system = __VedSystem();
    
    __partialPath  = undefined;
    __absolutePath = undefined;
    __name         = undefined;
    
    __hasData = false;
    
    __audioGroup = undefined;
    __attributes = undefined;
    __assetTags  = undefined;
    
    
    
    static __GetName = function()
    {
        return __name;
    }
    
    static __CompilePlay = function(_buffer)
    {
        __VedError("Cannot compile .yyp asset");
    }
    
    static __GenerateVinylAsset = function()
    {
        var _new = new __VedClassVinylAsset();
        _new.__name = __name;
        return _new;
    }
    
    static __SetAudioGroup = function(_newAudioGroup)
    {
        __EnsureData();
        if (__audioGroup == _newAudioGroup) return;
        
        var _buffer = buffer_load(__yyPath);
        var _fileString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _searchString1 = "\"name\": \"" + __audioGroup + "\"";
        var _searchString2 = "\"path\": \"audiogroups/" + __audioGroup + "\"";
        
        var _pos = string_pos(_searchString1, _fileString);
        if (_pos < 0)
        {
            __VinylTrace("Warning! Could not find audio group \"", __audioGroup, "\" in \"", __yyPath, "\" (first check)");
            return;
        }
        
        var _pos = string_pos(_searchString2, _fileString);
        if (_pos < 0)
        {
            __VinylTrace("Warning! Could not find audio group \"", __audioGroup, "\" in \"", __yyPath, "\" (second check)");
            return;
        }
        
        __audioGroup = _newAudioGroup;
        
        _fileString = string_replace(_fileString, _searchString1, "\"name\": \"" + _newAudioGroup + "\"");
        _fileString = string_replace(_fileString, _searchString2, "\"path\": \"audiogroups/" + _newAudioGroup + "\"");
        __Save(_fileString);
    }
    
    static __SetAssetTag = function(_assetTag, _state)
    {
        __EnsureData();
        
        var _changed = false;
        if (_state)
        {
            if (not array_contains(__assetTags, _assetTag))
            {
                array_push(__assetTags, _assetTag);
                array_sort(__assetTags, true);
                _changed = true;
            }
        }
        else
        {
            var _index = __VinylArrayFindIndex(__assetTags, _assetTag);
            if (_index != undefined)
            {
                array_delete(__assetTags, _index, 1);
                _changed = true;
            }
        }
        
        if (not _changed) return;
        
        //var _buffer = buffer_load(__absolutePath);
        //var _fileString = buffer_read(_buffer, buffer_text);
        //buffer_delete(_buffer);
    }
    
    static __SetAttributes = function(_newAttributes)
    {
        __EnsureData();
        if (__attributes == _newAttributes) return;
        
        var _buffer = buffer_load(__absolutePath);
        var _fileString = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _searchString = "\"compression\": " + string(__attributes);
        
        var _pos = string_pos(_searchString, _fileString);
        if (_pos < 0)
        {
            __VinylTrace("Warning! Could not find attribute ", __attributes, " in \"", __absolutePath, "\"");
            return;
        }
        
        __attributes = _newAttributes;
        
        _fileString = string_replace(_fileString, _searchString, "\"compression\": " + string(_newAttributes));
        __Save(_fileString);
    }
    
    static __Save = function(_fileString)
    {
        var _buffer = buffer_create(string_byte_length(_fileString), buffer_grow, 1);
        buffer_write(_buffer, buffer_text, _fileString);
        buffer_save(_buffer, __absolutePath);
        buffer_delete(_buffer);
        
        __VedLog("Saved \"", __absolutePath, "\"");
    }
    
    static __EnsureData = function()
    {
        if (__hasData) return;
        __hasData = true;
        
        __VedLog("Ensuring data for GameMaker asset \"", __name, "\"");
        __absolutePath = filename_dir(_system.__project.__pathYY) + "/" + __partialPath;
        
        var _buffer = buffer_load(__absolutePath);
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        var _json = undefined;
        _json = json_parse(_string);
        
        __audioGroup = _json.audioGroupId.name;
        __attributes = _json.compression;
        
        var _foundTagsArray = _json[$ "tags"];
        if (is_array(_foundTagsArray))
        {
            __assetTags = variable_clone(_foundTagsArray);
        }
        else
        {
            __assetTags = [];
        }
        
        _system.__project.__libAudioGroup.__GetByName(__audioGroup).__Add(__name);
    }
    
    static __BuildUI = function(_multiselector)
    {
        __EnsureData();
        
        //All the GameMaker properties
        if (ImGui.BeginTable("GameMaker Properties", 1, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 160))
        {
            var _audioGroupArray = _system.__project.__libAudioGroup.__GetNameArray();
            var _assetTagArray   = _system.__project.__libAssetTag.__GetNameArray();
            var _yypAssetDict    = _system.__project.__libYYPAsset.__GetDictionary();
            
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("GameMaker Project");
            ImGui.TableHeadersRow();
            
            //Audio group drop-down
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            __VED_NEXT_UI_FILLS_WIDTH
            if (ImGui.BeginCombo("##Audio Group", __audioGroup, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_audioGroupArray))
                {
                    var _audioGroup = _audioGroupArray[_i];
                    if (ImGui.Selectable(_audioGroup, __audioGroup == _audioGroup))
                    {
                        _multiselector.__ForEachSelected(_yypAssetDict,
                        method({
                            __audioGroup: _audioGroup,
                        },
                        function(_name, _struct)
                        {
                            _struct.__SetAudioGroup(__audioGroup);
                        }));
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            //Asset tag drop-down
            var _soundAssetTags = __assetTags;
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            __VED_NEXT_UI_FILLS_WIDTH
            if (ImGui.BeginCombo("##Asset Tag", __VedAssetTagsGetAbbreviatedName(_soundAssetTags), ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_assetTagArray))
                {
                    var _assetTag = _assetTagArray[_i];
                    
                    var _oldValue = array_contains(_soundAssetTags, _assetTag);
                    var _newValue = ImGui.Checkbox(_assetTag + "##Asset Tag Checkbox", _oldValue);
                    
                    if (_oldValue != _newValue)
                    {
                        _multiselector.__ForEachSelected(_yypAssetDict,
                        method({
                            __assetTag: _assetTag,
                            __newValue: _newValue,
                        },
                        function(_name, _struct)
                        {
                            _struct.__SetAssetTag(__assetTag, __newValue);
                        }));
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            //Compression settings
            static _compressionArray = ["WAV",
                                        "OGG - Decompress during playback",
                                        "OGG - Decompress when loaded and store in RAM",
                                        "OGG - Stream from disk (exports .ogg files)"];
            var _i = 0;
            repeat(array_length(_compressionArray))
            {
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                if (ImGui.RadioButton(_compressionArray[_i], (__attributes == _i)))
                {
                    _multiselector.__ForEachSelected(_yypAssetDict,
                    method({
                        __attributes: _i,
                    },
                    function(_name, _struct)
                    {
                        _struct.__SetAttributes(__attributes);
                    }));
                }
                
                ++_i;
            }
            
            //We're done!
            ImGui.EndTable();
        }
    }
}