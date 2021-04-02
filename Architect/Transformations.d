//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
// Contains all variables which are used    //
// to determine an vobs position, scale or  //
// rotation.                                //
//                                          //
////////////////////////////////////////////// 

// the last raytraced positions after calling doRayCast()
var int currentPositionX;
var int currentPositionY;
var int currentPositionZ;

var int xTranslateEnabled;
var int yTranslateEnabled;
var int zTranslateEnabled;

var int xRotateEnabled;
var int yRotateEnabled;
var int zRotateEnabled;

var int translateKey;
var int translateKeyState;

var int rotateKey;
var int rotateKeyState;

var int currentPositionXOffset;
var int currentPositionZOffset;

var int positionDelta;
var int positionDeltaMin;
var int positionDeltaMax;
var int positionDeltaStep;

// a view to render the translation states
var string modeInfo;
var int modeInfoPtr;

// if > 0, enabled, else, disabled
func int inTranslationMode(){
	return xTranslateEnabled + yTranslateEnabled + zTranslateEnabled; 
};

// if > 0, enabled, else, disabled
func int inRotationMode(){
	return xRotateEnabled + yRotateEnabled + zRotateEnabled;
};

func void disableTranslationMode(){
	xTranslateEnabled = 0;
	yTranslateEnabled = 0;
	zTranslateEnabled = 0;
};

func void disableRotationMode(){
	xRotateEnabled = 0;
	yRotateEnabled = 0;
	zRotateEnabled = 0;
};

func void updateModeView(){

	if(inTranslationMode() == 0){
		modeInfo = "Translation: disabled | ";
	};
	
	if(inTranslationMode() == 1){
		modeInfo = "Translation: enabled | ";
	};
	
	if(inRotationMode() == 0){
		modeInfo = ConcatStrings(modeInfo, "Rotation: disabled");
	};
	
	if(inRotationMode() == 1){
		modeInfo = ConcatStrings(modeInfo, "Rotation: enabled");
	};
	
	// update the build mode ui view
	var zCViewText modeInfoView; 
	modeInfoView = get(modeInfoPtr);
    modeInfoView.text = modeInfo;
	
};

func void updateDelta(var int positiveOrNegative){

	if(positiveOrNegative > 0){
		if(positionDelta + positionDeltaStep < positionDeltaMax){
			positionDelta = positionDelta + positionDeltaStep;
		};
	};
	
	if(positiveOrNegative < 0){
		if(positionDelta - positionDeltaStep > 0){
			positionDelta = positionDelta + positionDeltaStep;
		};
		if(positionDelta - positionDeltaStep == 0){
			positionDelta = positionDeltaMin;
		};
	};

	PrintS(ConcatStrings("Translation / Rotation Delta: ", IntToString(positionDelta)));
};

// initialize the users ability to modify positions of vobs
func void initialize_transformations(){

	translateKey = KEY_T;
	rotateKey     = KEY_R;
	
	positionDelta     = 1;
	positionDeltaStep     = 1;
	positionDeltaMin = 1;
	positionDeltaMax = 10;
	
	disableRotationMode();
	disableTranslationMode();

	FF_ApplyGT(Transformation_Loop);

	// register mouse listener 
	Event_AddOnce(Cursor_Event, MouseInputForTransformationListener);
};

func void Transformation_Loop (){

	// dont do anything if the mod is not enabled
	if(Architect_Mod_Enabled == 0){ return; };
	
	if (!Hlp_IsValidNpc(hero)) { return;  };
    if (!mem_game.timestep) { return; };
	
	if(currentConstructionPtr == 0){ return; };
	
	translateKeyState = MEM_KeyState (translateKey); // KEY_T
	if (translateKeyState == KEY_RELEASED) {
		if(yTranslateEnabled == 0){
			yTranslateEnabled = 1;
			PrintS(ConcatStrings("Translation is ", "enabled"));
		} else if(yTranslateEnabled == 1){
			yTranslateEnabled = 0;
			PrintS(ConcatStrings("Translation is ", "disabled"));
		};
		
		updateModeView();
		Snd_Play("M_FALL_SMALL");
	};
	
		
	rotateKeyState = MEM_KeyState (rotateKey); // KEY_R
	if (rotateKeyState == KEY_RELEASED) {
		if(yRotateEnabled == 0){
			yRotateEnabled = 1;
			PrintS(ConcatStrings("Rotation is ", "enabled"));
		} else if(yRotateEnabled == 1){
			yRotateEnabled = 0;
			PrintS(ConcatStrings("Rotation is ", "disabled"));
		};

		updateModeView();
		Snd_Play("M_FALL_SMALL");
	};

	// get a reference to the visual object via its pointer 
	var zCVob vob; vob = _^(currentConstructionPtr);
	
	// Translation-Mode: move to left (translate negative delta on x axis)
	// Rotation-Mode: rotate to the left (rotate negative delta around upper y axis)
	if (MEM_KeyState (KEY_NUMPAD4) == KEY_HOLD) {
	
		if(yTranslateEnabled){

			TRF_Move(vob, 0, mkf(0), mkf(positionDelta));
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
			
		if(yRotateEnabled){
			
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionStatic;

			TRF_RotateY(vob, mkf(-positionDelta));

			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;
        
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
	};
	
	// Translation-Mode: move to right (translate negative delta on x axis)
	// Rotation-Mode: rotate to the right (rotate negative delta around upper y axis)
	if (MEM_KeyState (KEY_NUMPAD6) == KEY_HOLD) {
	
		if(yTranslateEnabled){
			
			// get a reference to the visual object via its pointer 
			vob = _^(currentConstructionPtr);

			TRF_Move(vob, 0, mkf(0), mkf(-positionDelta));
			
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
		if(yRotateEnabled){
			
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionStatic;

			TRF_RotateY(vob, mkf(positionDelta));

			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;
        
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
	};
	
	// Translation-Mode: move upwards (translate negative delta on x axis)
	// Rotation-Mode: rotate to the left (rotate negative delta around upper y axis)
	if (MEM_KeyState (KEY_NUMPAD2) == KEY_HOLD) {
	
		if(yTranslateEnabled){
			
			// get a reference to the visual object via its pointer 
			vob = _^(currentConstructionPtr);

			TRF_Move(vob, mkf(0), mkf(-positionDelta), mkf(0));
			
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
	};
	
	// Translation-Mode: move downwards (translate negative delta on x axis)
	// Rotation-Mode: rotate to the right (rotate negative delta around upper y axis)
	if (MEM_KeyState (KEY_NUMPAD8) == KEY_HOLD) {
	
		if(yTranslateEnabled){
			
			// get a reference to the visual object via its pointer 
			vob = _^(currentConstructionPtr);

			TRF_Move(vob, mkf(0), mkf(positionDelta), mkf(0));
			
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
	};
	
		
	// Translation-Mode: move upwards (translate negative delta on x axis)
	// Rotation-Mode: rotate to the left (rotate negative delta around upper y axis)
	if (MEM_KeyState (KEY_NUMPAD7) == KEY_HOLD) {
	
		if(yTranslateEnabled){
			
			// get a reference to the visual object via its pointer 
			vob = _^(currentConstructionPtr);

			TRF_Move(vob, mkf(positionDelta), 0, 0);
			
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
		if(yRotateEnabled){
			
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionStatic;

			TRF_RotateX(vob, mkf(-positionDelta));

			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;
        
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
	};
	
	// Translation-Mode: move downwards (translate negative delta on x axis)
	// Rotation-Mode: rotate to the right (rotate negative delta around upper y axis)
	if (MEM_KeyState (KEY_NUMPAD9) == KEY_HOLD) {
	
		if(yTranslateEnabled){
			
			// get a reference to the visual object via its pointer 
			vob = _^(currentConstructionPtr);

			TRF_Move(vob, mkf(-positionDelta), 0, 0);
			
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
				
		if(yRotateEnabled){
			
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionStatic;

			TRF_RotateX(vob, mkf(positionDelta));

			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;
        
			VobPositionUpdated(currentConstructionPtr);
			
		};
		
	};
	
	if (MEM_KeyState (KEY_NUMPAD0) == KEY_HOLD) {
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionStatic;

			TRF_Rotate(vob, 0, 0, 0);

			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;
        
			VobPositionUpdated(currentConstructionPtr);
			
			PrintS("Rotation has been resetted");
	};
	
	
	if (MEM_KeyState (KEY_ADD) == KEY_RELEASED) {
		updateDelta(1);
	};
	
	if (MEM_KeyState (KEY_SUBTRACT) == KEY_RELEASED) {
		updateDelta(-1);
	};
	
	if (MEM_KeyState (KEY_DIVIDE) == KEY_RELEASED) {
		if(currentConstructionPtr > 0){
			
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] & ~  zCVob_bitfield0_collDetectionStatic;

			TRF_SetRot(vob, mkf(90), 0,0);

			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionDynamic;
			vob.bitfield[0] = vob.bitfield[0] |  zCVob_bitfield0_collDetectionStatic;
        
			VobPositionUpdated(currentConstructionPtr);
			
		};
	};
	
};

func void MouseInputForTransformationListener(var int state) {

	// dont do anything if the mod is not enabled
	if(Architect_Mod_Enabled == 0){ return; };
    
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
	
    if(state == CUR_LeftClick) {
	
	};
	
    if(state == CUR_RightClick) {
					
    };
	
    if(state == CUR_MidClick) { 
	
	};
		
};
