// Feather disable all

/// @param sourceStruct
/// @param selectionHandler
/// @param forceLookupDict

function __VinylEditorApplyAll(_sourceStruct, _selectionHandler, _forceLookupDict)
{
    __VinylEditorApply(_sourceStruct, _selectionHandler, _forceLookupDict, variable_struct_get_names(_sourceStruct));
}