clipper %1
if not errorlevel 1 rtlink FILE %1.OBJ OUTPUT %1.exe LIBRARY CLIPPER, EXTEND, CLD, TERMINAL, DBFNTX;

