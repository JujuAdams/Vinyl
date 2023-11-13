// Feather disable all

function __VinylEditorWindowConfigSounds(_stateStruct)
{
    var _projectSoundArray      = __VinylDocument().__ProjectGetSoundArray();
    var _projectSoundDictionary = __VinylDocument().__ProjectGetSoundDictionary();
    
    var _tabState = _stateStruct.__tabSounds;
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_projectSoundDictionary, __VinylClassPatternSound, undefined);
    
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
        if (ImGui.Button("Edit..."))
        {
            __VinylEditorWindowSetOpen("__filter", true);
        }
        
        _tabState.__seeModified = ImGui.Checkbox("See modified", _seeModified);
        ImGui.SameLine(undefined, 20);
        _tabState.__seeUnmodified = ImGui.Checkbox("See unmodified", _seeUnmodified);
        
        //Now do the actual table
        if (ImGui.BeginTable("Table", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.ScrollY, ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Edited", ImGuiTableColumnFlags.WidthFixed, 20);
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
            
            var _visibleArray = [];
            var _i = 0;
            repeat(array_length(_projectSoundArray))
            {
                var _soundName = _projectSoundArray[_i];
                
                var _modData = _modifiedSoundDict[$ _soundName];
                var _modified = is_struct(_modData);
                var _selected = _selectionHandler.__IsSelected(_soundName);
                
                if (((_modified && _seeModified) || ((not _modified) && _seeUnmodified)) && ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)))
                {
                    if ((not _useFilter) || __VinylFilterApply(_filter, _projectSoundDictionary[$ _soundName]))
                    {
                        _funcBuildSelectable(_soundName, _modifiedSoundDict, _selectionHandler);
                        array_push(_visibleArray, _soundName);
                    }
                }
                
                ++_i;
            }
            
            ImGui.EndTable();
        }
        
        _selectionHandler.__BuildUI(_visibleArray);
        
    ImGui.EndChild();
    
    ImGui.SameLine();
    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        var _selectedCount = _selectionHandler.__GetSelectedCount();
        var _lastSelected  = _selectionHandler.__lastSelected;
        var _modified      = variable_struct_exists(_modifiedSoundDict, _lastSelected);
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 20);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectedCount == 0)
        {
            ImGui.BeginDisabled(true);
            ImGui.Button("Modify");
            ImGui.EndDisabled();
        }
        else if (_selectedCount == 1)
        {
            if (_modified)
            {
                if (ImGui.Button("Revert"))
                {
                    variable_struct_remove(_modifiedSoundDict, _lastSelected);
                }
            }
            else
            {
                if (ImGui.Button("Modify"))
                {
                    _modifiedSoundDict[$ _lastSelected] = new __VinylClassPatternSound();
                }
            }
        }
        else
        {
            if (_modified)
            {
                if (ImGui.Button("Revert All"))
                {
                    _selectionHandler.__ForEachSelected(method({
                        __modifiedSoundDict: _modifiedSoundDict,
                        __lastSelected: _lastSelected,
                    }, function(_name)
                    {
                        variable_struct_remove(__modifiedSoundDict, __lastSelected);
                    }));
                }
            }
            else
            {
                if (ImGui.Button("Modify All"))
                {
                    _selectionHandler.__ForEachSelected(method({
                        __modifiedSoundDict: _modifiedSoundDict,
                    }, function(_name)
                    {
                        if (not variable_struct_exists(__modifiedSoundDict, _name))
                        {
                            __modifiedSoundDict[$ _name] = new __VinylClassPatternSound();
                        }
                    }));
                }
            }
        }
        
        ImGui.SameLine(undefined, 40);
        
        if (_selectedCount == 0)
        {
            ImGui.Text("Please select a sound from the menu on the left");
        }
        else
        {
            var _displayText = _selectionHandler.__GetLastSelectedName();
            if (not _modified) _displayText += " (displaying \"Default\" properties)";
            ImGui.Text(_displayText);
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectionHandler.__GetSelectedCount() > 0)
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                __VinylEditorPropertiesSound(_lastSelected, _modifiedSoundDict[$ _lastSelected], _modified, _modifiedSoundDict.Default, _selectionHandler, _modifiedSoundDict);
            ImGui.EndChild();
        }
    ImGui.EndChild();
}