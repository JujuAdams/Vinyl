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
    
    static __Compile = function(_buffer)
    {
        __VedError("Cannot compile .yyp asset");
    }
    
    static __GenerateVinylAsset = function()
    {
        var _new = new __VedClassVinylAsset();
        _new.__name = __name;
        return _new;
    }
    
    static __SetAudioGroup = function()
    {
        
    }
    
    static __SetAssetTag = function()
    {
        
    }
    
    static __SetAttributes = function()
    {
        
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
    }
    
    static __BuildUI = function(_multiselector)
    {
        __EnsureData();
        
        //if (_soundData != undefined)
        //{
        //    ImGui.BeginDisabled(not _modified);
        //        _soundData.__BuildPropertyUI(_selectionHandler);
        //    ImGui.EndDisabled();
        //}
        
        ImGui.NewLine();
        
        //All the GameMaker properties
        if (ImGui.BeginTable("GameMaker Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 160))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("GameMaker Project", ImGuiTableColumnFlags.WidthStretch, 0.55);
            ImGui.TableHeadersRow();
            
            //Audio group drop-down
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            __VED_NEXT_UI_FILLS_WIDTH
            if (ImGui.BeginCombo("##Audio Group", __audioGroup, ImGuiComboFlags.None))
            {
                var _audioGroupArray = _system.__project.__libAudioGroup.__GetNameArray();
                var _i = 0;
                repeat(array_length(_audioGroupArray))
                {
                    var _audioGroup = _audioGroupArray[_i];
                    if (ImGui.Selectable(_audioGroup, __audioGroup == _audioGroup))
                    {
                        _multiselector.__ForEachSelected(method({
                            __audioGroup: _audioGroup,
                        }, function(_name, _struct)
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
                var _assetTagArray = _system.__project.__libAssetTag.__GetNameArray();
                var _i = 0;
                repeat(array_length(_assetTagArray))
                {
                    var _assetTag = _assetTagArray[_i];
                    
                    var _oldValue = array_contains(_soundAssetTags, _assetTag);
                    var _newValue = ImGui.Checkbox(_assetTag + "##Asset Tag Checkbox", _oldValue);
                    
                    if (_oldValue != _newValue)
                    {
                        _multiselector.__ForEachSelected(method({
                            __assetTag: _assetTag,
                            __newValue: _newValue,
                        }, function(_name, _struct)
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
                    _multiselector.__ForEachSelected(method({
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