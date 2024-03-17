// Feather disable all

function __VedClassMultiselector() constructor
{
    __multiselect   = false;
    __seeSelected   = true;
    __seeUnselected = true;
    
    __selectedDict = {};
    __lastSelected = undefined;
    
    static __IsSelected = function(_name)
    {
        return variable_struct_exists(__selectedDict, _name);
    }
    
    static __GetSelectedCount = function()
    {
        return variable_struct_names_count(__selectedDict);
    }
    
    static __GetLastSelectedName = function()
    {
        return __lastSelected;
    }
    
    static __GetMultiselect = function()
    {
        return __multiselect;
    }
    
    static __GetSeeSelected = function()
    {
        return __seeSelected;
    }
    
    static __GetSeeUnselected = function()
    {
        return __seeUnselected;
    }
    
    static __SelectToggle = function(_name)
    {
        if (__multiselect)
        {
            __Select(_name, not __IsSelected(_name));
        }
        else
        {
            __Select(_name, true);
        }
    }
    
    static __Select = function(_name, _state)
    {
        if (_state == __IsSelected(_name)) return;
        
        if (not __multiselect)
        {
            __SelectNone();
        }
        
        if (_state)
        {
            __selectedDict[$ _name] = true;
            __lastSelected = _name;
        }
        else
        {
            variable_struct_remove(__selectedDict, _name);
            if (__lastSelected == _name) __lastSelected = undefined;
        }
    }
    
    static __SelectAll = function(_dictionary)
    {
        __SelectArray(variable_struct_get_names(_dictionary));
    }
    
    static __SelectArray = function(_nameArray)
    {
        var _length = array_length(_nameArray);
        var _i = 0;
        repeat(_length)
        {
            __selectedDict[$ _nameArray[_i]] = true;
            ++_i;
        }
        
        //Guarantee __lastSelected
        if ((__lastSelected == undefined) || (not variable_struct_exists(__selectedDict, __lastSelected)))
        {
            __lastSelected = (_length > 0)? _nameArray[_length-1] : undefined;
        }
    }
    
    static __SelectNone = function()
    {
        __selectedDict = {};
        __lastSelected = undefined;
    }
    
    static __SelectLast = function(_dictionary)
    {
        if (not __multiselect)
        {
            __selectedDict = {};
        }
        
        if ((__lastSelected != undefined) && variable_struct_exists(_dictionary, __lastSelected))
        {
            __Select(__lastSelected, true);
        }
        else
        {
            __lastSelected = undefined;
        }
    }
    
    static __ForEachSelected = function(_dictionary, _method)
    {
        var _nameArray = variable_struct_get_names(__selectedDict);
        var _i = 0
        repeat(array_length(_nameArray))
        {
            var _name = _nameArray[_i];
            _method(_name, _dictionary[$ _name]);
            ++_i;
        }
    }
    
    static __GetSelectedArray = function(_sort = true)
    {
        var _array = variable_struct_get_names(__selectedDict);
        if (_sort) array_sort(_array, true);
        return _array;
    }
    
    static __BuildUI = function(_dictionary, _visibleArray)
    {
        ImGui.Text("Multiselect");
        ImGui.SameLine();
        
        var _newValue = ImGui.Checkbox("##Multiselect", __multiselect);
        if (_newValue != __multiselect)
        {
            __multiselect = _newValue;
            
            if (not __multiselect)
            {
                __SelectLast(_dictionary);
            }
        }
        
        ImGui.BeginDisabled(not __multiselect);
            ImGui.SameLine();
            if (ImGui.Button("All"))
            {
                __SelectArray(_visibleArray);
            }
            
            ImGui.SameLine();
            if (ImGui.Button("None"))
            {
                __SelectNone(_dictionary);
            }
            
            var _newValue = ImGui.Checkbox("See selected", (not __multiselect) || __seeSelected);
            if (__multiselect)
            {
                __seeSelected = _newValue;
            }
            
            ImGui.SameLine(undefined, 20);
            var _newValue = ImGui.Checkbox("See unselected", (not __multiselect) || __seeUnselected);
            if (__multiselect)
            {
                __seeUnselected = _newValue;
            }
        ImGui.EndDisabled();
    }
}