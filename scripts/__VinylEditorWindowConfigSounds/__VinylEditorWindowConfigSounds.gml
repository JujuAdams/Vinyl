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
        ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 10);
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
            var _displayName = _selectionHandler.__GetLastSelectedName();
            if (not _modified) _displayName += " (displaying \"Default\" properties)";
            ImGui.Text(_displayName);
        }
        else //(_selectedCount > 1)
        {
            ImGui.Text("Modifying multiple sounds at once is not currently supported");
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectionHandler.__GetSelectedCount() == 1)
        {
            ImGui.BeginDisabled(not _modified);
                ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
        
                    var _width = ImGui.GetContentRegionAvailX();
                    ImGui.BeginChild("Vinyl Properties", _width, 520, true);
                
                        ImGui.Checkbox("Randomize Gain", false);
                        ImGui.Text("Gain");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.3*_width);
                        ImGui.SliderFloat("##Gain", 0.6, 0, 2, "%.2f");
                        ImGui.SameLine();
                        ImGui.Text("Knob");
                        ImGui.SameLine();
                        ImGui.Checkbox("##Min Gain Knob Checkbox", false);
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.15*_width);
                        ImGui.InputTextWithHint("##Min Gain Knob", "e.g. @spookiness", "");
                    
                        ImGui.NewLine();
                        ImGui.NewLine();
                    
                        ImGui.Checkbox("Randomize Pitch", true);
                        ImGui.Text("Min Pitch");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.3*_width);
                        ImGui.SliderFloat("##Min Pitch", 0.9, 0, 2, "%.2f");
                        ImGui.SameLine();
                        ImGui.Text("Knob");
                        ImGui.SameLine();
                        ImGui.Checkbox("##Min Pitch Knob Checkbox", false);
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.15*_width);
                        ImGui.BeginDisabled(true);
                            ImGui.InputTextWithHint("##Min Pitch Knob", "e.g. @spookiness", "");
                        ImGui.EndDisabled();
        
                        ImGui.Text("Max Pitch");
                        ImGui.BeginDisabled(false);
                            ImGui.SameLine();
                            ImGui.SetNextItemWidth(0.3*_width);
                            ImGui.SliderFloat("##Max Pitch", 1.1, 0, 2, "%.2f");
                            ImGui.SameLine();
                            ImGui.Text("Knob");
                            ImGui.SameLine();
                            ImGui.Checkbox("##Max Pitch Knob Checkbox", false);
                            ImGui.SameLine();
                            ImGui.SetNextItemWidth(0.15*_width);
                            ImGui.BeginDisabled(true);
                                ImGui.InputTextWithHint("##Max Pitch Knob", "e.g. @spookiness", "");
                            ImGui.EndDisabled();
                        ImGui.EndDisabled();
                    
                        ImGui.NewLine();
                        ImGui.NewLine();
                    
                        ImGui.Text("Label(s)");
                        ImGui.SameLine();
                        if (ImGui.BeginCombo("##Label", "", ImGuiComboFlags.None))
                        {
                            ImGui.Button("Add New");
                            repeat(10)
                            {
                                ImGui.Checkbox("A", false);
                                ImGui.Checkbox("B", false);
                                ImGui.Checkbox("C", false);
                                ImGui.Checkbox("D", false);
                                ImGui.Checkbox("E", false);
                            }
                        
                            ImGui.EndCombo();
                        }
                        ImGui.SameLine();
                        ImGui.Button("Clear");
                    
                        ImGui.NewLine();
                        ImGui.NewLine();
                    
                        ImGui.Text("Loop");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.25*_width);
                        if (ImGui.BeginCombo("##Loop", "Off", ImGuiComboFlags.None))
                        {
                            ImGui.Selectable("Off", true);
                            ImGui.Selectable("On", false);
                            ImGui.Selectable("Inherit From Label(s)", false);
                            ImGui.EndCombo();
                        }
                    
                        ImGui.Text("Loop Points");
                        ImGui.SameLine();
                        ImGui.Checkbox("##Loop Points", false);
                        ImGui.BeginDisabled(true);
                            ImGui.SameLine();
                            ImGui.Text("Start");
                            ImGui.SameLine();
                            ImGui.SetNextItemWidth(0.1*_width);
                            ImGui.InputFloat("##Loop Point Start", 0, 0,0, "%.4f");
                            ImGui.SameLine();
                            ImGui.Text("End");
                            ImGui.SameLine();
                            ImGui.SetNextItemWidth(0.1*_width);
                            ImGui.InputFloat("##Loop Point End", 0, 0,0, "%.4f");
                        ImGui.EndDisabled();
                    
                        ImGui.NewLine();
                        ImGui.NewLine();
                    
                        ImGui.Text("Persistent");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.25*_width);
                        if (ImGui.BeginCombo("##Persistent", "Off", ImGuiComboFlags.None))
                        {
                            ImGui.Selectable("Off", true);
                            ImGui.Selectable("On", false);
                            ImGui.Selectable("Inherit From Label(s)", false);
                            ImGui.EndCombo();
                        }
                    
                        ImGui.NewLine();
                        ImGui.NewLine();
                    
                        ImGui.Text("Stack");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.33*_width);
                        if (ImGui.BeginCombo("##Stack", "", ImGuiComboFlags.None))
                        {
                            ImGui.Selectable("Inherit From Label(s)", false);
                            ImGui.Separator();
                            ImGui.Selectable("Music", false);
                            ImGui.EndCombo();
                        }
                        ImGui.SameLine();
                        ImGui.Button("Clear");
                    
                        ImGui.Text("Stack Priority");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.1*_width);
                        ImGui.InputInt("##Stack Priority", 0);
                    
                        ImGui.NewLine();
                        ImGui.NewLine();
                    
                        ImGui.Text("Transpose");
                        ImGui.SameLine();
                        ImGui.SetNextItemWidth(0.25*_width);
                        if (ImGui.BeginCombo("##Transpose Checkbox", "Off", ImGuiComboFlags.None))
                        {
                            ImGui.Selectable("Off", true);
                            ImGui.Selectable("On - Use value", false);
                            ImGui.Selectable("On - Use knob", false);
                            ImGui.Selectable("Inherit From Label(s)", false);
                            ImGui.EndCombo();
                        }
                        ImGui.SameLine();
                        ImGui.BeginDisabled(true);
                            ImGui.SameLine();
                            ImGui.SetNextItemWidth(0.3*_width);
                            ImGui.SliderInt("##Transpose", 0, -24, 24);
                        ImGui.EndDisabled();
                    
                        ImGui.Text("BPM");
                        ImGui.SameLine();
                        ImGui.Checkbox("##BPM Checkbox", false);
                        ImGui.SameLine();
                        ImGui.BeginDisabled(true);
                            ImGui.SetNextItemWidth(0.1*_width);
                            ImGui.InputInt("##BPM", 120);
                        ImGui.EndDisabled();
                    
                    ImGui.EndChild();
            
                    ImGui.NewLine();
        
                    var _width = ImGui.GetContentRegionAvailX();
                    ImGui.BeginChild("GameMaker Native Properties", _width, 150, true);
                        
                        ImGui.TextUnformatted("Audiogroup");
                        ImGui.SameLine();
                        if (ImGui.BeginCombo("##Audiogroup", "Default", ImGuiComboFlags.None))
                        {
                            ImGui.Selectable("Default", true);
                            ImGui.Selectable("agBaddies", false);
                            ImGui.Selectable("agFX", false);
                            ImGui.EndCombo();
                        }
                    
                        ImGui.RadioButton("WAV", true);
                        ImGui.RadioButton("OGG - Decompress during playback", false);
                        ImGui.RadioButton("OGG - Decompress when loaded and store in RAM", false);
                        ImGui.RadioButton("OGG - Stream from disk (exports .ogg files in game directory)", false);
                    
                    ImGui.EndChild();
                ImGui.EndChild();
            ImGui.EndDisabled();
        }
    ImGui.EndChild();
}