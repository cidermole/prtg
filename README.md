# prtg
Python module to manage PRTG servers

Python module to facilitate managing PRTG servers from CLI or for automating changes.

Upon initialisation the entire device tree is downloaded and each probe, group, device, sensor and channel is provided as a modifiable object. From the main object (called prtg in example) you can access all objects in the tree using the prtg.allprobes, prtg.allgroups, prtg.alldevices and prtg.allsensors attributes. The channels are not available by default, you must run sensor.get_channels() to the get the child channels of that sensor.

When you are accessing an object further down the tree you only have access to the direct children of that object. This for example will show the devices that are in the 4th group of the allgroups array:
```
from prtg import prtg_api

prtg = prtg_api()

prtg.allgroups[3].devices
```

Current methods include:
- rename
- pause
- resume
- clone
- delete
- refresh

To come:
- set property
- move

If you are making small changes such as pause, resume, rename; the local data will update as you go. If you are doing larger changes you should refresh the data after each change. If you refresh the main prtg object it will refresh everything otherwise you can just refresh an object further down the tree to only refresh part of the local data. To refresh an object call the .refresh() method.

There are delays with some actions such as resuming so you should add time delays where appropriate.

example usage:
```
import time
from prtg import prtg_api

prtg = prtg_api()

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
