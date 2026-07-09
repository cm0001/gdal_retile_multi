@echo off 
call "%OSGEO4W_ROOT%\bin\o4w_env.bat" 
python "%OSGEO4W_ROOT%\bin\gdal_retile_multi.py" %* 
