// Feather disable all

function __VedClassWindowAudioGroups() : __VedClassWindow() constructor
{
    __handle = "Audio Groups";
    
    __filter = new __VedClassFilter();
    __useFilter = false;
    
    __moveToTarget = __VED_DEFAULT_AUDIO_GROUP;
    
    __multiselectorAG    = new __VedClassMultiselector();
    __multiselectorAsset = new __VedClassMultiselector();
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        var _audioGroupArray = _project.__libAudioGroup.__GetNameArray();
        var _audioGroupDict  = _project.__libAudioGroup.__GetDictionary();
        var _soundDict       = _project.__libSound.__GetDictionary();
        
        ImGui.SetNextWindowSize(0.7*room_width, 0.7*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.15*room_width, 0.15*room_height, ImGuiCond.Once);
	    
        //Allow the filter window to stay on top
        //var _flags = __VinylEditorWindowGetOpen("__filter")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
        var _flags = ImGuiWindowFlags.None;
        
        var _return = ImGui.Begin(__handle, not __closed, _flags, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            ImGui.BeginChild("Left Pane", 0.33*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                if (ImGui.Button("New")) __VedModalOpen(__VedClassModalNewAudioGroup);
                ImGui.SameLine(undefined, 20);
                
                var _selectedCount = __multiselectorAG.__GetSelectedCount();
                var _disabled = (_selectedCount <= 0);
                if (not _disabled)
                {
                    if ((_selectedCount == 1) && (__multiselectorAG.__GetLastSelectedName() == __VED_DEFAULT_AUDIO_GROUP))
                    {
                        _disabled = true;
                    }
                }
                
                ImGui.BeginDisabled(_disabled);
                if (ImGui.Button("Delete"))
                {
                    if (_selectedCount > 0)
                    {
                        var _modal = __VedModalOpen(__VedClassModalDeleteAsset);
                        
                        if (_selectedCount == 1)
                        {
                            //Change the display text depending on what the user is actually seeing
                            _modal.__assetName = __multiselectorAG.__GetLastSelectedName();
                        }
                        else
                        {
                            //Change the display text depending on what the user is actually seeing
                            _modal.__assetName = string_concat(__multiselectorAG.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others");
                        }
                        
                        _modal.__function = function()
                        {
                            var _project        = _system.__project;
                            var _audioGroupDict = _project.__libAudioGroup.__GetDictionary();
                        
                            __multiselectorAG.__ForEachSelected(_audioGroupDict,
                            method({
                                __library: _project.__libAudioGroup,
                            },
                            function(_name, _struct)
                            {
                                if (_name != __VED_DEFAULT_AUDIO_GROUP)
                                {
                                    _struct.__MoveAllToDefault();
                                    __library.__RemoveByName(_name);
                                }
                            }));
                        
                            _system.__project.__SaveAudioGroups();
                            __multiselectorAG.__SelectNone();
                        }
                    }
                }
                ImGui.EndDisabled();
                
                ImGui.BeginChild("Left Pane List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY()-50, undefined, ImGuiWindowFlags.AlwaysVerticalScrollbar);
                
                    //Keep an array of all visible sounds. We use this later for the "select all" button
                    var _visibleArray = [];
                
                    //DRY - Used for both the fallback sound config and standard sound configs
                    var _funcBuildSelectable = function(_name, _multiselector)
                    {
                        var _selected = _multiselector.__IsSelected(_name);
                        if (ImGui.Selectable(_name + "##Select " + _name, _selected)) _multiselector.__SelectToggle(_name);
                    }
                    
                    //Iterate over every sound in the project and show them in the editor
                    var _i = 0;
                    repeat(array_length(_audioGroupArray))
                    {
                        var _name = _audioGroupArray[_i];
                        
                        var _selected = __multiselectorAG.__IsSelected(_name);
                        if ((not __multiselectorAG.__multiselect) || (_selected && __multiselectorAG.__seeSelected) || ((not _selected) && __multiselectorAG.__seeUnselected)) //Selected check
                        {
                            _funcBuildSelectable(_name, __multiselectorAG);
                            
                            //Push the name of this visible sound to our array
                            array_push(_visibleArray, _name);
                        }
                        
                        ++_i;
                    }
                    
                ImGui.EndChild();
                
                //Build the selection handler UI at the bottom of the list of sounds
                __multiselectorAG.__BuildUI(_audioGroupDict, _visibleArray);
                
            ImGui.EndChild();
            
            
            
            //Ok! Now we do the right-hand properties pane
            ImGui.SameLine();
            ImGui.BeginChild("Middle Pane", 0.5*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                //Collect some basic facts about the current selection(s)
                var _selectedCount = __multiselectorAG.__GetSelectedCount();
                if (_selectedCount <= 0)
                {
                    //Add some helpful text to guide users if nothing's selected
                    ImGui.TextWrapped("Please select an audio group from the menu on the left.");
                }
                else
                {
                    if (_selectedCount == 1)
                    {
                        //Change the display text depending on what the user is actually seeing
                        ImGui.Text(__multiselectorAG.__GetLastSelectedName());
                    }
                    else
                    {
                        //Change the display text depending on what the user is actually seeing
                        ImGui.Text(string_concat(__multiselectorAG.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others"));
                    }
                    
                    ImGui.NewLine();
                    
                    //General filter checkbox and edit button
                    ImGui.Text("Filter");
                    ImGui.SameLine();
                    __useFilter = ImGui.Checkbox("##Filter", __useFilter);
                    ImGui.SameLine();
                    if (ImGui.Button("Edit...")) __VedWindowOpenSingle(__VedClassWindowFilter).__filter = __filter;
                }
                
                //Here's where we jump to a different function to draw the actual properties
                if (_selectedCount > 0)
                {
                    ImGui.BeginChild("Middle Pane List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, undefined, ImGuiWindowFlags.AlwaysVerticalScrollbar);
                        
                        //Keep an array of all visible sounds. We use this later for the "select all" button
                        var _visibleArray = [];
                        var _assetArray = _project.__libSound.__GetNameArray();
                        
                        var _assetArray = [];
                        
                        __multiselectorAG.__ForEachSelected(_audioGroupDict,
                        method({
                            __assetArray: _assetArray,
                        },
                        function(_name, _struct)
                        {
                            _struct.__CopyAssetArrayTo(__assetArray);
                        }));
                        
                        array_resize(_assetArray, array_unique_ext(_assetArray));
                        array_sort(_assetArray, true);
                        
                        //Iterate over every sound in the project and show them in the editor
                        var _i = 0;
                        repeat(array_length(_assetArray))
                        {
                            var _name = _assetArray[_i];
                            
                            var _selected = __multiselectorAsset.__IsSelected(_name);
                            if ((not __multiselectorAsset.__multiselect) || (_selected && __multiselectorAsset.__seeSelected) || ((not _selected) && __multiselectorAsset.__seeUnselected)) //Selected check
                            {
                                if ((not __useFilter) || __filter.__Apply(_soundDict[$ _name]))
                                {
                                    _funcBuildSelectable(_name, __multiselectorAsset);
                                    
                                    //Push the name of this visible sound to our array
                                    array_push(_visibleArray, _name);
                                }
                            }
                            
                            ++_i;
                        }
                    
                    ImGui.EndChild();
                    
                    //Build the selection handler UI at the bottom of the list of sounds
                    __multiselectorAsset.__BuildUI(_soundDict, _visibleArray);
                }
                
            ImGui.EndChild();
            
            ImGui.SameLine();
            
            ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                ImGui.BeginDisabled(__multiselectorAsset.__GetSelectedCount() <= 0);
                
                if (ImGui.Button("Move To"))
                {
                    __multiselectorAsset.__ForEachSelected(_soundDict,
                    method({
                        __audioGroup: __moveToTarget,
                    },
                    function(_name, _struct)
                    {
                        _struct.__SetAudioGroup(__audioGroup);
                    }));
                    
                    __multiselectorAsset.__SelectNone();
                }
                
                ImGui.SameLine(undefined, 20);
                
                if (ImGui.BeginCombo("##Audio Group", __moveToTarget, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_audioGroupArray))
                    {
                        var _audioGroup = _audioGroupArray[_i];
                        if (ImGui.Selectable(_audioGroup, __moveToTarget == _audioGroup))
                        {
                            __moveToTarget = _audioGroup;
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
                
                ImGui.EndDisabled();
                
                ImGui.NewLine();
                ImGui.NewLine();
                
                ImGui.BeginChild("Right Pane List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, undefined, ImGuiWindowFlags.AlwaysVerticalScrollbar);
                
                var _remove = undefined;
                var _array = __multiselectorAsset.__GetSelectedArray();
                if (array_length(_array) <= 0)
                {
                    ImGui.Text("(No sounds selected)");
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(_array))
                    {
                        if (ImGui.SmallButton("x##" + string(_i))) _remove = _array[_i]; 
                        ImGui.SameLine();
                        ImGui.Text(_array[_i]);
                        
                        ++_i;
                    }
                    
                    if (_remove != undefined)
                    {
                        __multiselectorAsset.__Select(_remove, false);
                    }
                }
                
                ImGui.EndChild();
                
            ImGui.EndChild();
        }
        
        ImGui.End();
    }
}