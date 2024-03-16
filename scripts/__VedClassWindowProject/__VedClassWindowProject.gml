// Feather disable all

function __VedClassWindowProject() : __VedClassWindow() constructor
{
    __handle = "Project";
    
    __filter = new __VinylClassFilter();
    
    __useFilter     = false;
    __seeModified   = true;
    __seeUnmodified = true;
    
    __multiselector = new __VedClassMultiselector();
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        var _yypAssetArray  = _project.__libYYPAssets.__GetNameArray();
        var _yypAssetDict   = _project.__libYYPAssets.__GetDictionary();
        var _vinylAssetDict = _project.__libVinylAssets.__GetDictionary();
        
        ImGui.SetNextWindowSize(0.7*room_width, 0.8*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.15*room_width, 0.1*room_height, ImGuiCond.Once);
	    
        //Allow the filter window to stay on top
        //var _flags = __VinylEditorWindowGetOpen("__filter")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
        var _flags = ImGuiWindowFlags.None;
        
        var _return = ImGui.Begin(__handle, not __closed, _flags, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            ImGui.BeginChild("Left Pane", 0.3*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                //General filter checkbox and edit button
                ImGui.Text("Filter");
                ImGui.SameLine();
                __useFilter = ImGui.Checkbox("##Filter", __useFilter);
                ImGui.SameLine();
                if (ImGui.Button("Edit..."))
                {
                    //__VinylEditorWindowSetOpen("__filter", true);
                }
                
                //Modified / unmodified filter
                __seeModified = ImGui.Checkbox("See modified", __seeModified);
                ImGui.SameLine(undefined, 20);
                __seeUnmodified = ImGui.Checkbox("See unmodified", __seeUnmodified);
                
                //Keep an array of all visible sounds. We use this later for the "select all" button
                var _visibleArray = [];
                
                //Now do the actual table
                if (ImGui.BeginTable("Table", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.ScrollY, ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50))
                {
                    //Set up our columns with fixed widths so we get a nice pretty layout
                    ImGui.TableSetupColumn("Edited", ImGuiTableColumnFlags.WidthFixed, 20);
                    ImGui.TableSetupColumn("Sounds", ImGuiTableColumnFlags.WidthStretch, 1);
                    
                    //DRY - Used for both the fallback sound config and standard sound configs
                    var _funcBuildSelectable = function(_name, _modified, _multiselector)
                    {
                        var _selected = _multiselector.__IsSelected(_name);
                        
                        //Left-hand side custom checkbox
                        ImGui.TableNextRow();
                        ImGui.TableSetColumnIndex(0);
                        ImGui.BeginDisabled(true);
                            ImGui.PushStyleColor(ImGuiCol.CheckMark, c_white, 1);
                                ImGui.PushStyleColor(ImGuiCol.FrameBg, c_white, 0);
                                    ImGui.PushStyleVar(ImGuiStyleVar.Alpha, 1);
                                        ImGui.Checkbox("##Modified " + _name, _modified);
                                    ImGui.PopStyleVar();
                                ImGui.PopStyleColor();
                            ImGui.PopStyleColor();
                        ImGui.EndDisabled();
                        
                        //Right-hand side name
                        ImGui.TableSetColumnIndex(1);
                        if (ImGui.Selectable(_name + "##Select " + _name, _selected))
                        {
                            _multiselector.__SelectToggle(_name);
                        }
                    }
                    
                    //Iterate over every sound in the project and show them in the editor
                    var _i = 0;
                    repeat(array_length(_yypAssetArray))
                    {
                        var _name = _yypAssetArray[_i];
                        
                        var _modified = _vinylAssetDict[$ _name].__modified;
                        var _selected = __multiselector.__IsSelected(_name);
                        
                        if (((_modified && __seeModified) || ((not _modified) && __seeUnmodified)) //Modified check
                        &&  ((not __multiselector.__multiselect) || (_selected && __multiselector.__seeSelected) || ((not _selected) && __multiselector.__seeUnselected))) //Selected check
                        {
                            if ((not __useFilter) || __VedFilterApply(__filter, _yypAssetDict[$ _name])) //General filter
                            {
                                _funcBuildSelectable(_name, _modified, __multiselector);
                                
                                //Push the name of this visible sound to our array
                                array_push(_visibleArray, _name);
                            }
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndTable();
                }
                
                //Build the selection handler UI at the bottom of the list of sounds
                __multiselector.__BuildUI(_visibleArray);
                
            ImGui.EndChild();
            
            
            
            //Ok! Now we do the right-hand properties pane
            
            
            
            ImGui.SameLine();
            ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                //Collect some basic facts about the current selection(s)
                var _selectedCount     = __multiselector.__GetSelectedCount();
                var _lastSelectedName  = __multiselector.__lastSelected;
                var _lastSelectedVinyl = _vinylAssetDict[$ _lastSelectedName];
                var _lastSelectedYYP   = _yypAssetDict[$ _lastSelectedName];
                var _modified          = is_struct(_lastSelectedVinyl)? _lastSelectedVinyl.__modified : false;
                
                //Bit of aesthetic spacing
                ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
                
                if (_selectedCount == 0)
                {
                    //Nothing's here! Disable the "modify" checkbox
                    ImGui.BeginDisabled(true);
                    ImGui.Button("Modify");
                    ImGui.EndDisabled();
                }
                else if (_selectedCount == 1)
                {
                    //One thing is selected!
                    
                    //Change the name and behaviour of the checbox based on its input state
                    if (_modified)
                    {
                        if (ImGui.Button("Revert")) _lastSelectedVinyl.__Unmodify();
                    }
                    else
                    {
                        if (ImGui.Button("Modify")) _lastSelectedVinyl.__Modify();
                    }
                }
                else
                {
                    //Many things are selected!
                    
                    //Change the name and behaviour of the checbox based on its input state, and apply that to all selected sounds
                    if (_modified)
                    {
                        if (ImGui.Button("Revert All"))
                        {
                            __multiselector.__ForEachSelected(method({
                                __vinylAssetDict: _vinylAssetDict,
                            },
                            function(_name)
                            {
                                var _asset = __vinylAssetDict[$ _name];
                                if (_asset != undefined) _asset.__Unmodify();
                            }));
                            
                            __multiselector.__SelectNone();
                            __multiselector.__Select(_lastSelectedName, false);
                        }
                    }
                    else
                    {
                        if (ImGui.Button("Modify All"))
                        {
                            __multiselector.__ForEachSelected(method({
                                __vinylAssetDict: _vinylAssetDict,
                            },
                            function(_name)
                            {
                                var _asset = __vinylAssetDict[$ _name];
                                if (_asset != undefined) _asset.__Modify();
                            }));
                        }
                    }
                }
                
                ImGui.SameLine(undefined, 40);
                
                if (_selectedCount == 0)
                {
                    //Add some helpful text to guide users if nothing's selected
                    ImGui.Text("Please select a sound from the menu on the left");
                }
                else
                {
                    //Change the display text depending on what the user is actually seeing
                    ImGui.Text(__multiselector.__GetLastSelectedName());
                }
                
                //Little more aesthetic spacing
                ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
                
                //Here's where we jump to a different function to draw the actual properties
                if (__multiselector.__GetSelectedCount() > 0)
                {
                    ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                    _lastSelectedVinyl.__BuildUI(__multiselector);
                    ImGui.NewLine();
                    _lastSelectedYYP.__BuildUI(__multiselector);
                    ImGui.EndChild();
                }
                
            ImGui.EndChild();
        }
        
        ImGui.End();
    }
}