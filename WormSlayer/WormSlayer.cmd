ATTRIB -R -A -S -H AUTORUN.INF *.LNK
ERASE /F /Q AUTORUN.INF *.LNK
RMDIR /S /Q RECYCLER
MKDIR \\?\%~D0\Autorun.inf\WormSlayer..\
ATTRIB +R -A +S +H %~D0\Autorun.inf
