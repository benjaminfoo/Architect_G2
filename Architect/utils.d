// 
// by benjamin foo
// 
// utils method of the architect modification
// 

// Code created by mud-freak aka szapp (https://github.com/szapp/GothicFreeAim/)
// See: https://github.com/szapp/GothicFreeAim/blob/master/_work/data/Scripts/Content/GFA/_intern/aimRay.d
func MEMINT_HelperClass getPlayerInstance() {
    if (!MEM_ReadInt(oCNpc__player)) {
        var oCNpc ret; ret = MEM_NullToInst();
        MEMINT_StackPushInst(ret);
        return;
    };
    _^(MEM_ReadInt(oCNpc__player));
};


// Code created by Lehona
// See: https://forum.worldofplayers.de/forum/threads/1408430-Skriptpaket-LeGo-3/page9?p=24747762&viewfull=1#post24747762
const int zCVob__Move_G2 = 6402784; //0x61B2E0
const int zCVob__Move_G1 = 6217184; //0x5EDDE0
func void Vob_Move(var int ptr, var int x, var int y, var int z) {
    CALL_FloatParam(x);
    CALL_FloatParam(y);
    CALL_FloatParam(z);
    CALL__thiscall(ptr, MEMINT_SwitchG1G2(zCVob__Move_G1, zCVob__Move_G2));
};

// https://forum.worldofplayers.de/forum/threads/1098392-Scriptfrage?highlight=zCVob__SetPositionWorld
func void zCVob_SetPositionWorld(var int zCVobPtr, var int fX, var int fY, var int fZ) {
    const int zCVob__SetPositionWorld = 6404976; //0x61BB70
    const int arr[3] = {0,0,0};
    arr[0] = fX;
    arr[1] = fY;
    arr[2] = fZ;
    CALL_PtrParam(MEM_GetIntAddress(arr[0]));
    CALL__thiscall(zCVobPtr, zCVob__SetPositionWorld);
};


// 
// Various helper methods
// 

// concat two strings - return as one
func string concat2(var string s1, var string s2){
	return ConcatStrings(s1,s2);
};

// concat two strings - return as one
func string concat2i(var string s1, var int s2){
	return ConcatStrings(s1, IntToString(s2));
};

// concat three strings - return as one
func string concat3(var string s1, var string s2, var string s3){
	return 
		ConcatStrings
		(
			ConcatStrings(s1, s2),
			s3
		);
};

// concat four strings - return as one
func string concat4(var string s1, var string s2, var string s3, var string s4){
	return 
		ConcatStrings
		(
			ConcatStrings(s1, s2),
			ConcatStrings(s3, s4)
		);
};

// concat five strings - return as one
func string concat5(var string s1, var string s2, var string s3, var string s4, var string s5){
	return ConcatStrings(concat4(s1, s2, s3, s4), s5);
};

// concat three integer
func string concat3i(var int i1, var int i2, var int i3){
	return concat3(
		ConcatStrings("1: ", IntToString(i1)),
		ConcatStrings(" | 2: ", IntToString(i2)),
		ConcatStrings(" | 3: ", IntToString(i3))
	);
};

// concat four strings - return as one
func string ConcatStrings4(var string s1, var string s2, var string s3, var string s4){
	return 
		ConcatStrings
		(
			ConcatStrings(s1, s2),
			ConcatStrings(s3, s4)
		);
};


