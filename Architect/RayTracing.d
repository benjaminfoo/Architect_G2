////////////////////////////////////////////////////////
//                                                    //
// Architect Mod                                      //
// By benjamin foo                                    //
//                                                    //
// Code created by mud-freak aka szapp                //
// https://github.com/szapp/                          //
//                                                    //
//                                                    //
////////////////////////////////////////////////////////
//
// 
// Code created by mud-freak aka szapp (https://github.com/szapp/GothicFreeAim/)
// See: https://github.com/szapp/GothicFreeAim/blob/master/_work/data/Scripts/Content/GFA/_intern/aimRay.d
// 

// boolean flag do indicate usage of collisions while determine an objects position
var int register_collisions;

// the reference to the last seen vob (used in combination with raytracing
// this is not updated when creating or deleting a construction)
var int currentlySeenVob;
var int seeVobsEnabled;

// shoots a ray with a given distance, determines the vector of intersection and writes the result 
// to Transformations.d -> currentPositionX, currentPositionY, currentPositionZ
func void doRayCast(){

	// parameter 1
	var int distance; distance = 10000;

	// The trace ray is cast along the camera viewing angle from a start point towards a direction/length vector
	// PrintS("Do Ray Trace ...");

	// Get camera vob and player
	var zCVob camVob; camVob = _^(MEM_Game._zCSession_camVob);
	var zMAT4 camPos; camPos = _^(_@(camVob.trafoObjToWorld[0]));
	var oCNpc her; her = getPlayerInstance();
	var int herPtr; herPtr = _@(her);

	// Shift the start point for the trace ray beyond the player model. This is necessary, because if zooming out
	//  (a) there might be something between camera and hero (unlikely) and
	//  (b) the maximum aiming distance is off and does not correspond to the parameter 'distance'
	// To do so, the distance between camera and player is computed:
	var int distCamToPlayer; distCamToPlayer = sqrtf(addf(addf( // Does not care about camera X shift, see below
		sqrf(subf(her._zCVob_trafoObjToWorld[ 3], camPos.v0[zMAT4_position])),
		sqrf(subf(her._zCVob_trafoObjToWorld[ 7], camPos.v1[zMAT4_position]))),
		sqrf(subf(her._zCVob_trafoObjToWorld[11], camPos.v2[zMAT4_position]))));

	// The distance is used to create the direction vector in which to cast the trace ray
	distance = mkf(distance);

	// This array holds the start vector (world coordinates) and the direction vector (local coordinates)
	var int traceRayVec[6];
	traceRayVec[0] = addf(camPos.v0[zMAT4_position], mulf(camPos.v0[zMAT4_outVec], distCamToPlayer));
	traceRayVec[1] = addf(camPos.v1[zMAT4_position], mulf(camPos.v1[zMAT4_outVec], distCamToPlayer));
	traceRayVec[2] = addf(camPos.v2[zMAT4_position], mulf(camPos.v2[zMAT4_outVec], distCamToPlayer));
	traceRayVec[3] = mulf(camPos.v0[zMAT4_outVec], distance); // Direction-/to-vector of ray
	traceRayVec[4] = mulf(camPos.v1[zMAT4_outVec], distance);
	traceRayVec[5] = mulf(camPos.v2[zMAT4_outVec], distance);

	// The trace ray uses certain flags. These are very important the way they are and have been carefully chosen
	// and tested. Although the descriptions might be misleading, they should not be changed under any circumstances
	// especially the flag to ignore alpha polygons is counter intuitive, since that means that gates and fences
	// will be ignored although they have collision. However, this flag is buggy. It NEEDS to be present otherwise
	// artifacts will arise, like pseudo-random ignoring of walls and objects.
	var int flags;

	if(register_collisions == 0){
		flags = 0;
	};

	if(register_collisions == 1){
		flags =   zTRACERAY_vob_ignore_no_cd_dyn
				 | zTraceRay_poly_normal
				 | zTRACERAY_poly_ignore_transp // Do not change (will make trace ray unstable)
				 | zTRACERAY_poly_test_water
				 | zTRACERAY_vob_ignore_projectiles;
	};
						 
	var int fromPosPtr; fromPosPtr = _@(traceRayVec);
	var int dirPosPtr; dirPosPtr = _@(traceRayVec)+sizeof_zVEC3;
	var int worldPtr; worldPtr = _@(MEM_World);
	
	const int call = 0;
	if (CALL_Begin(call)) {
		CALL_IntParam(_@(flags));     // Trace ray flags
		CALL_PtrParam(_@(herPtr));    // Ignore player model
		CALL_PtrParam(_@(dirPosPtr)); // Trace ray direction
		CALL_PutRetValTo(_@(hit));    // Did the trace ray hit
		CALL__fastcall(_@(worldPtr), _@(fromPosPtr), zCWorld__TraceRayNearestHit_Vob);
		call = CALL_End();
	};
	
	// Retrieve trace ray report
	var int foundVob; foundVob = MEM_World.foundVob;
	
	if(seeVobsEnabled==1){
		currentlySeenVob = foundVob;
	};
	
	var int intersection[3];
	MEM_CopyBytes(_@(MEM_World.foundIntersection), _@(intersection), sizeof_zVEC3);
	
	// update the current position from raytrace to global variables
	currentPositionX = intersection[0];
	currentPositionY = intersection[1];
	currentPositionZ = intersection[2];
		
	// needed for allocation
	var int hit;

	// PrintS("... done ray tracing!");

};

