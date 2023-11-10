// Feather disable all

function __VinylEditorInit()
{
    static _editor = __VinylGlobalData().__editor;
    with(_editor)
    {
        __showing = false;
        
        __windowDict = {
            __desktop:      { __open: true,  __collapsed: false, __function: __VinylEditorWindowDesktop      },
            __settings:     { __open: false, __collapsed: false, __function: __VinylEditorWindowSettings     },
            __project:      { __open: false, __collapsed: false, __function: __VinylEditorWindowProject      },
            __configAssets: { __open: false, __collapsed: false, __function: __VinylEditorWindowConfigAssets },
            __nowPlaying:   { __open: false, __collapsed: false, __function: __VinylEditorWindowNowPlaying   },
            __snapshots:    { __open: false, __collapsed: false, __function: __VinylEditorWindowSnapshots    },
        }
        
        __globalSettings = {};
        __globalSettingDirty = false;
    }
    
    if (not __VinylGetEditorEnabled()) return;
    
    __VinylGlobalSettingsLoad();
    
    ImGui.__Initialize();
}