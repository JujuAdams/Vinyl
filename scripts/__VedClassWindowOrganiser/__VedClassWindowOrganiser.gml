// Feather disable all

function __VedClassWindowOrganiser() : __VedClassWindow() constructor
{
    __handle = "Organiser";
    
    
    
    __filterTag    = new __VedClassSoundFilter();
    __useFilterTag = false;
    
    if (_system.__project.__libAssetTag.__GetCount() <= 0)
    {
        __moveToTargetAssetTag = "<no asset tags>";
    }
    else
    {
        __moveToTargetAssetTag = _system.__project.__libAssetTag.__GetNameByIndex(0);
    }
    
    __multiselectorTag      = new __VedClassMultiselector();
    __multiselectorTagAsset = new __VedClassMultiselector();
    
    
    
    __filterAG    = new __VedClassSoundFilter();
    __useFilterAG = false;
    
    __moveToTargetAG = __VED_DEFAULT_AUDIO_GROUP;
    
    __multiselectorAG      = new __VedClassMultiselector();
    __multiselectorAGAsset = new __VedClassMultiselector();
    
    
    
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        var _project = _system.__project;
        
        ImGui.SetNextWindowSize(0.7*room_width, 0.7*room_height, ImGuiCond.Once);
        ImGui.SetNextWindowPos(0.15*room_width, 0.15*room_height, ImGuiCond.Once);
	    
        //Allow the filter window to stay on top
        //var _flags = __VinylEditorWindowGetOpen("__filterTag")? ImGuiWindowFlags.NoBringToFrontOnFocus : ImGuiWindowFlags.None;
        var _flags = ImGuiWindowFlags.None;
        
        var _return = ImGui.Begin(__handle, not __closed, _flags, ImGuiReturnMask.Both);
        __closed = ((_return & ImGuiReturnMask.Pointer) <= 0);
        
        if (_return & ImGuiReturnMask.Return)
        {
            if (ImGui.BeginTabBar("Organiser Tab Bar"))
            {
                if (ImGui.BeginTabItem("Asset Tags"))
                {
                    var _assetTagArray = _project.__libAssetTag.__GetNameArray();
                    var _assetTagDict  = _project.__libAssetTag.__GetDictionary();
                    var _soundDict     = _project.__libSound.__GetDictionary();
                    
                    ImGui.BeginChild("Left Pane", 0.33*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                        if (ImGui.Button("New")) __VedModalOpen(__VedClassModalNewAssetTag);
                        ImGui.SameLine(undefined, 20);
                
                        var _selectedCount = __multiselectorTag.__GetSelectedCount();
                        var _disabled = (_selectedCount <= 0);
                        if (not _disabled)
                        {
                            if ((_selectedCount == 1) && (__multiselectorTag.__GetLastSelectedName() == __VED_DEFAULT_AUDIO_GROUP))
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
                                    _modal.__assetName = __multiselectorTag.__GetLastSelectedName();
                                }
                                else
                                {
                                    //Change the display text depending on what the user is actually seeing
                                    _modal.__assetName = string_concat(__multiselectorTag.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others");
                                }
                        
                                _modal.__function = function()
                                {
                                    var _project      = _system.__project;
                                    var _assetTagDict = _project.__libAssetTag.__GetDictionary();
                            
                                    __multiselectorTag.__ForEachSelected(_assetTagDict,
                                    method({
                                        __library: _project.__libAssetTag,
                                    },
                                    function(_name, _struct)
                                    {
                                        if (_name != __VED_DEFAULT_AUDIO_GROUP)
                                        {
                                            _struct.__RemoveFromAll();
                                            __library.__RemoveByName(_name);
                                        }
                                    }));
                            
                                    __multiselectorTag.__SelectNone();
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
                            repeat(array_length(_assetTagArray))
                            {
                                var _name = _assetTagArray[_i];
                        
                                var _selected = __multiselectorTag.__IsSelected(_name);
                                if ((not __multiselectorTag.__multiselect) || (_selected && __multiselectorTag.__seeSelected) || ((not _selected) && __multiselectorTag.__seeUnselected)) //Selected check
                                {
                                    _funcBuildSelectable(_name, __multiselectorTag);
                            
                                    //Push the name of this visible sound to our array
                                    array_push(_visibleArray, _name);
                                }
                        
                                ++_i;
                            }
                    
                        ImGui.EndChild();
                
                        //Build the selection handler UI at the bottom of the list of sounds
                        __multiselectorTag.__BuildUI(_assetTagDict, _visibleArray);
                
                    ImGui.EndChild();
            
                    ImGui.SameLine();
                    ImGui.BeginChild("Tab Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
            
                    var _selectedCount = __multiselectorTag.__GetSelectedCount();
            
                    //Ok! Now we do the right-hand properties pane
                    ImGui.BeginChild("Middle Pane", 0.5*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                        if (_selectedCount <= 0)
                        {
                            //Add some helpful text to guide users if nothing's selected
                            ImGui.TextWrapped("Please select an asset tag from the menu on the left.");
                        }
                        else
                        {
                            if (_selectedCount == 1)
                            {
                                //Change the display text depending on what the user is actually seeing
                                ImGui.Text(__multiselectorTag.__GetLastSelectedName());
                            }
                            else
                            {
                                //Change the display text depending on what the user is actually seeing
                                ImGui.Text(string_concat(__multiselectorTag.__GetLastSelectedName(), " and ", string(_selectedCount-1), " others"));
                            }
                    
                            ImGui.NewLine();
                    
                            //General filter checkbox and edit button
                            ImGui.Text("Filter");
                            ImGui.SameLine();
                            __useFilterTag = ImGui.Checkbox("##Filter", __useFilterTag);
                            ImGui.SameLine();
                            if (ImGui.Button("Edit...")) __VedWindowOpenSingle(__VedClassWindowFilter).__filterTag = __filterTag;
                        }
                
                        //Here's where we jump to a different function to draw the actual properties
                        if (_selectedCount > 0)
                        {
                            ImGui.BeginChild("Middle Pane List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, undefined, ImGuiWindowFlags.AlwaysVerticalScrollbar);
                        
                                //Keep an array of all visible sounds. We use this later for the "select all" button
                                var _visibleArray = [];
                                var _assetArray = _project.__libSound.__GetNameArray();
                        
                                var _assetArray = [];
                        
                                __multiselectorTag.__ForEachSelected(_assetTagDict,
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
                            
                                    var _selected = __multiselectorTagAsset.__IsSelected(_name);
                                    if ((not __multiselectorTagAsset.__multiselect) || (_selected && __multiselectorTagAsset.__seeSelected) || ((not _selected) && __multiselectorTagAsset.__seeUnselected)) //Selected check
                                    {
                                        if ((not __useFilterTag) || __filterTag.__Apply(_soundDict[$ _name]))
                                        {
                                            _funcBuildSelectable(_name, __multiselectorTagAsset);
                                    
                                            //Push the name of this visible sound to our array
                                            array_push(_visibleArray, _name);
                                        }
                                    }
                            
                                    ++_i;
                                }
                    
                            ImGui.EndChild();
                    
                            //Build the selection handler UI at the bottom of the list of sounds
                            __multiselectorTagAsset.__BuildUI(_soundDict, _visibleArray);
                        }
                
                    ImGui.EndChild();
            
                    ImGui.SameLine();
            
                    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                        
                        ImGui.BeginDisabled(__multiselectorTagAsset.__GetSelectedCount() <= 0);
                        
                        var _lastSelectedName = __multiselectorTag.__GetLastSelectedName() ?? "Tag";
                        if (ImGui.Button("Remove From " + _lastSelectedName))
                        {
                            __multiselectorTagAsset.__ForEachSelected(_soundDict,
                            method({
                                __assetTag: __moveToTargetAssetTag,
                            },
                            function(_name, _struct)
                            {
                                _struct.__SetAssetTag(__assetTag, false);
                            }));
                    
                            __multiselectorTagAsset.__SelectNone();
                        }
                        
                        if (ImGui.Button("Add To"))
                        {
                            __multiselectorTagAsset.__ForEachSelected(_soundDict,
                            method({
                                __assetTag: __moveToTargetAssetTag,
                            },
                            function(_name, _struct)
                            {
                                _struct.__SetAssetTag(__assetTag, true);
                            }));
                    
                            __multiselectorTagAsset.__SelectNone();
                        }
                
                        ImGui.SameLine(undefined, 20);
                
                        if (ImGui.BeginCombo("##Asset Tag", __moveToTargetAssetTag, ImGuiComboFlags.None))
                        {
                            var _i = 0;
                            repeat(array_length(_assetTagArray))
                            {
                                var _assetTag = _assetTagArray[_i];
                                if (ImGui.Selectable(_assetTag, __moveToTargetAssetTag == _assetTag))
                                {
                                    __moveToTargetAssetTag = _assetTag;
                                }
                        
                                ++_i;
                            }
                    
                            ImGui.EndCombo();
                        }
                
                        ImGui.EndDisabled();
                
                        ImGui.NewLine();
                
                        ImGui.BeginChild("Right Pane List", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, undefined, ImGuiWindowFlags.AlwaysVerticalScrollbar);
                
                        var _remove = undefined;
                        var _array = __multiselectorTagAsset.__GetSelectedArray();
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
                                __multiselectorTagAsset.__Select(_remove, false);
                            }
                        }
                
                        ImGui.EndChild();
                
                    ImGui.EndChild();
                    ImGui.EndChild();
                    ImGui.EndTabItem();
                }
                
                if (ImGui.BeginTabItem("Audio Groups"))
                {
                    var _audioGroupArray = _project.__libAudioGroup.__GetNameArray();
                    var _audioGroupDict  = _project.__libAudioGroup.__GetDictionary();
                    var _soundDict       = _project.__libSound.__GetDictionary();
                    
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
                            __useFilterAG = ImGui.Checkbox("##Filter", __useFilterAG);
                            ImGui.SameLine();
                            if (ImGui.Button("Edit...")) __VedWindowOpenSingle(__VedClassWindowFilter).__filterAG = __filterAG;
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
                            
                                    var _selected = __multiselectorAGAsset.__IsSelected(_name);
                                    if ((not __multiselectorAGAsset.__multiselect) || (_selected && __multiselectorAGAsset.__seeSelected) || ((not _selected) && __multiselectorAGAsset.__seeUnselected)) //Selected check
                                    {
                                        if ((not __useFilterAG) || __filterAG.__Apply(_soundDict[$ _name]))
                                        {
                                            _funcBuildSelectable(_name, __multiselectorAGAsset);
                                    
                                            //Push the name of this visible sound to our array
                                            array_push(_visibleArray, _name);
                                        }
                                    }
                            
                                    ++_i;
                                }
                    
                            ImGui.EndChild();
                    
                            //Build the selection handler UI at the bottom of the list of sounds
                            __multiselectorAGAsset.__BuildUI(_soundDict, _visibleArray);
                        }
                
                    ImGui.EndChild();
            
                    ImGui.SameLine();
            
                    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
                
                        ImGui.BeginDisabled(__multiselectorAGAsset.__GetSelectedCount() <= 0);
                
                        if (ImGui.Button("Move To"))
                        {
                            __multiselectorAGAsset.__ForEachSelected(_soundDict,
                            method({
                                __audioGroup: __moveToTargetAG,
                            },
                            function(_name, _struct)
                            {
                                _struct.__SetAudioGroup(__audioGroup);
                            }));
                    
                            __multiselectorAGAsset.__SelectNone();
                        }
                
                        ImGui.SameLine(undefined, 20);
                
                        if (ImGui.BeginCombo("##Audio Group", __moveToTargetAG, ImGuiComboFlags.None))
                        {
                            var _i = 0;
                            repeat(array_length(_audioGroupArray))
                            {
                                var _audioGroup = _audioGroupArray[_i];
                                if (ImGui.Selectable(_audioGroup, __moveToTargetAG == _audioGroup))
                                {
                                    __moveToTargetAG = _audioGroup;
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
                        var _array = __multiselectorAGAsset.__GetSelectedArray();
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
                                __multiselectorAGAsset.__Select(_remove, false);
                            }
                        }
                
                        ImGui.EndChild();
                
                    ImGui.EndChild();
                    ImGui.EndChild();
                    ImGui.EndTabItem();
                }
            }
        }
        
        ImGui.End();
    }
}