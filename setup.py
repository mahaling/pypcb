from distutils.core import setup, Extension
from Cython.Build import cythonize
#from setuptools import setup, find_packages
import os
import numpy

# download the models first
icmodel = "wget https://www.dropbox.com/s/14miegbbkr0z4zs/model_ic.caffemodel -O ./detector/models/ic/model_ic.caffemodel"
capacitormodel = "wget https://www.dropbox.com/s/rgcnigljeg1tzth/model_capacitor.caffemodel -O ./detector/models/capacitor/model_capacitor.caffemodel"
resistormodel = "wget https://www.dropbox.com/s/0nt5i9ylrvspsic/model_resistor.caffemodel -O ./detector/models/resistor/model_resistor.caffemodel"
textmodel = "wget https://www.dropbox.com/s/52mlxjog501cm02/ctpn_trained_model.caffemodel -O ./textDetector/models/ctpn_trained_model.caffemodel"
fontmodel = "wget https://www.dropbox.com/s/tvkjz46wigzc41l/font_model.caffemodel -O ./textDetector/models/font_model.caffemodel"

os.system(icmodel)
os.system(capacitormodel)
os.system(resistormodel)
os.system(textmodel)
os.system(fontmodel)

datadir = 'detector/models'
datafiles = [(d, [os.path.join(d,f) for f in files])
    for d, folders, files in os.walk(datadir)]

with open('./requirements.txt', 'r') as f:
    required = f.read().splitlines()

cpuNMS = Extension('cpu_nms',
                   sources=['textDetector/cpu_nms.pyx'])
nmsModule = Extension('cpu_nms',
                      include_dirs=['/usr/include/python2.7', numpy.get_include()],
                      extra_compile_args=['-shared', '-pthread', '-fPIC', '-fwrapv', '-O2', '-Wall', '-fno-strict-aliasing'],
                      sources=['textDetector/cpu_nms.c'])

setup(
    name='PCBComponentDetector',
    version='0.1dev0',
    author='Gayathri Mahalingam, Kevin Marshall Gay',
    author_email='mahalingamg@uncw.edu',
    packages=['detector','textDetector', 'textDetector/layers'],
    package_data={'detector':['models/ic/*', 'models/resistor/*', 'models/capacitor/*'],
                  'textDetector':['models/*']},
    #include_package_data=True,
    data_files=datafiles,
    ext_modules=[nmsModule],
    #install_requires=required,
    #setup_requires=[],
    #tests_require=[],
    license='Creative Commons Attribution-Noncommercial-Share Alike license',
    long_description=open('README.md').read(),
)
