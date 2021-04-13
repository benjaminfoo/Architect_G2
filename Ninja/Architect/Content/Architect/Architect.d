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

// boolean flag do indicate usage of collisions while determine an objects position
var int register_collisions;


// the initialize function, (should) get(s) called in Startup.d
func void Architect_Init() {
	
	// initialize the dynamic array for the undo history
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
	
	// initialize player related settings like home position, etc.
	playerSettings_init();
	
    // destroy the ui if there are previous versions available
    destroy_ui();
    
    // initialize the user interface
	initialize_ui();
	
	// initialize user ability to modify vob trafo
    initialize_transformations();
           
    // register frame functions
    FF_ApplyGT(Architect_Input_Loop);
    FF_ApplyGT(Architect_Late_Update);
    
    // register mouse listener 
	// Event_Add(Cursor_Event, MouseInputListener);
	FF_ApplyGT(MouseInputListener);
	
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
		Snd_Play(NOTIFY_DELETE_CONSTRUCTION);
		
		PrintS(ConcatStrings("Total constructions: ", IntToString(MEM_ArraySize(undoArray))));
			
	};
	
};



func void DeleteRayCastedObject(){
		
		if(currentlySeenVob <= 0) { return; };
		
		PrintS(ConcatStrings("Deleting last vob: ", IntToString(currentlySeenVob)));
		
		MEM_DeleteVob(currentlySeenVob);
		
		currentConstructionPtr = 0;
		currentlySeenVob = 0;
		
		// notify the user "something gets scrambled, it must have been destroyed!"
		Snd_Play(NOTIFY_DELETE_CONSTRUCTION);
};

// 
// spawn a construction by providing a name and a position
// 
func void SpawnConstructionWithPosition(var string constructionName, var int posx, var int posy, var int posz) {
	
	// create an empty integer array which holds the current position of the player
	var int position[3];
	position[0] = posx;
	position[1] = posy;
	position[2] = posz;

	// the pointer to the current object / construction which gets spawned
	// update pointer reference of the last built construction
	currentConstructionPtr = InsertVobPos ("architect_customObject", constructionName, _@(position), 0);
	
	// get a reference to the visual object via its pointer 
	var zCVob vob; vob = _^(currentConstructionPtr);
			
	// adjust bitfields
	// - toggle collision
	// - only show the visual of the vob
	// - etc. -> see bitfields at the end of the file
	vob.bitfield[0] = zCVob_bitfield0_showVisual;
	
	// add the pointer of the vob to the construction history list
	MEM_ArrayInsert (undoArray, currentConstructionPtr);
	
	var string message; 
	message = cs4("Spawned construction: ", constructionName, " - Total construction: ", IntToString(MEM_ArraySize(undoArray)));
	PrintS (message);
};



// 
// spawn a construction by providing a name and a position
// NOTE: 
// - Mobnames are defined in  : Gothic_2_Workspace\_work\Data\Scripts\Content\Story\Text.d
// - Mob Functions are def. in: Gothic_2_Workspace\_work\Data\Scripts\Content\AI\AI_Intern\AI_Constants.d 
func void SpawnInteractiveConstructionWithPosition(var string constructionName, var int posx, var int posy, var int posz) {

	// create an empty integer array which holds the current position of the player
	var int position[3];
	position[0] = posx;
	position[1] = posy;
	position[2] = posz;
	
	if
	(
		STR_Contains(constructionName, "BED")
	)
	{
		
		// the pointer to the current object / construction which gets spawned
		// update pointer reference of the last built construction
		currentConstructionPtr = InsertMobDoorPos ("MOBNAME_BED", constructionName, _@(position), 0);

		// func void SetMobMisc(int mobPtr, string triggerTarget, string useWithItem, string onStateFuncName)
		SetMobMisc(currentConstructionPtr, "", "", "SLEEPABIT");
			
		// Set focus name			
		SetMobName(currentConstructionPtr, "MOBNAME_BED");
	} 
	
	else if
	(
		STR_Contains(constructionName, "INNOS")
	)
	{
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_INNOS", constructionName, _@(position), 0);
		SetMobMisc(currentConstructionPtr, "", "", "PRAYSHRINE");
		SetMobName(currentConstructionPtr, "MOBNAME_INNOS");
	} 
	
	else if
	(
		STR_Contains(constructionName, "LAB") 
	)
	{
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_LAB", constructionName, _@(position), 0);
		SetMobMisc(currentConstructionPtr, "", "", "POTIONALCHEMY");
		SetMobName(currentConstructionPtr, "MOBNAME_LAB");
	} 
	
	else if
	(
		STR_Contains3(constructionName, "CHAIR", "THRONE", "BENCH")
	)
	{
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_BENCH", constructionName, _@(position), 0);
		SetMobName(currentConstructionPtr, "MOBNAME_BENCH");
	}
	
	else if
	(
		STR_Contains2(constructionName, "BAUMSAEGE", "LADDER")
	)
	{
		// TODO: this will lead to an empty name: MOBNAME_BENCH = ""
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_BENCH", constructionName, _@(position), 0);
		SetMobName(currentConstructionPtr, "MOBNAME_BENCH");
	}

	else if
	(
		STR_Contains(constructionName, "DOOR")
	)
	{
		
		currentConstructionPtr = InsertMobDoorPos ("MOBNAME_DOOR", constructionName, _@(position), 0);
		SetMobName(currentConstructionPtr, "MOBNAME_DOOR");

	} 
	
	else if
	(	
		STR_Contains(constructionName, "CAULDRON")
	)
	{
		
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_CAULDRON", constructionName, _@(position), 0);
		SetMobName(currentConstructionPtr, "MOBNAME_CAULDRON");

	} 
	
	else if
	(
		STR_Contains(constructionName, "STOVE")
	)
	{
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_STOVE", constructionName, _@(position), 0);
		SetMobName(currentConstructionPtr, "MOBNAME_STOVE");
		SetMobMisc(currentConstructionPtr, "", "ITFOMUTTONRAW", "");
	}

	else if
	(
		STR_Contains(constructionName, "RMAKER_1")
	)
	{
		currentConstructionPtr = InsertMobInterPos ("MOBNAME_RUNEMAKER", constructionName, _@(position), 0);
		SetMobName(currentConstructionPtr, "MOBNAME_RUNEMAKER");
		SetMobMisc(currentConstructionPtr, "", "ITMI_RUNEBLANK", "MAKERUNE");
	};

	
	if(currentConstructionPtr == 0){
		const string errMsg = "Error while spawning: Invalid SpawnInteractiveConstructionWithPosition call!";
		PrintS(errMsg);
		return;
	};

	
	// get a reference to the visual object via its pointer 
	var zCVob vob; vob = _^(currentConstructionPtr);
			
	// adjust bitfields
	// - toggle collision
	// - only show the visual of the vob
	// - etc. -> see bitfields at the end of the file
	vob.bitfield[0] = zCVob_bitfield0_showVisual;
	
	// add the pointer of the vob to the construction history list
	MEM_ArrayInsert (undoArray, currentConstructionPtr);
	
	var string message; 
	message = cs4("Spawned construction: ", constructionName, " - Total construction: ", IntToString(MEM_ArraySize(undoArray)));
	PrintS (message);
};



// 
// spawn a construction by providing a name
// 
func void SpawnConstruction(var string constructionName) {

    // get position of the player
    var zCVob her; her = Hlp_GetNpc(hero);
    
	// create an empty integer array which holds the current position of the player
	var int playerPosition[3];

	// return the x,y,z coordinates of the player from the vob's transformation matrix
    playerPosition[0] = her.trafoObjToWorld[3];
    playerPosition[1] = her.trafoObjToWorld[7];
    playerPosition[2] = her.trafoObjToWorld[11];
			
	// ...
	SpawnConstructionWithPosition(constructionName, playerPosition[0], playerPosition[1], playerPosition[2]);
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
		// if the mod is disabled and gets enabled ...
		if(Architect_Mod_Enabled == 0 ){ 
			
			// initialize the user interface
			initialize_ui();
			
			// re-register frame functions
			FF_ApplyGT(Architect_Input_Loop);
			FF_ApplyGT(Architect_Late_Update);
			FF_ApplyGT(MouseInputListener);
			
			Architect_Mod_Enabled = 1;
			
			PrintS("Architect mod enabled!");

		}
		else if(Architect_Mod_Enabled == 1 ){
		
			// complete destroy the user interface
			destroy_ui();
			
			// de-register frame functions
			FF_Remove(Architect_Input_Loop);
			FF_Remove(Architect_Late_Update);
			FF_Remove(MouseInputListener);
		
			Architect_Mod_Enabled = 0;
			
			PrintS("Architect mod disabled!");
			
		};
		
	};
	
	
	
	// dont do anything if the mod is not enabled
	if(Architect_Mod_Enabled == 0){ return; };
	
	// These options are only valid if the mod is active
	
	// If the Key "F10" is pressed ...
	// TODO: just for debugging - remove in near future
	if (MEM_KeyState (KEY_F10) == KEY_RELEASED) {
		ExitGame();
	};	
	
	

	// delete the last created construction
	if (MEM_KeyState (MOUSE_XBUTTON1) == KEY_RELEASED) {
		
		if(currentlySeenVob > 0){
			DeleteRayCastedObject();
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


	
	// toggle the collision bits of the current construction
	if ( MEM_KeyState (KEY_NUMPAD5) == KEY_RELEASED) {
	
		if(currentConstructionPtr == 0) { return; };
	
		var zCVob vob; vob = _^(currentConstructionPtr);
			
		if (register_collisions == 1){ 
			register_collisions = 0; 
			PrintS(ConcatStrings("Switched collision of vob to: ", "disabled"));
		}
		else if (register_collisions == 0){ 
			register_collisions = 1; 
			PrintS(ConcatStrings("Switched collision of vob to: ", "enabled"));
		};
		
		toggleCollisions(vob, register_collisions);
					
		Snd_Play(TOGGLE_COLLISION_BLIP);
		
	};
	


	placementReturnState = MEM_KeyState (MOUSE_XBUTTON2);
	// http://lego.worldofplayers.de/?Ikarus_Dokumentation
	// If the Key "MOUSE_XBUTTON2" is pressed, spawn the construction
	if (placementReturnState == KEY_PRESSED) {
				
		// all constructions have a activated collision per default		
		register_collisions = 1; 
				
		// there is no construction spawned yet, spawn one
		doRayCast();
		
				
		// update for interactive vobs
		if(STR_Contains(currentlySelectedBuildingName, ".ASC")){

			// spawn the interactive construction
			SpawnInteractiveConstructionWithPosition(
				currentlySelectedBuildingName,
				currentPositionX, 
				currentPositionY, 
				currentPositionZ 
			);
			
		} else { // this is a regular vob without any interactive elements

			// spawn the construction
			SpawnConstructionWithPosition(
				currentlySelectedBuildingName,
				currentPositionX, 
				currentPositionY, 
				currentPositionZ 
			);
		
		};
	
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
		Snd_Play(NOTIFY_CONSTRUCTION_BUILT);
		
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
			
			Snd_Play(NOTIFY_DISABLE_EDITING);
			
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
		
		Snd_Play(NOTIFY_VOB_GRAB);
		
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
func void MouseInputListenerCustom(var int state) {

	// dont do anything if the mod is not enabled
	if(Architect_Mod_Enabled == 0){ return; };
	    
	// https://forum.worldofplayers.de/forum/threads/1505251-Skriptpaket-LeGo-4/page22
	const int delay = 50;
    var int prevUpScroll;
    var int prevDownScroll;
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
		
};

// 
// A custom input listener which fetches the state of the mouse wheel and delegates the informations
// to another custom method =).
// Note: Gets called when wheel up or down is used.
//
func void MouseInputListener() {

    var _Cursor c; c = _^(Cursor_Ptr);
    Cursor_Wheel = c.wheel;
	
	if(Cursor_Wheel != 0) {
	
		if(Cursor_Wheel > 0) {
			MouseInputListenerCustom(CUR_WheelUp);
		}
		else {
			MouseInputListenerCustom(CUR_WheelDown);
		};
		
	};
	
};










