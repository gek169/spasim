MODULE Nwstar;
IMPORT Base, TexVox;
VAR vox: TexVox.TexVox;
PROCEDURE thisvox*():Base.Voxel;
BEGIN
	IF vox=NIL THEN NEW(vox,'wstar.png')  END;
	vox.tscale:=1;
	vox.passable:=FALSE;
	RETURN vox
END thisvox;

END Nwstar. 