MODULE NmOgKSH5ZXYP3DODELOkO7g;
IMPORT Base, TexVox;
VAR vox: TexVox.TexVox;
PROCEDURE thisvox*():Base.Voxel;
BEGIN
	IF vox=NIL THEN NEW(vox,'archaeopteryx.png');
	vox.tscale:=0;
 	END;
	RETURN vox
END thisvox;

 END NmOgKSH5ZXYP3DODELOkO7g. 
