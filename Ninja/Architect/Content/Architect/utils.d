//////////////////////////////////////////////
//                                          //
// Architect Mod                            //
// By benjamin foo                          //
//                                          //
// Utility methods of the modification.     //
//                                          //
////////////////////////////////////////////// 

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
// Got them from: https://app.assembla.com/spaces/LM/subversion-2/source/HEAD/Basic_Scripts/Misc.d
// 

func string i2s(var int i) {

    return IntToString(i);

};

func string cs2 (var string s1, var string s2) {

    return ConcatStrings (s1, s2);

};


func string cs2i (var string s1, var int i1) {

    return ConcatStrings (s1, i2s(i1));

};

func string cs3 (var string s1, var string s2, var string s3) {

    return cs2 (cs2 (s1, s2), s3);

};

func string cs4 (var string s1, var string s2, var string s3, var string s4) {

    return cs2 (cs3 (s1, s2, s3), s4);

};

func string cs5 (var string s1, var string s2, var string s3, var string s4, var string s5) {

    return cs2 (cs4 (s1, s2, s3, s4), s5);

};

func string cs6 (var string s1, var string s2, var string s3, var string s4, var string s5, var string s6) {

    return cs2 (cs5 (s1, s2, s3, s4, s5), s6);

};

func string cs7 (var string s1, var string s2, var string s3, var string s4, var string s5, var string s6, var string s7) {

    return cs2 (cs6 (s1, s2, s3, s4, s5, s6), s7);

};

func string cs8 (var string s1, var string s2, var string s3, var string s4, var string s5, var string s6, var string s7, var string s8) {

    return cs2 (cs7 (s1, s2, s3, s4, s5, s6, s7), s8);

};

func string cs9 (var string s1, var string s2, var string s3, var string s4, var string s5, var string s6, var string s7, var string s8, var string s9) {

    return cs2 (cs8 (s1, s2, s3, s4, s5, s6, s7, s8), s9);

};

func int max(var int i, var int j) {

    if (i > j) {

        return i;

    };

    return j;

};

func int max3(var int i1, var int i2, var int i3) {

    return max(max(i1, i2), i3);

};

func int max4(var int i1, var int i2, var int i3, var int i4) {

    return max(max3(i1, i2, i3), i4);

};

func int max5(var int i1, var int i2, var int i3, var int i4, var int i5) {

    return max(max4(i1, i2, i3, i4), i5);

};

func int max6(var int i1, var int i2, var int i3, var int i4, var int i5, var int i6) {

    return max(max5(i1, i2, i3, i4, i5), i6);

};


