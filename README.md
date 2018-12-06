# gdal_retile_multi
Expanding on the great work of Christian Mueller (also Chris Giesey & Elijah Robison) called gdal_retile.py.<br><br>
This code modification to **'gdal_retile'** allows multiple, separate **'gdal_retile_multi'** processes to work concurrently in tiling a georeferenced raster dataset (or set of raster tiles) for publishing as an ImagePyramid. Using separate 'gdal_retile_multi' files assures the use of all available processors on pc's/servers having multi-core cpus.
<br><br>
The goal is to **_reduce the time required to ImagePyramid large raster datasets_** by allowing multiple processes to **_'divide-and-conquer'_** the task.
<br><br>
**_'gdal_retile_multi'_** is also **_interruptible_** and **_resumable_**. It can be used to **_run on a single pc/server or distributed across as many machines as you like_**.
<br><br>
Here is a visual of the idea. **See the  [WIKI](https://github.com/cm0001/gdal_retile_multi/wiki)** for a few more details.<br>
![gdal_retile_multi_n_n](https://github.com/cm0001/gdal_retile_multi/blob/master/blob/master/img/gdal_retile_multi_n_n.png)
