//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
// Main file of the architect modification  //
//                                          //
////////////////////////////////////////////// 
//
// TODO:
// - ignore collisions of rays => hard distance move + disable currents vob collision
// - rotate construction to view at player
// - nicht jedes object ist eine chest! (MY_CHEST_NAME) o.s.ä.
// - mal ne runde refactoren wäre nicht verkehrt
// - ConcatStrings und Konsorten mit https://lego.worldofplayers.de/?Beispiele_StringBuilder ersetzen

// an int / boolean which determines if the mod is enabled or not
var int Architect_Mod_Enabled;

// has the current construction been placed or is the user still deciding where the building should be placed?
var int constructionBeingPlaced;

// the index of the currently selected construction
var int currentlySelectedBuildingIndex;

// the name of the currently selected construction
var string currentlySelectedBuildingName; 

// if a construction has been created this is the pointer to the corresponding vob
var int currentConstructionPtr;

// undo history list
var int undoArray;

// the state of the key usage for mouse 2 (used to detect if the player is currently placing some construction somewhere)
var int placementReturnState; 


// the initialize function, (should) get(s) called in Startup.d
func void Architect_Init() {

	undoArray = MEM_ArrayCreate();

	// raytracing.register_collisions
	register_collisions = 1;

	// initialize startup values
	constructionBeingPlaced = 0;
	
	currentConstructionCategoryIndex = CONSTRUCTION_CATEGORY_MOBS_ADDONS;
	currentConstructionCategoryName = CONSTRUCTION_SET_MOBS_ADDONS_NAME;
	
	currentlySelectedBuildingIndex = 0;
	currentlySelectedBuildingName = ReadUIArray(currentConstructionCategoryIndex, currentlySelectedBuildingIndex);
	
	// is the mod enabled?
	Architect_Mod_Enabled = 1;
	
	// TODO: Document me
	currentlySeenVob = 0;
	
	// TODO: Document me
	seeVobsEnabled = 0;
	
	// destroy the ui if there are previous versions available
	destroy_ui();

	// initialize the user interface
	initialize_ui();
	
	// initialize user ability to modify vob trafo
	initialize_transformations();
    
	// register console commands
	CC_Register(ToggleSprinting, "sprint ", "Toggle sprinting"); // this is left from the tutorial but i like it =)
	CC_Register(SpawnConstruction, "SpawnConstruction ", "Spawns a construction.");
	
	// register frame functions
	FF_ApplyGT(Architect_Input_Loop);
	FF_ApplyGT(Architect_Late_Update);
	FF_ApplyGT(Architect_Render_Loop);
	
	// register mouse listener 
	Event_AddOnce(Cursor_Event, MouseInputListener);
	
};

// deletes the last built construction
func void DeleteConstruction(var int vobPtr){
	
	// if there is any construction built, delete it
	if(vobPtr > 0){
	
		PrintS(ConcatStrings("Deleting last vob: ", IntToString(vobPtr)));
		
		MEM_DeleteVob(vobPtr);
		
		currentConstructionPtr = 0;

		// remove the last element from the list
		MEM_ArrayRemoveIndex(undoArray, MEM_ArraySize(undoArray));
		MEM_ArrayPop(undoArray);
		
		// notify the user "something gets scrambled, it must have been destroyed!"
		Snd_Play("Scroll_Unfold");
		
		
		PrintS(ConcatStrings("Total constructions: ", IntToString(MEM_ArraySize(undoArray))));
			
	
	};
	
};

func void DeleteRayTracedObject(){
		
		if(currentlySeenVob <= 0) { return; };
		
		PrintS(ConcatStrings("Deleting last vob: ", IntToString(currentlySeenVob)));
		
		MEM_DeleteVob(currentlySeenVob);
		
		currentConstructionPtr = 0;
		currentlySeenVob = 0;
		
		// notify the user "something gets scrambled, it must have been destroyed!"
		Snd_Play("Scroll_Unfold");
};

// 
// spawn a construction by providing a name and a position
// 
func string SpawnConstructionWithPosition(var string constructionName, var int posx, var int posy, var int posz) {

	PrintS(ConcatStrings("Spawning: ", constructionName));
	
	// create an empty integer array which holds the current position of the player
	var int position[3];
	position[0] = posx;
	position[1] = posy;
	position[2] = posz;

	// the pointer to the current object / construction which gets spawned
	// update pointer reference of the last built construction
	// currentConstructionPtr = InsertMobContainerPos("myNewChest", constructionName, _@(position), 0);
	currentConstructionPtr = InsertVobPos ("customObject", constructionName, _@(position), 0);
	
	// get a reference to the visual object via its pointer 
	var zCVob vob; vob = _^(currentConstructionPtr);
			
	// adjust bitfields
	// - toggle collision
	// - only show the visual of the vob
	// - etc. -> see bitfields at the end of the file
	vob.bitfield[0] = zCVob_bitfield0_showVisual;
	
	// add the pointer of the vob to the construction history list
	MEM_ArrayInsert (undoArray, currentConstructionPtr);
	
	PrintS(ConcatStrings4("Spawned construction: ", constructionName, " - Total construction: ", IntToString(MEM_ArraySize(undoArray))));
			
    return ConcatStrings4("Spawned construction: ", constructionName, " - Total construction: ", IntToString(MEM_ArraySize(undoArray)));
};


// 
// spawn a construction by providing a name
// 
func string SpawnConstruction(var string constructionName) {

    // get position of the player
    var zCVob her; her = Hlp_GetNpc(hero);
    
	// create an empty integer array which holds the current position of the player
	var int playerPosition[3];

	// return the x,y,z coordinates of the player from the vob's transformation matrix
    playerPosition[0] = her.trafoObjToWorld[3];
    playerPosition[1] = her.trafoObjToWorld[7];
    playerPosition[2] = her.trafoObjToWorld[11];
			
	// ...
	return SpawnConstructionWithPosition(constructionName, playerPosition[0], playerPosition[1], playerPosition[2]);
};

//
// gets executed every milli second
// checks if the "V"-Key has been pressed
// if the V key has been pressed, create a construction
// 
// For input handling, see: http://lego.worldofplayers.de/?Ikarus_Dokumentation
// 
func void Architect_Input_Loop() {



	// If the Key "F12" is pressed - toggle state of the mod
	if (MEM_KeyState (KEY_F12) == KEY_RELEASED) {
	
		// toggle the state of the mod
		if(Architect_Mod_Enabled == 0 ){ 
			
			initialize_ui();
			
			Architect_Mod_Enabled = 1;
			PrintS("Architect mod enabled!");
		}
		else if(Architect_Mod_Enabled == 1 ){
		
			destroy_ui();
		
			Architect_Mod_Enabled = 0;
			PrintS("Architect mod disabled!");
		};
		
	};
	
	
	
	// If the Key "F10" is pressed ...
	// TODO: just for debugging - remove in near future
	if (MEM_KeyState (KEY_F10) == KEY_RELEASED) {
		ExitGame();
	};	
	
	

	// delete the last created construction
	if (MEM_KeyState (MOUSE_XBUTTON1) == KEY_RELEASED) {
		
		if(currentlySeenVob > 0){
			DeleteRayTracedObject();
		} else if(MEM_ArraySize(undoArray) > 0){
			var int listItemPointer;
			listItemPointer = MEM_ArrayTop(undoArray);
			DeleteConstruction(listItemPointer);
		};
		
	};
	
	

	// Decrement the category index
	if (MEM_KeyState (KEY_NUMPAD1) == KEY_RELEASED) {
		if(currentConstructionCategoryIndex > 0){

			currentConstructionCategoryIndex = currentConstructionCategoryIndex - 1;
			currentlySelectedBuildingIndex = 0;
			currentlySelectedBuildingName = ReadUIArray(currentConstructionCategoryIndex, currentlySelectedBuildingIndex);
			
			updateBuildInfo();
			
		};
	};



	// Increment the category index
	if (MEM_KeyState (KEY_NUMPAD3) == KEY_RELEASED) {
		if(currentConstructionCategoryIndex < CONSTRUCTION_CATEGORIES_MAX - 1){

			currentConstructionCategoryIndex = currentConstructionCategoryIndex + 1;
			currentlySelectedBuildingIndex = 0;
			currentlySelectedBuildingName = ReadUIArray(currentConstructionCategoryIndex, currentlySelectedBuildingIndex);
			
			updateBuildInfo();
			
		};
	};


	
	// delete the last created construction
	if ( MEM_KeyState (KEY_X) == KEY_RELEASED) {
		if (register_collisions == 0){ register_collisions = 1; }
		else if (register_collisions == 1){ register_collisions = 0; };
		PrintS(ConcatStrings("Register Collisions: ", IntToString(register_collisions)));
	};
	


	placementReturnState = MEM_KeyState (MOUSE_XBUTTON2);
	// http://lego.worldofplayers.de/?Ikarus_Dokumentation
	// If the Key "MOUSE_XBUTTON2" is pressed, spawn the construction
	if (placementReturnState == KEY_PRESSED) {
				
		// there is no construction spawned yet, spawn one
		doRayCast();

		// spawn the construction
		SpawnConstructionWithPosition(
			currentlySelectedBuildingName,
			currentPositionX, 
			currentPositionY, 
			currentPositionZ 
		);
	
		// allow position update 
		constructionBeingPlaced = 1;
		
		// disable the feature to modify the rotation or translation of the current construction
		disableRotationMode();
		disableTranslationMode();
				
	};
		

		
	// this is called when the construction has been placed
	// use this to do some finishing work, like activating colliders, etc. 
	if (placementReturnState == KEY_RELEASED) {
			
		// disallow position update 	
		constructionBeingPlaced = 0;
		
		// get a reference to the visual object via its pointer 
		var zCVob vob; vob = _^(currentConstructionPtr);

		// workaround: 
		// if we want to align the vob at the floor we've to add an artificial height to the original intersection, 
		// otherwise the vob will vanish in the void (gets aligned below the ground level)
		// currentPositionY = currentPositionY + 10000000;
			
		// update the position of the current construction based on the rayCast intersection
		zCVob_SetPositionWorld(
			currentConstructionPtr, 
			currentPositionX, 
			currentPositionY, 
			currentPositionZ
		);		
		
		// align the vob at the floor
		// SetVobToFloor(currentConstructionPtr);	
		
		// update the bitfields:
		// - enable collision | TODO: depends if the model actually should use collision (like plants?)
        vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_showVisual;
        vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
        vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;

		// notify user about which construction gets spawned
		PrintS(ConcatStrings("Spawning construction: ", currentlySelectedBuildingName));
		
		// notify the user: "i've built something!"
		Snd_Play("PickOre");
		
		// disable the feature to modify the rotation or translation of the current construction
		disableRotationMode();
		disableTranslationMode();
		
	};
	
	
	
	// if enter has been pressed, disable to modify the current construction
	if (MEM_KeyState (KEY_NUMPADENTER) == KEY_RELEASED) {

			PrintS("End editing...");
			constructionBeingPlaced = 0;
			currentConstructionPtr = 0;
			
			disableTranslationMode();
			disableRotationMode();
			
			Snd_Play("M_FALL_SMALL");
			
			updateModeView();

	};
		
		
	// Existing vob grabbing and repositioning

		
	// If the Key "V" is pressed ...
	if (MEM_KeyState (KEY_V) == KEY_RELEASED) {

		seeVobsEnabled = 1;
		
		doRayCast();
					
		if(currentlySeenVob == 0){ 
			PrintS("No vob in line of ray-cast found!");
			return; 
		}; 
		
		var zCVob currentlySeenVobButNotThePointer;
		currentlySeenVobButNotThePointer = _^(currentlySeenVob);
			
		if(currentlySeenVobButNotThePointer == 0){ return; };
		
		currentConstructionPtr = currentlySeenVob;
		
		PrintS(ConcatStrings("Updating current vob: ", IntToString(currentlySeenVob)));
		
		seeVobsEnabled = 0;
		
		Snd_Play("Hammer_A2");
		
	};	
	
};


//
// FrameFunction - gets called once per second, allows updating of the world
//
func void Architect_Late_Update(){
	
	// there is a construction spawned already - 
	// use the ray tracing to determine its new position
	if(constructionBeingPlaced != 0 && currentConstructionPtr != 0){
	
		// do another raycast => update the intersection components
		doRayCast();
						
		// update the position of the current construction based on the rayCast intersection
		zCVob_SetPositionWorld(
			currentConstructionPtr, 
			currentPositionX, 
			currentPositionY, 
			currentPositionZ
		);		
		
		// the vob wont recognize any collisions .. BUT THE OTHER VOBS WITHIN THE WORLD Q_Q
		if(register_collisions == 0){
			// get a reference to the visual object via its pointer 
			var zCVob vob; vob = _^(currentConstructionPtr);
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_ignoredByTraceRay;
		};
					
	};
};

// 
// Listener / Handler for mouse input.
// 
// This is provided by LeGo, see: 
// https://lego.worldofplayers.de/?Beispiele_Cursor
// 
func void MouseInputListener(var int state) {

	// dont do anything if the mod is not enabled
	if(Architect_Mod_Enabled == 0){ return; };
	
	if (!Hlp_IsValidNpc(hero)) { return;  };
    if (!mem_game.timestep) { return; };
	
	
    
	// https://forum.worldofplayers.de/forum/threads/1505251-Skriptpaket-LeGo-4/page22
	const int delay = 50;
    var int prevUpScroll;
    var int prevDownScroll;
    var int prevDownRightClick;
    var int timer; timer = Timer();

	//	we're using these blocks to disable multiple recieval of scroll events
    if (state == CUR_WheelUp) {
        if (prevUpScroll + delay < timer) {
            // continue executing the listener    
        } else {
            return; 
        };
        prevUpScroll = timer;
    };
	
	//	we're using these blocks to disable multiple recieval of scroll events
    if (state == CUR_WheelDown) {
        if (prevDownScroll + delay < timer) {
            // continue executing the listener    
        } else {
            return; 
        };
        prevDownScroll = timer;
    };
	
	//	we're using these blocks to disable multiple recieval of click events
    if (state == CUR_RightClick) {
        if (prevDownRightClick + delay < timer) {
            // continue executing the listener    
        } else {
            return; 
        };
        prevDownRightClick = timer;
    };
	
	// if the player is placing some kind of construction dont scroll through the buildings list
	if (constructionBeingPlaced > 0) {
		return;
	};
	
	// if the player scrolls up with its middle mouse wheel
    if(state == CUR_WheelUp) {
		
		if(inRotationMode() == 0 && inTranslationMode() == 0){ 
			if(currentlySelectedBuildingIndex < ARC_STRUCTURES_MAX - 1) {
		
				// update the building index (the selected construction of the player)
				currentlySelectedBuildingIndex = currentlySelectedBuildingIndex + 1;
				currentlySelectedBuildingName = ReadUIArray(currentConstructionCategoryIndex, currentlySelectedBuildingIndex);

				// update the text pane
				updateBuildInfo();
			
			};	
		};
		
    };
	
	// if the player scrolls down with its middle mouse wheel
    if(state == CUR_WheelDown) {
        	
		if(inRotationMode() == 0 && inTranslationMode() == 0){ 
			if(currentlySelectedBuildingIndex > 0) {
					
				// update the building index (the selected construction of the player)
				currentlySelectedBuildingIndex = currentlySelectedBuildingIndex - 1;
				currentlySelectedBuildingName = ReadUIArray(currentConstructionCategoryIndex, currentlySelectedBuildingIndex);
			
				// update the text pane
				updateBuildInfo();
				
			};
		};
		
    };
	
    if(state == CUR_LeftClick) {
	
	};
	
    if(state == CUR_RightClick) {
					
    };
	
    if(state == CUR_MidClick) { 
	
	};
		
};


// this function enables the sprint overlay, allowing the player to sprint without using a potion
// this is left from the tutorial but i like it =)
func string ToggleSprinting(var string param) {
    Mdl_ApplyOverlayMDS(hero, "HUMANS_SPRINT.MDS");
    return "Sprinting activated";
};




