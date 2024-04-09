// Feather disable all

function __VedClassWindowAssetTags() : __VedClassWindow() constructor
{
    __handle = "Asset Tags";
    
    __multiselector = new __VedClassMultiselector();
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        var _yypAssetArray = _project.__libSound.__GetNameArray();
        var _yypAssetDict  = _project.__libSound.__GetDictionary();
        
        ImGui.SetNextWindowSize(0.7*room_width, 0.8*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.15*room_width, 0.1*room_height, ImGuiCond.Once);
	    
        //Allow the filter window to stay on top
        //var _flags = __VinylEditorWindowGetOpen("__filter")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
        var _flags = ImGuiWindowFlags.None;
        
        var _return = ImGui.Begin(__handle, not __closed, _flags, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            ImGui.BeginChild("Left Pane", 0.5*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                //Keep an array of all visible sounds. We use this later for the "select all" button
                var _visibleArray = [];
                
                ImGui.BeginChild("Left Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50);
                /*
                //Iterate over every sound in the project and show them in the editor
                var _i = 0;
                repeat(array_length(_yypAssetArray))
                {
                    var _name = _yypAssetArray[_i];
                    
                    var _modified = _vinylAssetDict[$ _name].__GetModified();
                    var _selected = __multiselector.__IsSelected(_name);
                    
                    if (((_modified && __seeModified) || ((not _modified) && __seeUnmodified)) //Modified check
                    &&  ((not __multiselector.__multiselect) || (_selected && __multiselector.__seeSelected) || ((not _selected) && __multiselector.__seeUnselected))) //Selected check
                    {
                        //Push the name of this visible sound to our array
                        array_push(_visibleArray, _name);
                    }
                    
                    ++_i;
                }
                */
                
    			if (ImGui.TreeNodeEx("ImGui::TreeNode", ImGuiTreeNodeFlags.OpenOnArrow | ImGuiTreeNodeFlags.DefaultOpen))
                {
    				ImGui.Text("Hello!\nThis is some content inside of a tree node :)");
    				ImGui.TreePop();
    			}
                
                ImGui.EndChild();
                
                //Build the selection handler UI at the bottom of the list of sounds
                __multiselector.__BuildUI(_yypAssetDict, _visibleArray);
                
            ImGui.EndChild();
            
            
            
            //Ok! Now we do the right-hand properties pane
            
            
            
            ImGui.SameLine();
            ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                /*
                //Collect some basic facts about the current selection(s)
                var _selectedCount     = __multiselector.__GetSelectedCount();
                var _lastSelectedName  = __multiselector.__lastSelected;
                var _lastSelectedVinyl = _vinylAssetDict[$ _lastSelectedName];
                var _lastSelectedYYP   = _yypAssetDict[$ _lastSelectedName];
                var _modified          = is_struct(_lastSelectedVinyl)? _lastSelectedVinyl.__GetModified() : false;
                
                //Bit of aesthetic spacing
                ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
                
                if (_selectedCount <= 0)
                {
                    //Add some helpful text to guide users if nothing's selected
                    ImGui.Text("Please select a sound from the menu on the left.");
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
                    _lastSelectedVinyl.__BuildUI(__multiselector, _vinylAssetDict);
                    ImGui.NewLine();
                    _lastSelectedYYP.__BuildUI(__multiselector, _yypAssetDict);
                    ImGui.EndChild();
                }
                */
                
            ImGui.EndChild();
        }
        
        ImGui.End();
    }
}