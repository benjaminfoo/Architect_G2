//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
////////////////////////////////////////////// 

var int homePosX;
var int homePosY;
var int homePosZ;

func void playerSettings_init(){
	CC_Register(SetHome, "Set_Home ", "Sets the current position as the players home.");
    CC_Register(GetHome, "Get_Home ", "Returns to the position which has been set as Home (call Set_Home first)");
};

// 
// spawn a construction by providing a name
// 
func string SetHome(var string param) {

    // get position of the player
    var zCVob her; her = Hlp_GetNpc(hero);
    
	// return the x,y,z coordinates of the player from the vob's transformation matrix
    homePosX = her.trafoObjToWorld[3];
    homePosY = her.trafoObjToWorld[7];
    homePosZ = her.trafoObjToWorld[11];
			
	// ...
	var string s1; s1 = cs2i("X: ", homePosX);
	var string s2; s2 = cs2i("Y: ", homePosY);
	var string s3; s3 = cs2i("Z: ", homePosZ);
	
	var string result; result = cs4("Set home-position at: ", cs2(s1, ", "), cs2(s2, ", "), cs2(s3, " ..."));
	
	return result;
};

// 
// spawn a construction by providing a name
// 
func string GetHome(var string param) {

	if(homePosX == 0 || homePosY == 0 || homePosZ == 0){
		return "Kein Heimat-Punkt definiert! Rufe zuvor Set_Home auf!";
	};

    // get position of the player
    var zCVob her; her = Hlp_GetNpc(hero);
    
	// create an empty integer array which holds the current position of the player
	var int playerPosition[3];

	// return the x,y,z coordinates of the player from the vob's transformation matrix
    her.trafoObjToWorld[3]   = homePosX;
    her.trafoObjToWorld[7]   = homePosY;
    her.trafoObjToWorld[11]  = homePosZ;
	
	// ...
	var string s1; s1 = cs2i("X: ", homePosX);
	var string s2; s2 = cs2i("Y: ", homePosY);
	var string s3; s3 = cs2i("Z: ", homePosZ);
	
	var string result; result = cs4("Return to home-position at: ", cs2(s1, ", "), cs2(s2, ", "), cs2(s3, " ..."));
			
	return result;
};