MODULE NBsHFiBKkSckXBAd46ZbEQw;
 
IMPORT Base, TexVox,  HalfSpace;

VAR vox: HalfSpace.halfvox; v: TexVox.TexVox;
PROCEDURE thisvox*():Base.Voxel;
BEGIN
	 NEW(v, "lady.png"); 
	 v.tscale:=0;
	 NEW(vox,v,Base.randPT(),Base.randPT());
	RETURN vox
END thisvox;
 END NBsHFiBKkSckXBAd46ZbEQw. 