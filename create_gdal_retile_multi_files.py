#!/usr/bin/python
# coding=utf-8
#
#  Purpose:
#  Create the gdal_retile_multi_N_# files for use in creating a large ImagePyramid
#
#  Author: cmood
#    Date: 12/2018
#
#  example usage: C:\>python3 create_gdal_retile_multi_files.py -N 32
#
#  requirements:
#  * python
#  * file "gdal_retile_multi_N_p.py" must exist in the folder containing this script
#

import os, re, getopt, sys, shutil

def usage():
  print ('Usage: '+sys.argv[0]+' -N <totalProcs> or --totalProcs=<totalProcs>  [-v]')

def main():

    try:
        opts, args = getopt.getopt(sys.argv[1:], "hvN:", ["help", "totalProcs="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    # default to creating just 4 gdal_retile_multi files
    n = 4
    verbose = False
    for o, a in opts:
        if o == "-v":
            verbose = True
        elif o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-N", "--totalProcs"):
                if not a.isdigit():
                    sys.exit("Error: 'totalProcs' argument must be an integer.")
                    sys.exit(2)
                n = int(a)
        else:
            assert False, "unhandled option"

    if verbose:
        print ('N=%s' % str(n))

    # Make a folder for the files
    current_directory = os.getcwd()
    source_file_path =  os.path.join(current_directory, 'gdal_retile_multi_N_p.py')

    if not os.path.exists(source_file_path):
        print ("Error: 'gdal_retile_multi_N_p.py' must exist in the same folder as this script!")
        sys.exit(2)

    # create gdal_retile_multi_N_p files folder
    folder_n_path = os.path.join(current_directory, str(n))

    try:

        if not os.path.exists(folder_n_path):
            os.makedirs(folder_n_path)

        for i in range(1,n+1):

            file_name = "gdal_retile_multi_%d_%d.py" % (n,i)

            if verbose:
                print("%d - file_name: %s" % (i, file_name))

            # Combine the file path with the new file name.
            combined_file_path = os.path.join(folder_n_path, file_name)
            shutil.copy2(source_file_path, combined_file_path)

            # read the newly copied file
            with open(combined_file_path) as f:
                s = f.read()
                f.close()

            # do some regex replacements on the new file
            with open(combined_file_path, 'w') as f:

                # create the 'totalProcs' pattern object.
                pattern = re.compile(r"totalProcs=\d+")

                # do the replace
                replace_str = "totalProcs=%s" % str(n)
                s = pattern.sub(replace_str, s)

                # create the 'thisProc' replacement pattern
                pattern = re.compile(r"thisProc=\d+")

                # do the replace
                replace_str = "thisProc=%s" % str(i)
                s = pattern.sub(replace_str, s)
                f.write(s)
                f.close()

    except OSError:
        print ("Creation of directory: %s failed." % folder_n_path)

    else:
        if verbose:
            print("Files saved to: " + folder_n_path)

if __name__ == "__main__":
    main()