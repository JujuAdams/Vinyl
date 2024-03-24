// Feather disable all

function __VedClassWindowRules() : __VedClassWindow() constructor
{
    __handle = "Rules";
    
    __multiselector = new __VedClassMultiselector();
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        var _ruleArray = _project.__libRule.__GetNameArray();
        var _ruleDict  = _project.__libRule.__GetDictionary();
        
        ImGui.SetNextWindowSize(0.7*room_width, 0.8*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.15*room_width, 0.1*room_height, ImGuiCond.Once);
	    
        var _return = ImGui.Begin(__handle, not __closed, ImGuiWindowFlags.None, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            if (ImGui.BeginTabBar("Rules Tab Bar"))
            {
                ImGui.BeginChild("Left Pane", 0.33*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                    
                    if (ImGui.Button("New")) __VedModalOpen(__VedClassModalNewRule);
                    ImGui.SameLine(undefined, 20);
                    
                    var _selectedCount = __multiselector.__GetSelectedCount();
                    ImGui.BeginDisabled(_selectedCount <= 0);
                    if (ImGui.Button("Delete"))
                    {
                        if (_selectedCount > 0)
                        {
                            var _modal = __VedModalOpen(__VedClassModalDeleteAsset);
                            if (_selectedCount == 1)
                            {
                                //Change the display text depending on what the user is actually seeing
                                _modal.__assetName = __multiselector.__GetLastSelectedName();
                            }
                            else
                            {
                                //Change the display text depending on what the user is actually seeing
                                _modal.__assetName = string_concat(__multiselector.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others");
                            }
                            
                            _modal.__function = function()
                            {
                                var _project  = _system.__project;
                                var _ruleDict = _project.__libRule.__GetDictionary();
                                
                                __multiselector.__ForEachSelected(_ruleDict,
                                method({
                                    __library: _project.__libRule,
                                },
                                function(_name, _struct)
                                {
                                    __library.__RemoveByName(_name);
                                }));
                                
                                __multiselector.__SelectNone();
                            }
                        }
                    }
                    ImGui.EndDisabled();
                    
                    //TODO
                    //__showDict[$ "__VedClassPatternShuffle"] = ImGui.Checkbox("Shuffle", __showDict[$ "__VedClassPatternShuffle"]);
                    //ImGui.SameLine();
                    //__showDict[$ "__VedClassPatternHLT"] = ImGui.Checkbox("H-L-T", __showDict[$ "__VedClassPatternHLT"]);
                    //ImGui.SameLine();
                    //__showDict[$ "__VedClassPatternBlend"] = ImGui.Checkbox("Blend", __showDict[$ "__VedClassPatternBlend"]);
                    
                    //Keep an array of all visible sounds. We use this later for the "select all" button
                    var _visibleArray = [];
                    
                    //Now do the actual table
                    if (ImGui.BeginTable("Table", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.ScrollY, ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50))
                    {
                        //Set up our columns with fixed widths so we get a nice pretty layout
                        ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 21);
                        ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
                        
                        //DRY - Used for both the fallback sound config and standard sound configs
                        var _funcBuildSelectable = function(_name, _rule, _multiselector)
                        {
                            var _selected = _multiselector.__IsSelected(_name);
                            
                            //Left-hand side custom checkbox
                            ImGui.TableNextRow();
                            ImGui.TableSetColumnIndex(0);
                            ImGui.BeginDisabled(true);
                            //ImGui.Text((_rule == undefined)? "???" : _rule.__GetAbbreviation());
                            ImGui.EndDisabled();
                            
                            //Right-hand side name
                            ImGui.TableSetColumnIndex(1);
                            if (ImGui.Selectable(_name + "##Select " + _name, _selected)) _multiselector.__SelectToggle(_name);
                        }
                        
                        //Iterate over every sound in the project and show them in the editor
                        var _i = 0;
                        repeat(array_length(_ruleArray))
                        {
                            var _name = _ruleArray[_i];
                            
                            var _selected = __multiselector.__IsSelected(_name);
                            
                            if ((not __multiselector.__multiselect) || (_selected && __multiselector.__seeSelected) || ((not _selected) && __multiselector.__seeUnselected)) //Selected check
                            {
                                _funcBuildSelectable(_name, _ruleDict[$ _name], __multiselector);
                                
                                //Push the name of this visible sound to our array
                                array_push(_visibleArray, _name);
                            }
                            
                            ++_i;
                        }
                        
                        ImGui.EndTable();
                    }
                    
                    //Build the selection handler UI at the bottom of the list of sounds
                    __multiselector.__BuildUI(_ruleDict, _visibleArray);
                ImGui.EndChild();
                
                ImGui.SameLine();
                
                ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                    //Collect some basic facts about the current selection(s)
                    var _selectedCount    = __multiselector.__GetSelectedCount();
                    var _lastSelectedName = __multiselector.__lastSelected;
                    var _lastSelected     = _ruleDict[$ _lastSelectedName];
                    
                    //Bit of aesthetic spacing
                    ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
                    
                    if (_selectedCount <= 0)
                    {
                        //Add some helpful text to guide users if nothing's selected
                        ImGui.Text("Please select a rule from the menu on the left.");
                    }
                    else
                    {
                        if (_selectedCount == 1)
                        {
                            //Change the display text depending on what the user is actually seeing
                            ImGui.Text(__multiselector.__GetLastSelectedName());
                            ImGui.NewLine();
                            _lastSelected.__BuildUI(__multiselector, _ruleDict);
                        }
                        else
                        {
                            //Change the display text depending on what the user is actually seeing
                            ImGui.Text(string_concat(__multiselector.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others"));
                            ImGui.NewLine();
                            ImGui.Text("Cannot edit multiple rules at the same time.");
                        }
                    }
                ImGui.EndChild();
                
                ImGui.EndChild();
                
                ImGui.EndTabBar();
            }
        }
        
        ImGui.End();
    }
}