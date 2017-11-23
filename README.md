# Apache Livy on DC/OS

## Overview

## Requirements
* This version of Livy on DC/OS is designed to run on DC/OS 1.10.  The DC/OS cluster needs to be health and have the hosts definition correct as well as the 'nobody' user and 'nobody' group properly defined.
* Out of the box it is configured to use the mesosphere/spark images.  Later in this document contain instructions for modifying the supplied examples to run Livy from a private docker registry where there exists no Internet access

## Installation instructions
1. Install marathon-lb using the standard options (no customization required)
2. Run ```dcos marathon app add https://raw.githubusercontent.com/markfjohnson/dcos_Livy_server/master/livy.json`` to install the Livy and Spark-Dispatcher services
3. Download the **[TestSubmit.py](https://raw.githubusercontent.com/markfjohnson/dcos_Livy_server/master/TestSubmit.py)** test program and run using python as shown below:
```
XXXX
```
4. Once you see the task submitted message as shown above in your Python stdout, then go to the XXX-what is the best place to direct the user.
## Future Plans
* Integrat JupyterHub into the project
* Create a formal DC/OS package