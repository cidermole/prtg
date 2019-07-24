# prtg

Python module to manage PRTG servers

[![Build Status](https://dev.azure.com/timgates/timgates/_apis/build/status/timgates42.prtg?branchName=master)](https://dev.azure.com/timgates/timgates/_build/latest?definitionId=14&branchName=master)
[![PyPi version](https://img.shields.io/pypi/v/prtg.svg)](https://pypi.org/project/prtg)
[![Python Versions](https://img.shields.io/pypi/pyversions/prtg.svg)](https://pypi.org/project/prtg)
[![PyPi downloads per month](https://img.shields.io/pypi/dm/prtg.svg)](https://pypi.org/project/prtg)
[![Documentation Status](https://readthedocs.org/projects/prtg/badge/?version=latest)](https://prtg.readthedocs.io/en/latest/?badge=latest)

# Additional Documentation:
* [Online Documentation](https://prtg.readthedocs.io/en/latest/)
* [News](NEWS.rst).
* [Template Updates](COOKIECUTTER_UPDATES.md).
* [Code of Conduct](CODE_OF_CONDUCT.md).
* [Contribution Guidelines](CONTRIBUTING.md).

## Prerequisites:

- bs4 (BeautifulSoup)
- click
- future
- lxml
- requests

## Installation

Can be installed via pip:

```
pip install prtg
```

## Warnings

Tested only on Python 3.5.2 so far. Does work with python 2.7 but not
extensively tested. 

## Description

This is a Python module to facilitate in managing PRTG servers from CLI or for
automating changes. It is really useful for scripting changes to prtg objects.

The prtg\_api no longer uses a config file. Instead you need to enter your
PRTG parameters when initiating the prtg\_api class. This change was to allow
this to be used in a more flexible way, or to manage multiple PRTG instances,
you can still set up a local config file for your parameters if you wish. The
parameters for initiating the prtg\_api class are:

```
prtg.PRTGApi(host,user,passhash,protocol='https',port='443',rootid=0)
```

Upon initialisation the entire device tree is downloaded and each probe,
group, device, sensor and channel is provided as a modifiable object. From the
main object (called prtg in example) you can access all objects in the tree
using the prtg.allprobes, prtg.allgroups, prtg.alldevices and prtg.allsensors
attributes. The channels are not available by default, you must run
sensor.get\_channels() to the get the child channels of that sensor.

You can also set the root of your sensor tree as a group that is not the root
of PRTG. This was added to allow a partial sensortree to be downloaded where
your PRTG server may have many objects or to provide access to a user with
restricted permissions.

When you are accessing an object further down the tree you only have access to
the direct children of that object. This for example will show the devices
that are in the 4th group of the allgroups array:

```
from prtg import PRTGApi

prtg = PRTGApi('192.168.1.1','prtgadmin','0000000000')

prtg.allgroups[3].devices
```

Probe and group objects can have groups and devices as children, device
objects have sensors as children and sensors can have channels as children. 

```
from prtg import PRTGApi

prtg = PRTGApi('192.168.1.1','prtgadmin','0000000000')

probeobject = prtg.allprobes[0]
groups = probeobject.groups
devices = probeobject.devices

deviceobject = devices[0]
sensors = deviceobject.sensors

sensorobject = sensors[0]
sensorobject.get_channels()

channel = sensorobject.channels[0]
```


Current methods and parameters (\* = required) on all objects include:
- rename()
- pause(duration=0,message='') (pause and resume on a channel will change the parent sensor)  
- resume()
- clone(newname=''\*,newplaceid=''\*)
- delete(confirm=True) (you can't delete the root object or channels)
- refresh()
- set\_property(name\*,value\*)
- get\_property(name\*)
- set\_additional\_param(param\*) (for custom script sensors)
- set\_interval(interval\*)
- set\_host(host\*) (ip address or hostname)
- search\_byid(id)
- add\_tags(['tag1','tag2']\*,clear\_old=False)

To come:
- move

If you are making small changes such as pause, resume, rename; the local data
will update as you go. If you are doing larger changes you should refresh the
data after each change. If you refresh the main prtg object it will refresh
everything otherwise you can just refresh an object further down the tree to
only refresh part of the local data. To refresh an object call the .refresh()
method.

The set\_property method is very powerful and flexible. You can change anything
for an object that you can change in the objects settings tab in the web ui. I
will add the more commonly used settings as separate methods. You can use the
get\_property method to test the name of the property:

```
from prtg import PRTGApi

prtg = PRTGApi('192.168.1.1','prtgadmin','0000000000')
prtg.get_property(name='location')
#returns the location and sets prtg.location to the result.

prtg.set_property(name='location',value='Canada')
```

There are delays with some actions such as resuming so you should add time
delays where appropriate.

example usage:

```
import time
from prtg import PRTGApi

prtg = PRTGApi('192.168.1.1','prtgadmin','0000000000')

for device in prtg.alldevices:
  if device.id == "1234":
    deviceobj = device

deviceobj.pause()
deviceobj.clone(newname="cloned device",newplaceid="2468")

time.sleep(10)

prtg.refresh()

for device in prtg.alldevices:
  if device.name = "cloned device":
    device.resume()

```

The PRTGApi class can be used with the root id set as the root group, a probe,
or a group. If you wanted to manage a device or sensor and don't want to
download the entire sensortree to loop through the results; you can use the
PRTGDevice and PRTGSensor classes. For example:

```
host = '192.168.1.1'
port = '80'
user = 'prtgadmin'
passhash = '0000000'
protocol = 'http'
deviceid = '2025'

device = PRTGDevice(host,port,user,passhash,protocol,deviceid)

sensorid = '2123'

sensor = PRTGSensor(host,port,user,passhash,protocol,sensorid)
```
