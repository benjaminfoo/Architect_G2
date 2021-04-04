////////////////////////////////////////////////
//                                            //
// Architect Mod                              //
// By benjamin foo                            //
//                                            //
// Provides functions to retrieve categories  //
// and other data for runtime usage.          //
//                                            //
//////////////////////////////////////////////// 

// the maximum amount of buildable structures - is there a way of determine the length of an array?
var int ARC_STRUCTURES_MAX;

// the current index of the player selected category of constructions (like nature, addon, etc.)
var int currentConstructionCategoryIndex;

// the display name of the selected category of constructions
var string currentConstructionCategoryName; 

// the construction categories 
const int CONSTRUCTION_CATEGORY_MOBS_ADDONS = 0;
const int CONSTRUCTION_CATEGORY_MOBS_HOUSEHOLD = 1;
const int CONSTRUCTION_CATEGORY_MOBS_MISC = 2;
const int CONSTRUCTION_CATEGORY_MOBS_NATURE = 3;
const int CONSTRUCTION_CATEGORY_MOBS_NEWWORLD= 4;
const int CONSTRUCTION_CATEGORY_MOBS_OLDWORLD= 5;
const int CONSTRUCTION_CATEGORY_MOBS_PLANKS = 6;
const int CONSTRUCTION_CATEGORY_MOBS_STONES = 7;
const int CONSTRUCTION_CATEGORY_CUSTOM_CONSTRUCTION = 8;
const int CONSTRUCTION_CATEGORIES_MAX = 9;

// reads an entry from an given array by an index
// this function is used for reading entries from category array, for example: 
// "Addon" -> "Stone_Small.3ds", etc.
func string ReadUIArray(var int which_array, var int index) {

    if which_array == CONSTRUCTION_CATEGORY_MOBS_ADDONS {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_MOBS_ADDONS_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_MOBS_ADDONS_NAME;
        return MEM_ReadStatStringArr(CONSTRUCTION_SET_MOBS_ADDONS, currentlySelectedBuildingIndex);
    } 

	else if which_array == CONSTRUCTION_CATEGORY_MOBS_HOUSEHOLD {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_MOBS_HOUSEHOLD_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_MOBS_HOUSEHOLD_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_MOBS_HOUSEHOLD, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_MOBS_MISC {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_MOBS_MISC_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_MOBS_MISC_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_MOBS_MISC, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_MOBS_NATURE {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_NATURE_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_NATURE_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_NATURE, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_MOBS_NEWWORLD {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_NEW_WORLD_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_NEW_WORLD_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_NEW_WORLD, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_MOBS_OLDWORLD {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_OLD_WORLD_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_OLD_WORLD_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_OLD_WORLD, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_MOBS_PLANKS {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_PLANKS_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_PLANKS_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_PLANKS, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_MOBS_STONES {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_STONES_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_STONES_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_STONES, currentlySelectedBuildingIndex);
    }
	
	else if which_array == CONSTRUCTION_CATEGORY_CUSTOM_CONSTRUCTION {
		ARC_STRUCTURES_MAX = CONSTRUCTION_SET_CUSTOM_CONSTRUCTION_MAX;
		currentConstructionCategoryName = CONSTRUCTION_SET_CUSTOM_CONSTRUCTION_NAME;
		return MEM_ReadStatStringArr(CONSTRUCTION_SET_CUSTOM_CONSTRUCTION, currentlySelectedBuildingIndex);
    };
	
	return "You shouldn't have reached this string ...";
};




