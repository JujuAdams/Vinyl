// Feather disable all

function __VinylEditorWindowFilter(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(0.4*room_width, 0.27*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.25*room_width, 0.25*room_height, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Filter", __VinylEditorWindowGetOpen("__filter"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__filter", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
        var _filter = _stateStruct.__target;
        if (not is_struct(_filter))
        {
            ImGui.Text("Filter not available for this configuration tab.");
        }
        else
        {
            if (ImGui.BeginTable("Table", 3))
            {
                ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 120);
                ImGui.TableSetupColumn("Active", ImGuiTableColumnFlags.WidthFixed, 30);
                ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Invert");
                ImGui.TableSetColumnIndex(1);
                _filter.__invert = ImGui.Checkbox("##Filter Invert Checkbox", _filter.__invert);
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Match Name");
                ImGui.TableSetColumnIndex(1);
                _filter.__useNameMatch = ImGui.Checkbox("##Filter Name Match Checkbox", _filter.__useNameMatch);
                ImGui.TableSetColumnIndex(2);
                ImGui.BeginDisabled(not _filter.__useNameMatch);
                    _filter.__nameMatch = ImGui.InputTextWithHint("##Filter Name Match", "e.g. sndBleep*", _filter.__nameMatch);
                ImGui.EndDisabled();
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Length Between");
                ImGui.TableSetColumnIndex(1);
                _filter.__useLength = ImGui.Checkbox("##Length Between Checkbox", _filter.__useLength);
                ImGui.TableSetColumnIndex(2);
                ImGui.BeginDisabled(not _filter.__useLength);
                    ImGui.InputFloat2("seconds##", _filter.__length);
                    if (_filter.__length[1] < _filter.__length[0])
                    {
                        var _temp = _filter.__length[1];
                        _filter.__length[1] = _filter.__length[0];
                        _filter.__length[0] = _temp;
                    }
                ImGui.EndDisabled();
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Audio Group");
                ImGui.TableSetColumnIndex(1);
                _filter.__useAudioGroup = ImGui.Checkbox("##Audio Group Checkbox", _filter.__useAudioGroup);
                ImGui.TableSetColumnIndex(2);
                ImGui.BeginDisabled(not _filter.__useAudioGroup);
                    
                    var _audioGroupDict = _filter.__audioGroupDict;
                    
                    var _nameArray = variable_struct_get_names(_audioGroupDict);
                    array_sort(_nameArray, true);
                    var _string = __VinylLabelsGetAbbreviatedName(_nameArray, infinity);
                    
                    if (ImGui.BeginCombo("##Audio Group Combobox", _string, ImGuiComboFlags.None))
                    {
                        var _audioGroupArray = __VinylDocument().__GetProjectAudioGroupArray();
                        var _i = 0;
                        repeat(array_length(_audioGroupArray))
                        {
                            var _audioGroup = _audioGroupArray[_i];
                            
                            var _contains = variable_struct_exists(_audioGroupDict, _audioGroup);
                            var _newContains = ImGui.Checkbox(_audioGroup, _contains);
                            
                            if (_newContains != _contains)
                            {
                                if (_newContains)
                                {
                                    _audioGroupDict[$ _audioGroup] = true;
                                }
                                else
                                {
                                    variable_struct_remove(_audioGroupDict, _audioGroup);
                                }
                            }
                            
                            ++_i;
                        }
                    
                        ImGui.EndCombo();
                    }
                ImGui.EndDisabled();
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.Text("Attribute");
                ImGui.TableSetColumnIndex(1);
                _filter.__useAttribute = ImGui.Checkbox("##Attribute Checkbox", _filter.__useAttribute);
                ImGui.TableSetColumnIndex(2);
                ImGui.BeginDisabled(not _filter.__useAttribute);
                    var _attributesArray = _filter.__attributesArray;
                    _attributesArray[0] = ImGui.Checkbox("WAV##Attribute 0 Checkbox",   _attributesArray[0]);
                    _attributesArray[1] = ImGui.Checkbox("OGG - Decompress during playback##Attribute 1 Checkbox",   _attributesArray[1]);
                    _attributesArray[2] = ImGui.Checkbox("OGG - Decompress when loaded and store in RAM##Attribute 2 Checkbox", _attributesArray[2]);
                    _attributesArray[3] = ImGui.Checkbox("OGG - Stream from disk (exports .ogg files)##Attribute 3 Checkbox", _attributesArray[3]);
                ImGui.EndDisabled();
                
                ImGui.EndTable();
            }
        }
    }
    
    ImGui.End();
}