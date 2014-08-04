#!/usr/bin/python
import urllib2, sys, os, zipfile, subprocess, json, shutil, argparse, re, hashlib

# ===================================================================
# ParaView files / URLs
# ===================================================================
version = { "release" : { "url": "http://paraview.org/files/v4.1/",
                          "application": { "osx"    : "ParaView-4.1.0-Darwin-64bit-Lion-Python27.dmg",
                                           "linux32": "ParaView-4.1.0-Linux-32bit-glibc-2.3.6.tar.gz",
                                           "linux64": "ParaView-4.1.0-Linux-64bit-glibc-2.3.6.tar.gz",
                                           "win32"  : "ParaView-4.1.0-Windows-32bit.zip",
                                           "win64"  : "ParaView-4.1.0-Windows-64bit.zip" },
                          "documentation": "http://paraview.org/files/v4.1/ParaView-API-docs-v4.1.zip"},
            "nightly" : { "url": "http://paraview.org/files/nightly/",
                          "application": { "osx"    : "ParaView-Darwin-64bit-Lion-Python27-NIGHTLY.dmg",
                                           "linux32": "ParaView-Linux-32bit-glibc-2.3.6-NIGHTLY.tar.gz",
                                           "linux64": "ParaView-Linux-64bit-glibc-2.3.6-NIGHTLY.tar.gz",
                                           "win32"  : "ParaView-Windows-32bit-NIGHTLY.zip",
                                           "win64"  : "ParaView-Windows-64bit-NIGHTLY.zip" },
                          "documentation": "http://www.paraview.org/files/nightly/ParaView-doc.tar.gz" } }

data = "http://paraview.org/files/v4.1/ParaViewData-v4.1.0.zip"


# ===================================================================
# Download helper
# ===================================================================

def download(url, file_name):
    u = urllib2.urlopen(url)
    f = open(file_name, 'wb')
    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])
    print "\nDownloading: %s Bytes: %s" % (file_name, file_size)

    file_size_dl = 0
    block_sz = 8192
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break

        file_size_dl += len(buffer)
        f.write(buffer)
        status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
        status = status + chr(8)*(len(status)+1)
        print status,

    f.close()

# ===================================================================

def unzip(file, destination):
    zfile = zipfile.ZipFile(file)
    for name in zfile.namelist():
        fullPath = os.path.join(destination, name)
        if name.endswith('/'):
            os.makedirs(fullPath)
        else:
            if not os.path.exists(os.path.dirname(fullPath)):
                os.makedirs(os.path.dirname(fullPath))
            fd = open(fullPath,"w")
            fd.write(zfile.read(name))
            fd.close()
        status = r"   Unzip "
        if len(name) > 70:
           status += "[..]" + name[-70:]
        else:
            status += name
        status += " "*(80-len(status))
        status = status + chr(8)*(len(status)+1)
        print status,
    print

# ===================================================================

def simpleDirectoryHash(rootPath):
    # Use the tar program to create an archive without writing
    # one to disk, pipe it to the md5sum program.  The -P option
    # asks tar not to remove leading slashes, which results in
    # less output to have to parse.
    cmd = "tar -cP " + rootPath + " | md5sum"
    output = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    regex = re.compile('^([^\s]+)\s+')
    m = regex.search(output)
    returnVal = 'ERROR getting md5sum on directory'
    if m:
        returnVal = m.group(1)

    return returnVal

# ===================================================================

def getCommandLineOptions():
    p = argparse.ArgumentParser()

    p.add_argument("-m",
                   "--mode",
                   type=str,
                   default="interactive",
                   help="Either 'interactive' or 'arguments', interactive prompts for input")
    p.add_argument("-v",
                   "--installversion",
                   type=str,
                   default="release",
                   help="Either 'release' or 'nightly', no data or docs installed with nightly")
    p.add_argument("-p",
                   "--installpath",
                   type=str,
                   default=os.getcwd(),
                   help="Full path to directory which should contain installation")
    p.add_argument("-t",
                   "--apptype",
                   type=str,
                   default="linux64",
                   help="One of 'osx', 'linux32', 'linux64', 'win32', or 'win64'")
    p.add_argument("-n",
                   "--noconfigure",
                   default=True,
                   help="If provided, this option specifies not to configure local instace",
                   action='store_false')
    p.add_argument("-s",
                   "--storehashpath",
                   default="",
                   help="Full path with file name, where you wish to store json file containing binary hash")

    return p.parse_args()

# ===================================================================
# Get data locally
# ===================================================================
def mainProgram():
    print

    args = getCommandLineOptions()

    install_path = args.installpath
    mode = args.mode
    app_type = args.apptype
    do_config = args.noconfigure

    v = version[args.installversion]
    url = v['url']
    application = v['application']
    documentation = v['documentation']

    pvdataname = data[data.rfind('/')+1:]
    pvdocname = documentation[documentation.rfind('/')+1:]

    if mode == 'interactive':
        q = ''
        while q != 'y' and q != 'yes':
            if q == 'n' or q == 'no':
                install_path = raw_input("Enter ParaViewWeb install path: ")
            if q == 'q' or q == 'quit':
                sys.exit("We did nothing")
            q = raw_input("Is ParaViewWeb install path correct? (%s) yes/no/quit: " % install_path)

    print "\nInstalling ParaViewWeb inside:", install_path
    if not os.path.exists(install_path):
        os.makedirs(install_path)

    download_path = os.path.join(install_path, "download")
    if not os.path.exists(download_path):
        os.makedirs(download_path)

    # Download data + doc
    data_file = os.path.join(download_path, pvdataname)
    documentation_file = os.path.join(download_path, pvdocname)
    if not os.path.exists(data_file):
        download(data, data_file)

    if not os.path.exists(documentation_file):
        download(documentation, documentation_file)

    if mode == 'interactive':
        app_type = raw_input("\nWhich system? [osx, linux32, linux64, win32, win64, all]: ")

    # Download only for all OS for future setup
    if app_type == 'all':
        print "\nThis will only download all OS files for future install."
        for app_type in application:
            app_file = os.path.join(download_path, application[app_type])
            if not os.path.exists(app_file):
                download(url + application[app_type], app_file)
        sys.exit("Downloading done")
    else:
        # Check files and download them if needed
        app_file = os.path.join(download_path, application[app_type])

        if not os.path.exists(app_file):
            download(url + application[app_type], app_file)
    print

    # ===================================================================
    # Unpack data
    # ===================================================================

    if app_type == 'osx':
        if not os.path.exists(os.path.join(install_path, 'paraview.app')):
            print " => Unpack ParaView"
            # Mount DMG
            retvalue = subprocess.check_output(['hdiutil', 'attach', app_file])
            list = retvalue.split()
            dir_path = list[-1]
            dmg_mount = list[-3]

            # Copy application
            os.system("cp -r %s/paraview.app %s/paraview.app" % (dir_path, install_path))

            # Unmount dmg
            subprocess.check_output(["hdiutil", "detach", dmg_mount])
    elif not os.path.exists(os.path.join(install_path, 'paraview')):
        print " => Unpack ParaView"
        if app_type == 'linux32':
            os.system("cd %s;tar xvzf %s" % (install_path, app_file))
            os.rename(os.path.join(install_path, "ParaView-4.1.0-Linux-32bit"), os.path.join(install_path, "paraview"))
        elif app_type == 'linux64':
            os.system("cd %s;tar xvzf %s" % (install_path, app_file))
            os.rename(os.path.join(install_path, "ParaView-4.1.0-Linux-64bit"), os.path.join(install_path, "paraview"))
        else:
            # Unzip app
            unzip(app_file, install_path)
            if app_type == 'win64':
                os.rename(os.path.join(install_path, "ParaView-4.1.0-Windows-64bit"), os.path.join(install_path, "paraview"))
            if app_type == 'win32':
                os.rename(os.path.join(install_path, "ParaView-4.1.0-Windows-32bit"), os.path.join(install_path, "paraview"))

    # ===================================================================
    # Structure directories
    # ===================================================================
    # /data
    if data != '' and not os.path.exists(os.path.join(install_path, 'data')):
        print " => Unpack data"
        unzip(data_file, install_path)
        src = os.path.join(install_path, pvdataname[:-6], "Data")
        dst = os.path.join(install_path, 'data')
        os.rename(src, dst)
        shutil.rmtree(os.path.join(install_path, pvdataname[:-6]))

    # /www
    if documentation != '' and not os.path.exists(os.path.join(install_path, 'www')):
        print " => Unpack Web"
        if documentation_file.endswith(".zip"):
            unzip(documentation_file, install_path)
        else:
            # FIXME: instead of unzipping, we need to uncompress/untar the
            # doc file because for some reason it exists as a tar zip.  Then
            # the rest of this code relies on how unzip works, so we need to
            # keep that working.
            os.system("cd %s;tar xvzf %s" % (install_path, documentation_file))
            matcher = re.compile('(.+)\.(tar\.gz|tgz)')
            m = matcher.search(pvdocname)
            newdirname = pvdocname
            if m:
                newdirname = m.group(1)
                pvdocname = newdirname + 'xxxx'
            os.system("cd %s; mv www %s" % (install_path, newdirname))
        src = os.path.join(install_path, pvdocname[:-4], 'js-doc')
        dst = os.path.join(install_path, 'www')
        os.rename(src, dst)
        src = os.path.join(install_path, pvdocname[:-4], 'lib')
        dst = os.path.join(install_path, 'www/lib')
        os.rename(src, dst)
        src = os.path.join(install_path, pvdocname[:-4], 'ext')
        dst = os.path.join(install_path, 'www/ext')
        os.rename(src, dst)
        src = os.path.join(install_path, pvdocname[:-4], 'apps')
        dst = os.path.join(install_path, 'www/apps')
        os.rename(src, dst)
        print " => Clean web directory"
        shutil.rmtree(os.path.join(install_path, pvdocname[:-4]))

    if do_config == True:
        # /bin
        if not os.path.exists(os.path.join(install_path, 'bin')):
            os.makedirs(os.path.join(install_path, 'bin'))

        # /conf
        if not os.path.exists(os.path.join(install_path, 'conf')):
            os.makedirs(os.path.join(install_path, 'conf'))

        # /logs
        if not os.path.exists(os.path.join(install_path, 'logs')):
            os.makedirs(os.path.join(install_path, 'logs'))

    # ===================================================================
    # Configure
    # ===================================================================
    if do_config == True:
        print " => Configure local instance"

        python_exec = ''
        base_python_path = ''
        if app_type == 'osx':
            python_exec = os.path.join(install_path, 'paraview.app/Contents/bin/pvpython')
            base_python_path = os.path.join(install_path, 'paraview.app/Contents/Python/')
        elif app_type == 'linux32' or app_type == 'linux64':
            python_exec = os.path.join(install_path, 'paraview/bin/pvpython')
            base_python_path = os.path.join(install_path, 'paraview/lib/paraview-4.1/site-packages/')
        elif app_type == 'win32' or app_type == 'win64':
            python_exec = os.path.join(install_path, 'paraview/bin/pvpython.exe')
            base_python_path = os.path.join(install_path, 'paraview/lib/paraview-4.1/site-packages/')

        default_launcher_config = {
            "sessionData" : {
                "updir": "/Home"
            },
            "resources" : [ { "host" : "localhost", "port_range" : [9001, 9003] } ],
            "properties" : {
                "python_exec": python_exec,
                "python_path": base_python_path,
                "data": os.path.join(install_path, 'data'),
            },
            "configuration": {
                "host": "localhost",
                "port": 8080,
                "endpoint": "paraview",
                "content": os.path.join(install_path, 'www'),
                "proxy_file": os.path.join(install_path, 'conf/proxy.conf'),
                "sessionURL" : "ws://${host}:${port}/ws",
                "timeout" : 15,
                "log_dir" : os.path.join(install_path, 'logs'),
                "upload_dir" : os.path.join(install_path, 'data'),
                "fields" : ["file", "host", "port", "updir"]
            },
            "apps": {
                "pipeline": {
                    "cmd": ["${python_exec}", "${python_path}/paraview/web/pv_web_visualizer.py", "--port", "${port}", "--data-dir", "${data}", "-f" ],
                    "ready_line" : "Starting factory"
                },
                "visualizer": {
                    "cmd": ["${python_exec}", "${python_path}/paraview/web/pv_web_visualizer.py", "--port", "${port}", "--data-dir", "${data}", "-f", "--any-readers" ],
                    "ready_line" : "Starting factory"
                },
                "loader": {
                    "cmd": ["${python_exec}", "${python_path}/paraview/web/pv_web_file_loader.py", "--port", "${port}", "--data-dir", "${data}", "-f" ],
                    "ready_line" : "Starting factory"
                    },
                "data_prober": {
                    "cmd": ["${python_exec}", "${python_path}/paraview/web/pv_web_data_prober.py", "--port", "${port}", "--data-dir", "${data}", "-f" ],
                    "ready_line" : "Starting factory"
                    }
            }
        }

        with open(os.path.join(install_path, 'conf/launch.json'), "w") as config_file:
            config_file.write(json.dumps(default_launcher_config))

        web_exec = ''
        if app_type.startswith('win'):
            web_exec = os.path.join(install_path, 'bin/start.bat')
            with open(web_exec, "w") as run_file:
                run_file.write("%s %s %s" % (python_exec, os.path.join(base_python_path, 'vtk/web/launcher.py'), os.path.join(install_path, 'conf/launch.json')))
        else:
            web_exec = os.path.join(install_path, 'bin/start.sh')
            with open(web_exec, "w") as run_file:
                run_file.write("%s %s %s" % (python_exec, os.path.join(base_python_path, 'vtk/web/launcher.py'), os.path.join(install_path, 'conf/launch.json')))
                os.chmod(web_exec, 0750)

        # ===================================================================
        # Enable ParaViewWeb application inside index.html
        # ===================================================================

        index_html = os.path.join(install_path,"www/index.html")
        index_origin = os.path.join(install_path,"www/index.origin")
        os.rename(index_html, index_origin)

        with open(index_origin, "r") as fr:
            with open(index_html, "w") as fw:
                for line in fr:
                    if not "DEMO-APPS" in line:
                        fw.write(line)

        # ===================================================================
        # Print help
        # ===================================================================
        print
        print "To start ParaViewWeb web server just run:"
        print " "*5, web_exec
        print
        print "And go in your Web browser (Safari, Chrome, Firefox) to:"
        print " "*5, "http://localhost:8080/"
        print
        print

    if args.storehashpath != '' :
        # Hash the downloaded file
        hashedValue = simpleDirectoryHash(os.path.join(download_path, application[app_type]))
        print os.path.join(download_path, application[app_type]) + ': ' + hashedValue

        hashObj = { os.path.join(download_path, application[app_type]) : hashedValue }
        with open(args.storehashpath, 'w') as hashfile :
            hashfile.write(json.dumps(hashObj))


###
### Main program entry point.  Any exceptions in the script will get caught
### and result in a non-zero exit status, which we can catch from the bash
### script which might be running this program.
###
if __name__ == "__main__":

    try :
        mainProgram()
    except Exception as inst:
        print 'Caught exception'
        print inst
        sys.exit(1)

    sys.exit(0)
