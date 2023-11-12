// Feather disable all

function __VinylEditorWindowConfigSounds(_stateStruct)
{
    var _tabState = _stateStruct.__tabSounds;
    var _selectedDict = _tabState.__selectedDict;
    
    var _filter        = _tabState.__filter;
    var _useFilter     = _tabState.__useFilter;
    var _seeModified   = _tabState.__seeModified;
    var _seeUnmodified = _tabState.__seeUnmodified;
    var _multiselect   = _tabState.__multiselect;
    var _seeSelected   = _tabState.__seeSelected;
    var _seeUnselected = _tabState.__seeUnselected;
    
    var _resourceConstructor = __VinylClassPatternNew;
    var _modifiedSoundDict = __VinylDocument().__data.sounds;
    
    var _gmSoundArray = [];
    
    ImGui.BeginChild("Left Pane", 0.3*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        ImGui.Text("Filter");
        ImGui.SameLine();
        _tabState.__useFilter = ImGui.Checkbox("##Filter", _useFilter);
        ImGui.SameLine();
        ImGui.Button("Edit...");
        _tabState.__seeModified = ImGui.Checkbox("See modified", _seeModified);
        ImGui.SameLine(undefined, 20);
        _tabState.__seeUnmodified = ImGui.Checkbox("See unmodified", _seeUnmodified);
        
        //Now do the actual table
        if (ImGui.BeginTable("Table", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.ScrollY, ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Editted", ImGuiTableColumnFlags.WidthFixed, 20);
            ImGui.TableSetupColumn("Sounds", ImGuiTableColumnFlags.WidthStretch, 1);
            
            var _i = 0;
            repeat(array_length(_gmSoundArray))
            {
                var _sound = _gmSoundArray[_i];
                var _soundName = audio_get_name(_sound);
                
                var _modData = _modifiedSoundDict[$ _soundName];
                var _modified = is_struct(_modData);
                var _selected = variable_struct_exists(_selectedDict, _soundName);
                
                if (((_modified && _seeModified) || ((not _modified) && _seeUnmodified)) && ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)))
                {
                    if ((not _useFilter) || __VinylFilterApply(_filter, _sound))
                    {
                        ImGui.TableNextRow();
                        ImGui.TableSetColumnIndex(0);
                        ImGui.BeginDisabled(true);
                            ImGui.PushStyleColor(ImGuiCol.CheckMark, c_white, 1);
                                ImGui.PushStyleColor(ImGuiCol.FrameBg, c_white, 0);
                                    ImGui.PushStyleVar(ImGuiStyleVar.Alpha, 1);
                                        ImGui.Checkbox("##Modified " + _soundName, is_struct(_modData));
                                    ImGui.PopStyleVar();
                                ImGui.PopStyleColor();
                            ImGui.PopStyleColor();
                        ImGui.EndDisabled();
                        ImGui.TableSetColumnIndex(1);
                        
                        if (ImGui.Selectable(_soundName + "##Select", false))
                        {
                            
                        }
                    }
                }
            }
            
            ImGui.EndTable();
        }
            
        ImGui.Text("Multiselect");
        ImGui.SameLine();
        _tabState.__multiselect = ImGui.Checkbox("##Multiselect", _multiselect);
        ImGui.BeginDisabled(not _multiselect);
            ImGui.SameLine();
            
            if (ImGui.Button("All"))
            {
                
            }
            
            ImGui.SameLine();
            
            if (ImGui.Button("None"))
            {
                
            }
            
            var _newValue = ImGui.Checkbox("See selected", (not _multiselect) || _seeSelected);
            if (_multiselect)
            {
                _tabState.__seeSelected = _newValue;
            }
            
            ImGui.SameLine(undefined, 20);
            
            var _newValue = ImGui.Checkbox("See unselected", (not _multiselect) || _seeUnselected);
            if (_multiselect)
            {
                _tabState.__seeUnselected = _newValue;
            }
        ImGui.EndDisabled();
        
    ImGui.EndChild();
}