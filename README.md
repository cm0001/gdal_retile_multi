# gdal_retile_multi
Expanding on the great work of Christian Mueller (also Chris Giesey & Elijah Robison) called gdal_retile.py.<br><br>
This code modification to **'gdal_retile'** allows multiple **'gdal_retile_multi'** processes to work concurrently in tiling one raster dataset 
for publishing as a Geoserver Image Pyramid layer.
<br><br>
The goal is to reduce the time required to tile large raster datasets by allowing multiple processes to 'divide-and-conquer' the task.
<br><br>
This process is also interruptible and resumable.
<br><br>
Here is a visual of the idea. See the WIKI for a few more details.<br>
![gdal_retile_multi_n_n](https://github.com/cm0001/gdal_retile_multi/blob/master/blob/master/img/gdal_retile_multi_n_n.png)
