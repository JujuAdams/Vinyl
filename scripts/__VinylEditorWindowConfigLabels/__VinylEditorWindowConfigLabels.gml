// Feather disable all

function __VinylEditorWindowConfigLabels(_stateStruct)
{
    var _document = __VinylDocument();
    
    var _contentDict = _document.__labelDict;
    
    var _contentNameArray = variable_struct_get_names(_contentDict);
    array_sort(_contentNameArray, true);
    
    var _tabState = _stateStruct.__tabLabels;
    
    //Use the selection handler for this tab and ensure its binding to the project's sound dictionary
    //This dictionary will be used to track item selection
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_contentDict, __VinylClassLabel, undefined);
    
    var _filter    = _tabState.__filter;
    var _useFilter = _tabState.__useFilter;
    
    var _func = function(_func, _visibleArray, _contentDict, _contentName, _selectionHandler, _filter, _useFilter, _root)
    {
        var _target = _contentDict[$ _contentName];
        
        var _multiselect   = _selectionHandler.__GetMultiselect();
        var _seeSelected   = _selectionHandler.__GetSeeSelected();
        var _seeUnselected = _selectionHandler.__GetSeeUnselected();
        
        var _selected = _selectionHandler.__IsSelected(_contentName);
        
        if ((not _root) || (not _target.__isChild))
        {
            if ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)) //Selected check
            {
                if ((not _useFilter) || __VinylFilterApply(_filter, _target)) //General filter
                {
                    var _selected = _selectionHandler.__IsSelected(_contentName);
                    var _childArray = _target.__childArray;
                        
                    var _flags = ImGuiTreeNodeFlags.OpenOnArrow;
                    
                    if (_selectionHandler.__IsSelected(_contentName))
                    {
                        _flags |= ImGuiTreeNodeFlags.Selected;
                    }
                    
                    if (array_length(_childArray) <= 0)
                    {
                        _flags |= ImGuiTreeNodeFlags.Bullet;
                    }
                    
                    var _open = ImGui.TreeNodeEx(_contentName + "##Select " + _contentName, _flags);
                    if ((not ImGui.IsItemToggledOpen()) && ImGui.IsItemClicked())
                    {
                        _selectionHandler.__SelectToggle(_contentName);
                    }
                    
                    if (_open)
                    {
                        var _i = 0;
                        repeat(array_length(_childArray))
                        {
                            _func(_func, _visibleArray, _contentDict, _childArray[_i], _selectionHandler, _filter, _useFilter, false);
                            ++_i;
                        }
                        
                        ImGui.TreePop();
                    }
                    
                    //Push the name of this visible sound to our array
                    array_push(_visibleArray, _contentName);
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
        
        if (ImGui.Button("New Label"))
        {
            __VinylEditorSharedAdd(_contentDict, "Label", __VinylClassLabel);
        }
        
        ImGui.BeginChild("Label View", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, true);
            
            //Keep an array of all visible sounds. We use this later for the "select all" button
            var _visibleArray = [];
            
            //Iterate over every sound in the project and show them in the editor
            var _i = 0;
            repeat(array_length(_contentNameArray))
            {
                _func(_func, _visibleArray, _contentDict, _contentNameArray[_i], _selectionHandler, _filter, _useFilter, true);
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
        var _selectedCount = _selectionHandler.__GetSelectedCount();
        var _lastSelected  = _selectionHandler.__lastSelected;
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 20);
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectedCount == 0)
        {
            //Add some helpful text to guide users if nothing's selected
            ImGui.Text("Please select a label from the menu on the left");
        }
        else
        {
            //Change the display text depending on what the user is actually seeing
            ImGui.Text(_selectionHandler.__GetLastSelectedName());
            
            ImGui.SameLine(200);
            
            if (ImGui.Button("Add Child"))
            {
                var _parent = _contentDict[$ _lastSelected];
                var _name = __VinylEditorSharedAdd(_contentDict, "Label", __VinylClassLabel);
                
                array_push(_parent.__childArray, _name);
                
                var _child = _contentDict[$ _name];
                _child.__isChild = true;
                _child.__parent = _lastSelected;
            }
            
            ImGui.SameLine(undefined, 30);
            
            if (ImGui.Button("Delete"))
            {
                
            }
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        //Here's where we jump to a different function to draw the actual properties
        if (_selectionHandler.__GetSelectedCount() > 0)
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                __VinylEditorPropertiesLabel(_contentDict, _lastSelected, _selectionHandler);
            ImGui.EndChild();
        }
    ImGui.EndChild();
}