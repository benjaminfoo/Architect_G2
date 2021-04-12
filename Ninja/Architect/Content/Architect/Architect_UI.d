//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
// Contains user interface related methods  //
//                                          //
////////////////////////////////////////////// 


// a view to render the current version
var string versionInfo;
var int versionInfoPtr;

// a view to render the current category
var string categoryInfo;
var int categoryInfoPtr;

// a view to render the current construction
var string buildInfo;
var int buildInfoPtr;


// updates the ui
func void updateBuildInfo(){
	
	// update the category view's contents
	// Format: Category (x/y) - <category>
	var string cs1; cs1 = ConcatStrings("Construction ", "(");
	var string cs2; cs2 = ConcatStrings(IntToString(currentConstructionCategoryIndex + 1), "/");
	var string cs3; cs3 = ConcatStrings(IntToString(CONSTRUCTION_CATEGORIES_MAX), ") - ");
	var string cs4; cs4 = currentConstructionCategoryName;
	
	var string csleft;  csleft  = ConcatStrings(cs1, cs2);
	var string csright; csright = ConcatStrings(cs3, cs4);
	categoryInfo = ConcatStrings(csleft, csright);

	// update the category ui view
	var zCViewText categoryView; 
	categoryView = get(categoryInfoPtr);
    categoryView.text = categoryInfo;

	// update the construction view's contents
	// Format: Construction (x/y) - <category>
	var string bs1; bs1 = ConcatStrings("Building ", "(");
	var string bs2; bs2 = ConcatStrings(IntToString(currentlySelectedBuildingIndex + 1), "/");
	var string bs3; bs3 = ConcatStrings(IntToString(ARC_STRUCTURES_MAX), ") - ");
	var string bs4; bs4 = currentlySelectedBuildingName;
	
	var string bsleft;  bsleft  = ConcatStrings(bs1, bs2);
	var string bsright; bsright = ConcatStrings(bs3, bs4);
	buildInfo = ConcatStrings(bsleft, bsright);

	// update the category ui view
	var zCViewText constructionView; 
	constructionView = get(buildInfoPtr);
    constructionView.text = buildInfo;

	// update the version ui view
	var zCViewText versionView; 
	versionView = get(versionInfoPtr);
    versionView.text = Architect_Version;
	
	// update the build mode ui view
	var zCViewText modeInfoView; 
	modeInfoView = get(modeInfoPtr);
    modeInfoView.text = modeInfo;
	
};

// initialize the user interface
func void initialize_ui(){

	versionInfo = "Version: <version>";
	categoryInfo = "Category: <category>";
	buildInfo = "Building: <building>";
	modeInfo = "Translation disabled | Rotation disabled";

	if(versionInfoPtr == 0){
		versionInfoPtr = Print_Ext(25, 35, versionInfo, PF_Font, RGBA(255, 255, 255 , 255), -1);
	};

	if(categoryInfoPtr == 0){
		categoryInfoPtr = Print_Ext(25, 235, categoryInfo, PF_Font, RGBA(255, 255, 255 , 255), -1);
	};
	
	if(buildInfoPtr == 0){
		buildInfoPtr = Print_Ext(25, 435, buildInfo, PF_Font, RGBA(255, 255, 255 , 255), -1);
	};
		
	if(modeInfoPtr == 0){
		modeInfoPtr = Print_Ext(25, 635, modeInfo, PF_Font, RGBA(255, 255, 255 , 255), -1);
	};
	
	updateBuildInfo();
	updateModeView();
	
};

// destroy the user interface
func void destroy_ui(){

	versionInfo  = "";
	categoryInfo = "";
	buildInfo    =  "";
	modeInfo     =  "";

	if(versionInfoPtr != 0){
		Print_DeleteText(versionInfoPtr);
		versionInfoPtr = 0;
	};
	
	if(categoryInfoPtr != 0){
		Print_DeleteText(categoryInfoPtr);
		categoryInfoPtr = 0;
	};
	
	if(buildInfoPtr != 0){
		Print_DeleteText(buildInfoPtr);
		buildInfoPtr = 0;
	};

	if(modeInfoPtr != 0){
		Print_DeleteText(modeInfoPtr);
		modeInfoPtr = 0;
	};
	
};
