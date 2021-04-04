/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_Architect_Init() {

    // Initialize Ikarus
	MEM_InitAll();
 
	// Wrapper for "LeGo_Init" to ensure correct LeGo initialization without breaking the mod
	// LeGo_MergeFlags( LeGo_PrintS | LeGo_HookEngine | LeGo_FrameFunctions | LeGo_PermMem | LeGo_View | LeGo_Interface | LeGo_EventHandler | LeGo_ConsoleCommands);
	LeGo_MergeFlags( LeGo_PrintS | LeGo_FrameFunctions | LeGo_PermMem | LeGo_View | LeGo_Interface | LeGo_EventHandler | LeGo_ConsoleCommands);

    // WRITE YOUR INITIALIZATIONS HERE
	Architect_Init();
	
};

