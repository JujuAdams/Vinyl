// Feather disable all

function __VedClassRuleFilter() constructor
{
    static _system = __VedSystem();
    
    __not = false;
    
    __nameMatch    = "";
    __useNameMatch = false;
    
    __length    = [0, 999];
    __useLength = false;
    
    __audioGroupDict = {};
    __useAudioGroup  = false;
    
    __assetTagOr   = true;
    __assetTagDict = {};
    __useAssetTag  = false;
    
    __attributesArray = [false, false, false, false];
    __useAttribute    = false;
    
    static __Serialize = function(_array)
    {
        //TODO
        
        array_push(_array, {
            
        });
    }
    
    static __Deserialize = function(_data)
    {
        //TODO
    }
    
    static __Apply = function(_struct)
    {
        if (__useNameMatch)
        {
            var _soundName = _struct.__name;
            var _subArray = string_split(__nameMatch, "*", true);
            
            var _pos = 1;
            var _j = 0;
            repeat(array_length(_subArray))
            {
                var _substring = _subArray[_j];
            
                _pos = string_pos_ext(_substring, _soundName, _pos);
                if (_pos <= 0) return __not;
            
                ++_j;
            }
        }
        
        if (__useLength)
        {
            if ((_struct.__length < __length[0]) || (_struct.__length > __length[1])) return __not;
        }
        
        if (__useAudioGroup)
        {
            if (not variable_struct_exists(__audioGroupDict, _struct.__audioGroup)) return __not;
        }
        
        if (__useAssetTag)
        {
            var _assetTagArray = _struct.__assetTags;
            
            var _found = false;
            var _i = 0;
            repeat(array_length(_assetTagArray))
            {
                if (variable_struct_exists(__assetTagDict, _assetTagArray[_i]))
                {
                    _found = true;
                    break;
                }
                
                ++_i;
            }
            
            if (not _found) return __not;
        }
        
        if (__useAttribute)
        {
            if (not __attributesArray[_struct.__attributes]) return __not;
        }
        
        return (not __not);
    }
    
    static __GetName = function()
    {
        return "Filter";
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginTable("Table", 3))
        {
            var _audioGroupArray = _system.__project.__libAudioGroup.__GetDictionary();
            var _assetTagArray   = _system.__project.__libAssetTag.__GetNameArray();
                    
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 120);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 30);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Invert");
            ImGui.TableSetColumnIndex(1);
            __not = ImGui.Checkbox("##Filter Invert Checkbox", __not);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Match Name");
            ImGui.TableSetColumnIndex(1);
            __useNameMatch = ImGui.Checkbox("##Filter Name Match Checkbox", __useNameMatch);
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(not __useNameMatch);
            __nameMatch = ImGui.InputTextWithHint("##Filter Name Match", "e.g. sndBleep*", __nameMatch);
            ImGui.EndDisabled();
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Length Between");
            ImGui.TableSetColumnIndex(1);
            __useLength = ImGui.Checkbox("##Length Between Checkbox", __useLength);
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(not __useLength);
            ImGui.InputFloat2("seconds##", __length);
            if (__length[1] < __length[0])
            {
                var _temp = __length[1];
                __length[1] = __length[0];
                __length[0] = _temp;
            }
            ImGui.EndDisabled();
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Audio Group");
            ImGui.TableSetColumnIndex(1);
            __useAudioGroup = ImGui.Checkbox("##Audio Group Checkbox", __useAudioGroup);
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(not __useAudioGroup);
                
                var _nameArray = variable_struct_get_names(__audioGroupDict);
                array_sort(_nameArray, true);
                var _string = __VedLabelsGetAbbreviatedName(_nameArray, infinity);
                
                if (ImGui.BeginCombo("##Audio Group Combobox", _string, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_audioGroupArray))
                    {
                        var _audioGroup = _audioGroupArray[_i];
                        
                        var _contains = variable_struct_exists(__audioGroupDict, _audioGroup);
                        var _newContains = ImGui.Checkbox(_audioGroup, _contains);
                        
                        if (_newContains != _contains)
                        {
                            if (_newContains)
                            {
                                __audioGroupDict[$ _audioGroup] = true;
                            }
                            else
                            {
                                variable_struct_remove(__audioGroupDict, _audioGroup);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
            ImGui.EndDisabled();
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Asset Tag");
            ImGui.TableSetColumnIndex(1);
            __useAssetTag = ImGui.Checkbox("##Asset Tag Checkbox", __useAssetTag);
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(not __useAssetTag);
                
                var _nameArray = variable_struct_get_names(__assetTagDict);
                array_sort(_nameArray, true);
                var _string = __VedAssetTagsGetAbbreviatedName(_nameArray, infinity);
                
                if (ImGui.BeginCombo("##Asset Tag Combobox", _string, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_assetTagArray))
                    {
                        var _assetTag = _assetTagArray[_i];
                        
                        var _contains = variable_struct_exists(__assetTagDict, _assetTag);
                        var _newContains = ImGui.Checkbox(_assetTag, _contains);
                        
                        if (_newContains != _contains)
                        {
                            if (_newContains)
                            {
                                __assetTagDict[$ _assetTag] = true;
                            }
                            else
                            {
                                variable_struct_remove(__assetTagDict, _assetTag);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(2);
                if (ImGui.RadioButton("OR", __assetTagOr)) __assetTagOr = true;
                ImGui.SameLine();
                if (ImGui.RadioButton("AND", not __assetTagOr)) __assetTagOr = false;
                
            ImGui.EndDisabled();
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Attribute");
            ImGui.TableSetColumnIndex(1);
            __useAttribute = ImGui.Checkbox("##Attribute Checkbox", __useAttribute);
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(not __useAttribute);
                __attributesArray[0] = ImGui.Checkbox("WAV##Attribute 0 Checkbox", __attributesArray[0]);
                __attributesArray[1] = ImGui.Checkbox("OGG - Decompress during playback##Attribute 1 Checkbox", __attributesArray[1]);
                __attributesArray[2] = ImGui.Checkbox("OGG - Decompress when loaded and store in RAM##Attribute 2 Checkbox", __attributesArray[2]);
                __attributesArray[3] = ImGui.Checkbox("OGG - Stream from disk (exports .ogg files)##Attribute 3 Checkbox", __attributesArray[3]);
            ImGui.EndDisabled();
            
            ImGui.EndTable();
        }
    }
}