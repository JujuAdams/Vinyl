// Feather disable all

function __VinylEditorInit()
{
    static _editor = __VinylGlobalData().__editor;
    with(_editor)
    {
        __showing = false;
        
        __statusText        = undefined;
        __statusTextLastSet = -infinity;
        
        __windowStates = {
            __desktop: {
                __function: __VinylEditorWindowDesktop,
                __open: true,
                __collapsed: false,
            },
            
            __settings: {
                __function: __VinylEditorWindowSettings,
                __open: false,
                __collapsed: false,
            },
            
            __project: {
                __function: __VinylEditorWindowProject,
                __open: false,
                __collapsed: false,
            },
            
            __config: {
                __function: __VinylEditorWindowConfig,
                __open: false,
                __collapsed: false,
                __popupData: {
                    __type:     undefined,
                    __target:   undefined,
                    __tempName: undefined,
                },
                __tabSounds: {
                    __selectionHandler: new __VinylClassSelectionHandler(),
                    __filter:           new __VinylClassFilterSound(),
                    __useFilter:        false,
                    __seeModified:      true,
                    __seeUnmodified:    true,
                },
                __tabLabels: {
                    __selectionHandler: new __VinylClassSelectionHandler(),
                    __filter:           new __VinylClassFilterLabel(),
                    __useFilter:        false,
                },
                __tabStacks: {
                    __selectionHandler: new __VinylClassSelectionHandler(),
                    __filter:           new __VinylClassFilterLabel(),
                    __useFilter:        false,
                },
                __tabKnobs: {
                    __selectionHandler: new __VinylClassSelectionHandler(),
                    __filter:           new __VinylClassFilterLabel(),
                    __useFilter:        false,
                },
                __tabPatterns: {
                    __quickDelete: false,
                },
            },
            
            __filter: {
                __function: __VinylEditorWindowFilter,
                __open: false,
                __collapsed: false,
                __target: undefined,
            },
            
            __nowPlaying: {
                __function: __VinylEditorWindowNowPlaying,
                __open: false,
                __collapsed: false,
            },
            
            __snapshots: {
                __function: __VinylEditorWindowSnapshots,
                __open: false,
                __collapsed: false,
            },
            
            __soundTest: {
                __function: __VinylEditorWindowSoundTest,
                __open: false,
                __collapsed: false,
            },
        }
        
        __globalSettings = {};
        __globalSettingDirty = false;
    }
    
    if (not __VinylGetEditorEnabled()) return;
    
    __VinylGlobalSettingsLoad();
    
    ImGui.__Initialize();
}