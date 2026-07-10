# gdal_retile_multi
Expanding on the great work of Christian Mueller (also Chris Giesey & Elijah Robison) called gdal_retile.py.<br><br>
This code modification to **gdal_retile** allows multiple, separate **gdal_retile_multi** processes to work concurrently in tiling a georeferenced virtual raster dataset for publishing as an ImagePyramid/incorporating into Geoserver. Using separate **gdal_retile_multi** processes distributed across multiple multi-core processor machines dramatically reduces time required to process large-area virtual mosaics.
<br><br>
The goal is to **_reduce the time required to ImagePyramid large raster datasets_** by allowing multiple processes to **_divide-and-conquer_** the task.<br><br>
**gdal_retile_multi** is also **_interruptible_** and **_resumable_**. It can be ran as a **_single process on one pc/server_** or as **_multiple processes distributed across as many machines as you like_**.<br><br>
Here is a visual of the idea. See the [WIKI](https://github.com/cm0001/gdal_retile_multi/wiki) for a few more details.<br><br>
![gdal_retile_multi_n_n](https://github.com/cm0001/gdal_retile_multi/blob/master/blob/master/img/gdal_retile_multi_n_n.png)
