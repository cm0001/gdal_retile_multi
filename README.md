# gdal_retile_multi
Expanding on the great work of Christian Mueller (also Chris Giesey & Elijah Robison) called gdal_retile.py.<br><br>
This code modification to **gdal_retile** allows multiple, separate **gdal_retile_multi** processes to work concurrently in tiling a georeferenced raster dataset (or set of raster tiles) for publishing as an ImagePyramid. Using separate **gdal_retile_multi** files assures the use of all available processors on pc's/servers having multi-core cpus.
<br><br>
The goal is to **_reduce the time required to ImagePyramid large raster datasets_** by allowing multiple processes to **_divide-and-conquer_** the task.<br><br>
**gdal_retile_multi** is also **_interruptible_** and **_resumable_**. It can be ran as a **_single process on one pc/server_** or as **_multiple processes distributed over as many machines as you like_**.<br><br>
Here is a visual of the idea. See the [WIKI](https://github.com/cm0001/gdal_retile_multi/wiki) for a few more details.<br><br>
![gdal_retile_multi_n_n](https://github.com/cm0001/gdal_retile_multi/blob/master/blob/master/img/gdal_retile_multi_n_n.png)
