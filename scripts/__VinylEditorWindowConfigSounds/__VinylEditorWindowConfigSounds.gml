// Feather disable all

function __VinylEditorWindowConfigSounds(_stateStruct)
{
    var _projectSoundArray      = __VinylDocument().__ProjectGetSoundArray();
    var _projectSoundDictionary = __VinylDocument().__ProjectGetSoundDictionary();
    
    var _tabState = _stateStruct.__tabSounds;
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_projectSoundDictionary, __VinylClassSoundNew, undefined);
    
    var _filter        = _tabState.__filter;
    var _useFilter     = _tabState.__useFilter;
    var _seeModified   = _tabState.__seeModified;
    var _seeUnmodified = _tabState.__seeUnmodified;
    var _multiselect   = _selectionHandler.__GetMultiselect();
    var _seeSelected   = _selectionHandler.__GetSeeSelected();
    var _seeUnselected = _selectionHandler.__GetSeeUnselected();
    
    var _modifiedSoundDict = __VinylDocument().__data.sounds;
    
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
            
            var _funcBuildSelectable = function(_soundName, _modifiedSoundDict, _selectionHandler)
            {
                var _modData = _modifiedSoundDict[$ _soundName];
                var _modified = is_struct(_modData);
                var _selected = _selectionHandler.__IsSelected(_soundName);
                
                ImGui.TableNextRow();
                ImGui.TableSetColumnIndex(0);
                ImGui.BeginDisabled(true);
                    ImGui.PushStyleColor(ImGuiCol.CheckMark, c_white, 1);
                        ImGui.PushStyleColor(ImGuiCol.FrameBg, c_white, 0);
                            ImGui.PushStyleVar(ImGuiStyleVar.Alpha, 1);
                                ImGui.Checkbox("##Modified " + _soundName, _modified);
                            ImGui.PopStyleVar();
                        ImGui.PopStyleColor();
                    ImGui.PopStyleColor();
                ImGui.EndDisabled();
                
                ImGui.TableSetColumnIndex(1);
                if (ImGui.Selectable(_soundName + "##Select " + _soundName, _selected))
                {
                    _selectionHandler.__SelectToggle(_soundName);
                }
            }
            
            _funcBuildSelectable("Default", _modifiedSoundDict, _selectionHandler);
            ImGui.Separator();
            
            var _i = 0;
            repeat(array_length(_projectSoundArray))
            {
                var _soundName = _projectSoundArray[_i];
                
                var _modData = _modifiedSoundDict[$ _soundName];
                var _modified = is_struct(_modData);
                var _selected = _selectionHandler.__IsSelected(_soundName);
                
                if (((_modified && _seeModified) || ((not _modified) && _seeUnmodified)) && ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)))
                {
                    if ((not _useFilter) || __VinylFilterApply(_filter, _projectSoundDictionary[$ _soundName].__soundID))
                    {
                        _funcBuildSelectable(_soundName, _modifiedSoundDict, _selectionHandler);
                    }
                }
                
                ++_i;
            }
            
            ImGui.EndTable();
        }
        
        _selectionHandler.__BuildUI();
        
    ImGui.EndChild();
    
    ImGui.SameLine();
    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        var _selectedCount = _selectionHandler.__GetSelectedCount();
        var _lastSelected  = _selectionHandler.__lastSelected;
        var _modified      = variable_struct_exists(_modifiedSoundDict, _lastSelected);
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 20);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        ImGui.BeginDisabled(_selectedCount != 1);
            if (_lastSelected == undefined)
            {
                if (ImGui.Button("Modify"))
                {
                    
                }
                
                ImGui.SameLine();
            }
            else if (_modified)
            {
                if (ImGui.Button("Revert"))
                {
                    variable_struct_remove(_modifiedSoundDict, _lastSelected);
                }
                
                ImGui.SameLine();
            }
            else
            {
                if (ImGui.Button("Modify"))
                {
                    _modifiedSoundDict[$ _lastSelected] = new __VinylClassSoundNew();
                }
                
                ImGui.SameLine();
            }
        ImGui.EndDisabled();
        
        ImGui.SameLine(undefined, 40);
        
        if (_selectedCount == 0)
        {
            ImGui.Text("Please select a sound from the menu on the left");
        }
        else if (_selectedCount == 1) 
        {
            var _displayText = _selectionHandler.__GetLastSelectedName();
            if (not _modified) _displayText += " (displaying \"Default\" properties)";
            ImGui.Text(_displayText);
        }
        else //(_selectedCount > 1)
        {
            ImGui.Text("Modifying multiple sounds at once is not currently supported");
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectionHandler.__GetSelectedCount() == 1)
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                __VinylEditorPropertiesSound(_lastSelected, _modifiedSoundDict[$ _lastSelected], _modified, _modifiedSoundDict.Default);
            ImGui.EndChild();
        }
    ImGui.EndChild();
}