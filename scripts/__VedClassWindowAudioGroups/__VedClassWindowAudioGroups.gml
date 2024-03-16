// Feather disable all

function __VedClassWindowAudioGroups() : __VedClassWindow() constructor
{
    __handle = "Audio Groups";
    
    __multiselector = new __VedClassMultiselector();
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        var _audioGroupArray = _project.__libAudioGroup.__GetNameArray();
        var _audioGroupDict  = _project.__libAudioGroup.__GetDictionary();
        
        ImGui.SetNextWindowSize(0.6*room_width, 0.6*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.2*room_width, 0.2*room_height, ImGuiCond.Once);
	    
        //Allow the filter window to stay on top
        //var _flags = __VinylEditorWindowGetOpen("__filter")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
        var _flags = ImGuiWindowFlags.None;
        
        var _return = ImGui.Begin(__handle, not __closed, _flags, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            ImGui.BeginChild("Left Pane", 0.3*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                ImGui.BeginChild("Left Pane Top", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50);
                
                    //Keep an array of all visible sounds. We use this later for the "select all" button
                    var _visibleArray = [];
                
                    //DRY - Used for both the fallback sound config and standard sound configs
                    var _funcBuildSelectable = function(_name, _multiselector)
                    {
                        var _selected = _multiselector.__IsSelected(_name);
                        
                        if (ImGui.Selectable(_name + "##Select " + _name, _selected))
                        {
                            _multiselector.__SelectToggle(_name);
                        }
                    }
                    
                    //Iterate over every sound in the project and show them in the editor
                    var _i = 0;
                    repeat(array_length(_audioGroupArray))
                    {
                        var _name = _audioGroupArray[_i];
                        
                        var _selected = __multiselector.__IsSelected(_name);
                        if ((not __multiselector.__multiselect) || (_selected && __multiselector.__seeSelected) || ((not _selected) && __multiselector.__seeUnselected)) //Selected check
                        {
                            _funcBuildSelectable(_name, __multiselector);
                            
                            //Push the name of this visible sound to our array
                            array_push(_visibleArray, _name);
                        }
                        
                        ++_i;
                    }
                    
                ImGui.EndChild();
                
                //Build the selection handler UI at the bottom of the list of sounds
                __multiselector.__BuildUI(_audioGroupDict, _visibleArray);
                
            ImGui.EndChild();
            
            
            
            //Ok! Now we do the right-hand properties pane
            ImGui.SameLine();
            ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                //Collect some basic facts about the current selection(s)
                var _selectedCount     = __multiselector.__GetSelectedCount();
                var _lastSelectedName  = __multiselector.__lastSelected;
                var _lastSelected      = _audioGroupDict[$ _lastSelectedName];
                
                if (_selectedCount <= 0)
                {
                    //Add some helpful text to guide users if nothing's selected
                    ImGui.Text("Please select an audio group from the menu on the left");
                }
                else if (_selectedCount == 1)
                {
                    //Change the display text depending on what the user is actually seeing
                    ImGui.Text(__multiselector.__GetLastSelectedName());
                }
                else
                {
                    //Change the display text depending on what the user is actually seeing
                    ImGui.Text(string_concat(__multiselector.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others"));
                }
                
                //Little more aesthetic spacing
                ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
                
                //Here's where we jump to a different function to draw the actual properties
                if (__multiselector.__GetSelectedCount() > 0)
                {
                    ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                    _lastSelected.__BuildUI(__multiselector);
                    ImGui.EndChild();
                }
                
            ImGui.EndChild();
        }
        
        ImGui.End();
    }
}