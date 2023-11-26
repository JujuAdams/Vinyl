// Feather disable all

function __VinylEditorWindowConfigLabels(_stateStruct)
{
    var _document = __VinylDocument();
    
    var _contentDict = _document.__labelDict;
    
    var _contentNameArray = variable_struct_get_names(_contentDict);
    array_sort(_contentNameArray, true);
    
    var _tabState = _stateStruct.__tabLabels;
    var _makePopup = false;
    
    //Use the selection handler for this tab and ensure its binding to the project's sound dictionary
    //This dictionary will be used to track item selection
    var _selectionHandler = _tabState.__selectionHandler;
    _selectionHandler.__Bind(_contentDict, __VinylClassLabel, undefined);
    
    var _filter    = _tabState.__filter;
    var _useFilter = _tabState.__useFilter;
    
    var _func = function(_func, _visibleArray, _target, _selectionHandler, _filter, _useFilter, _root)
    {
        var _name = _target.__name;
        
        var _multiselect   = _selectionHandler.__GetMultiselect();
        var _seeSelected   = _selectionHandler.__GetSeeSelected();
        var _seeUnselected = _selectionHandler.__GetSeeUnselected();
        
        var _selected = _selectionHandler.__IsSelected(_name);
        
        if ((not _root) || (_target.__parent == undefined))
        {
            if ((not _multiselect) || (_selected && _seeSelected) || ((not _selected) && _seeUnselected)) //Selected check
            {
                if ((not _useFilter) || __VinylFilterApply(_filter, _target)) //General filter
                {
                    var _selected = _selectionHandler.__IsSelected(_name);
                    var _childArray = _target.__childArray;
                        
                    var _flags = ImGuiTreeNodeFlags.OpenOnArrow | ImGuiTreeNodeFlags.DefaultOpen;
                    
                    if (_selectionHandler.__IsSelected(_name))
                    {
                        _flags |= ImGuiTreeNodeFlags.Selected;
                    }
                    
                    if (array_length(_childArray) <= 0)
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
                        var _i = 0;
                        repeat(array_length(_childArray))
                        {
                            var _childName = _childArray[_i];
                            var _child = __VinylDocument().__GetLabel(_childName);
                            if (_child != undefined)
                            {
                                _func(_func, _visibleArray, _child, _selectionHandler, _filter, _useFilter, false);
                            }
                            
                            ++_i;
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
        
        if (ImGui.Button("New Label"))
        {
            _document.__NewLabel();
        }
        
        ImGui.BeginChild("Label View", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY() - 50, true);
            
            //Keep an array of all visible sounds. We use this later for the "select all" button
            var _visibleArray = [];
            
            //Iterate over every sound in the project and show them in the editor
            var _i = 0;
            repeat(array_length(_contentNameArray))
            {
                var _target = _contentDict[$ _contentNameArray[_i]];
                _func(_func, _visibleArray, _target, _selectionHandler, _filter, _useFilter, true);
                ++_i;
            }
            
        ImGui.EndChild();
        
        //Build the selection handler UI at the bottom of the list of sounds
        _selectionHandler.__BuildUI(_visibleArray);
        
    ImGui.EndChild();
    
    
    
    //Ok! Now we do the right-hand properties pane
    
    
        
    //Collect some basic facts about the current selection(s)
    var _selectedCount  = _selectionHandler.__GetSelectedCount();
    var _lastSelected   = _selectionHandler.__lastSelected;
    var _selectedStruct = _contentDict[$ _lastSelected];
    
    ImGui.SameLine();
    ImGui.BeginChild("Right Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY());
        
        //Bit of aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        if (_selectedCount == 0)
        {
            //Add some helpful text to guide users if nothing's selected
            ImGui.Text("Please select a knob from the menu on the left");
        }
        else
        {
            //Change the display text depending on what the user is actually seeing
            ImGui.Text(_selectionHandler.__GetLastSelectedName());
            
            ImGui.SameLine(200);
            
            if (ImGui.Button("Rename"))
            {
                _makePopup = true;
                
                with(_stateStruct.__popupData)
                {
                    __type     = "Rename";
                    __target   = _selectedStruct;
                    __tempName = _selectedStruct.__name;
                }
            }
            
            ImGui.SameLine(undefined, 20);
            
            if (ImGui.Button("Add Child"))
            {
                _document.__NewLabel(_lastSelected);
            }
            
            ImGui.SameLine(undefined, 20);
            
            if (ImGui.Button("Delete"))
            {
                _makePopup = true;
                
                with(_stateStruct.__popupData)
                {
                    __type   = "Delete";
                    __target = _selectedStruct;
                }
            }
        }
        
        //Little more aesthetic spacing
        ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 10);
        
        //Here's where we jump to a different function to draw the actual properties
        if (_selectionHandler.__GetSelectedCount() > 0)
        {
            ImGui.BeginChild("Right Inner Pane", ImGui.GetContentRegionAvailX(), ImGui.GetContentRegionAvailY(), false);
                _contentDict[$ _lastSelected].__BuildPropertyUI(_selectionHandler);
            ImGui.EndChild();
        }
    ImGui.EndChild();
    
    
    
    if (_stateStruct.__popupData.__target == _selectedStruct)
    {
        if (_makePopup)
        {
            ImGui.OpenPopup("Popup");
        }
        
        ImGui.SetNextWindowPos(window_get_width() / 2, window_get_height () / 2, ImGuiCond.Appearing, 0.5, 0.5);
        
        if (ImGui.BeginPopupModal("Popup", undefined, ImGuiWindowFlags.NoResize))
        {
            switch(_stateStruct.__popupData.__type)
            {
                case "Rename":
                    ImGui.Text("Please enter a new name for \"" + _stateStruct.__popupData.__target.__name + "\"");
                    
                    ImGui.Separator();
                    
                    _stateStruct.__popupData.__tempName = ImGui.InputText("##Rename Field", _stateStruct.__popupData.__tempName);
                    
                    if (ImGui.Button("Rename"))
                    {
                        if (_stateStruct.__popupData.__tempName != _stateStruct.__popupData.__target.__name)
                        {
                            _stateStruct.__popupData.__target.__Rename(_document, _stateStruct.__popupData.__tempName);
                            _selectionHandler.__Select(_lastSelected, false);
                            _selectionHandler.__Select(_stateStruct.__popupData.__tempName, true);
                        }
                        
                        _stateStruct.__popupData.__target = undefined;
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.SameLine(undefined, 40);
                    if (ImGui.Button("Cancel"))
                    {
                        _stateStruct.__popupData.__target = undefined;
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.EndPopup();	
                break;
                
                case "Delete":
                    ImGui.Text("Are you sure you want to delete \"" + _stateStruct.__popupData.__target.__name + "\"?\n\nThis cannot be undone!");
                    
                    ImGui.Separator();
                    
                    if (ImGui.Button("Delete"))
                    {
                        _selectedStruct.__Discard(_document);
                        _selectionHandler.__Select(_lastSelected, false);
                        
                        _stateStruct.__popupData.__target = undefined;
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.SameLine(undefined, 40);
                    if (ImGui.Button("Keep"))
                    {
                        _stateStruct.__popupData.__target = undefined;
                        ImGui.CloseCurrentPopup();
                    }
                    
                    ImGui.EndPopup();
                break;
            }
        }
    }
}