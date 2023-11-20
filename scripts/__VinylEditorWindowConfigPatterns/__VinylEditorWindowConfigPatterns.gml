// Feather disable all

function __VinylEditorWindowConfigPatterns(_stateStruct)
{
    var _document = __VinylDocument();
    
    var _contentDict = _document.__patternDict;
    
    var _contentNameArray = variable_struct_get_names(_contentDict);
    array_sort(_contentNameArray, true);
    
    var _tabState = _stateStruct.__tabPatterns;
    
    //Use the selection handler for this tab and ensure its binding to the project's sound dictionary
    //This dictionary will be used to track item selection
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_contentDict, __VinylClassPatternRefSound, undefined);
    
    var _filter    = _tabState.__filter;
    var _useFilter = _tabState.__useFilter;
    
    var _func = function(_func, _visibleArray, _target, _selectionHandler, _filter, _useFilter)
    {
        if ((not is_instanceof(_target, __VinylClassPatternFallback)) && (not is_instanceof(_target, __VinylClassPatternSound)))
        {
            var _name = _target.__name;
            
            var _multiselect   = _selectionHandler.__GetMultiselect();
            var _seeSelected   = _selectionHandler.__GetSeeSelected();
            var _seeUnselected = _selectionHandler.__GetSeeUnselected();
            
            var _selected = _selectionHandler.__IsSelected(_name);
            
            if ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)) //Selected check
            {
                if ((not _useFilter) || __VinylFilterApply(_filter, _target)) //General filter
                {
                    var _selected = _selectionHandler.__IsSelected(_name);
                    var _childArray = _target[$ "__childArray"];
                    
                    var _flags = ImGuiTreeNodeFlags.OpenOnArrow;
                    
                    if (_selectionHandler.__IsSelected(_name))
                    {
                        _flags |= ImGuiTreeNodeFlags.Selected;
                    }
                    
                    if ((not is_array(_childArray)) || (array_length(_childArray) <= 0))
                    {
                        _flags |= ImGuiTreeNodeFlags.Bullet;
                    }
                    
                    var _open = ImGui.TreeNodeEx(_name + "##Select " + _name, _flags);
                    if ((not ImGui.IsItemToggledOpen()) && ImGui.IsItemClicked())
                    {
                        _selectionHandler.__SelectToggle(_name);
                    }
                    
                    if (_open)
                    {
                        if (is_array(_childArray))
                        {
                            var _i = 0;
                            repeat(array_length(_childArray))
                            {
                                _func(_func, _visibleArray, _childArray[_i], _selectionHandler, _filter, _useFilter);
                                ++_i;
                            }
                        }
                        
                        ImGui.TreePop();
                    }
                    
                    //Push the name of this visible sound to our array
                    array_push(_visibleArray, _name);
                }
            }
        }
    }
    
    ImGui.BeginChild("Left Pane", 0.3*ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        //General filter checkbox and edit button
        ImGui.Text("Filter");
        ImGui.SameLine();
        _tabState.__useFilter = ImGui.Checkbox("##Filter", _useFilter);
        ImGui.SameLine();
        if (ImGui.Button("Edit..."))
        {
            __VinylEditorWindowSetOpen("__filter", true);
        }
        
        if (ImGui.Button("New Pattern"))
        {
            _document.__NewPattern();
        }
        
        ImGui.BeginChild("Label View", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, true);
            
            //Keep an array of all visible sounds. We use this later for the "select all" button
            var _visibleArray = [];
            
            //Iterate over every sound in the project and show them in the editor
            var _i = 0;
            repeat(array_length(_contentNameArray))
            {
                var _target = _contentDict[$ _contentNameArray[_i]];
                _func(_func, _visibleArray, _target, _selectionHandler, _filter, _useFilter);
                ++_i;
            }
            
        ImGui.EndChild();
        
        //Build the selection handler UI at the bottom of the list of sounds
        _selectionHandler.__BuildUI(_visibleArray);
        
    ImGui.EndChild();
    
    
    
    //Ok! Now we do the right-hand properties pane
    
    
    
    ImGui.SameLine();
    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        //Collect some basic facts about the current selection(s)
        var _selectedCount  = _selectionHandler.__GetSelectedCount();
        var _lastSelected   = _selectionHandler.__lastSelected;
        var _selectedStruct = _contentDict[$ _lastSelected];
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 20);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if ((_selectedCount == 0) || (not is_struct(_selectedStruct)))
        {
            //Add some helpful text to guide users if nothing's selected
            ImGui.Text("Please select a pattern from the menu on the left");
        }
        else
        {
            //Change the display text depending on what the user is actually seeing
            ImGui.Text(_selectionHandler.__GetLastSelectedName());
            
            ImGui.SameLine(200);
            
            if (ImGui.Button("Rename"))
            {
                //TODO
            }
            
            ImGui.SameLine(undefined, 20);
            
            if (ImGui.Button("Add Child"))
            {
                _document.__NewLabel(_selectedStruct);
            }
            
            ImGui.SameLine(undefined, 20);
            
            if (ImGui.Button("Delete"))
            {
                _selectedStruct.__Discard();
                _selectionHandler.__Select(_lastSelected, false);
            }
            
            ImGui.SameLine(undefined, 20);
            
            ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
            if (ImGui.BeginCombo("##Pattern Type Combobox", "Type", ImGuiComboFlags.None))
            {
                if (ImGui.Selectable("Sound"))
                {
                    
                }
                
                if (ImGui.Selectable("Name Match"))
                {
                    
                }
                
                if (ImGui.Selectable("Asset Tag"))
                {
                    
                }
                
                if (ImGui.Selectable("Basic"))
                {
                    
                }
                
                if (ImGui.Selectable("Shuffle"))
                {
                    
                }
                
                if (ImGui.Selectable("Multi"))
                {
                    
                }
                
                if (ImGui.Selectable("Queue"))
                {
                    
                }
                
                ImGui.EndCombo();
            }
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        //Here's where we jump to a different function to draw the actual properties
        if ((_selectedCount > 0) && is_struct(_selectedStruct))
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                _contentDict[$ _lastSelected].__BuildPropertyUI(_selectionHandler);
            ImGui.EndChild();
        }
    ImGui.EndChild();
}