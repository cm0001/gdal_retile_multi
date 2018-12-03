# gdal_retile_multi
Expanding on the great work of Christian Mueller (also Chris Giesey & Elijah Robison) called gdal_retile.py.<br><br>
This code modification to **_'gdal_retile'_** allows multiple **_'gdal_retile_multi'_** processes to work concurrently in tiling one georeferenced raster dataset (or set of raster tiles) for publishing as an ImagePyramid layer for serving as a WMS/WMTS via web services provided by [Geoserver](http://geoserver.org/)/[GeoWebCache](https://www.geowebcache.org/).
<br><br>
The goal is to **_reduce the time required to ImagePyramid large raster datasets_** by allowing multiple processes to **_'divide-and-conquer'_** the task.
<br><br>
**_'gdal_retile_multi'_** is also **_interruptible_** and **_resumable_**. It can be used to tile a single raster while running on one machine or distributed across as many machines as you like.
<br><br>
Here is a visual of the idea. **See the  [WIKI](https://github.com/cm0001/gdal_retile_multi/wiki/1-gdal_retile_multi-idea)** for a few more details.<br>
![gdal_retile_multi_n_n](https://github.com/cm0001/gdal_retile_multi/blob/master/blob/master/img/gdal_retile_multi_n_n.png)
