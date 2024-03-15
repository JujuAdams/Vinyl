// Feather disable all

function __VedClassMultiselector() constructor
{
    __multiselect   = false;
    __seeSelected   = true;
    __seeUnselected = true;
    
    __selectedDict = {};
    __lastSelected = undefined;
    
    __sourceStructWeakRef = undefined;
    __constructor         = undefined;
    __resourceTypeName    = undefined;
    
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
    
    static __SelectAll = function()
    {
        __SelectArray(variable_struct_get_names(__sourceStructWeakRef.ref));
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
    
    static __SelectLast = function()
    {
        if (not __multiselect)
        {
            __selectedDict = {};
        }
        
        if ((__lastSelected != undefined) && variable_struct_exists(__sourceStructWeakRef.ref, __lastSelected))
        {
            __Select(__lastSelected, true);
        }
        else
        {
            __lastSelected = undefined;
        }
    }
    
    static __ForEachSelected = function(_method)
    {
        var _sourceStruct = __sourceStructWeakRef.ref;
        
        var _nameArray = variable_struct_get_names(__selectedDict);
        var _i = 0
        repeat(array_length(_nameArray))
        {
            var _name = _nameArray[_i];
            _method(_name, _sourceStruct[$ _name]);
            ++_i;
        }
    }
    
    static __Rename = function(_oldName, _newName)
    {
        var _sourceStruct = __sourceStructWeakRef.ref;
        if (variable_struct_exists(_sourceStruct, _oldName))
        {
            _sourceStruct[$ _newName] = _sourceStruct[$ _oldName];
            variable_struct_remove(_sourceStruct, _oldName);
            
            if (variable_struct_exists(__selectedDict, _oldName))
            {
                variable_struct_remove(__selectedDict, _oldName);
                __selectedDict[$ _newName] = true;
            }
            
            if (__lastSelected == _oldName)
            {
                __lastSelected = _newName;
            }
        }
        else
        {
            __Select(_oldName, false);
            
            if (__lastSelected == _oldName)
            {
                __lastSelected = undefined;
            }
        }
    }
    
    static __Bind = function(_sourceStruct, _constructor, _resourceTypeName)
    {
        var _change = false;
        
        if (__sourceStructWeakRef == undefined)
        {
            _change = true;
        }
        else if (not weak_ref_alive(__sourceStructWeakRef))
        {
            _change = true;
        }
        else if (__sourceStructWeakRef.ref != _sourceStruct)
        {
            _change = true;
        }
        
        if (__constructor != _constructor)
        {
            _change = true;
        }
        
        if (__resourceTypeName != _resourceTypeName)
        {
            _change = true;
        }
        
        if (not _change) return;
        
        __sourceStructWeakRef = weak_ref_create(_sourceStruct);
        __constructor         = _constructor;
        __resourceTypeName    = _resourceTypeName;
        
        __SelectNone();
    }
    
    static __BuildUI = function(_visibleArray)
    {
        ImGui.Text("Multiselect");
        ImGui.SameLine();
        
        var _newValue = ImGui.Checkbox("##Multiselect", __multiselect);
        if (_newValue != __multiselect)
        {
            __multiselect = _newValue;
            
            if (not __multiselect)
            {
                __SelectLast();
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
                __SelectNone();
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