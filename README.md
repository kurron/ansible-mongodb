#Overview
This is an [Ansible](http://www.ansible.com/) playbook designed to greatly simplify the installation 
of [MongoDB](https://www.mongodb.org/) into an [Ubuntu 14.04](http://www.ubuntu.com/) instance.  The playbook is:

* quick -- normally taking only a few seconds to execute
* configurable -- some of the MongoDB settings are exposed as a convenient, single configuration file
* convenient -- the default settings enable the most advanced storage engine MongoDB supports

#Prerequisites

* an Ubuntu 14.04 Server instance with SSH enabled and working
* the instance must have an [XFS](https://en.wikipedia.org/wiki/XFS) partition large enough to store MongoDB's data files
* the instance must have a user that has `sudo` privledges
* the instance should have 4GB of RAM -- the default configuration allows MongoDB to claim 3GB of it
* a box with the most current Ansible installed -- all testing was done using Ansible 1.9.3 on an Ubuntu 14.04 desktop
 
#Building
The project does not require any building and are just configuration and data files for Ansible to consume.

#Installation
Thee first step is to get the files onto your Ansible box.  A great way is to use [Git](https://git-scm.com/) and
simply clone this project via `git clone https://github.com/kurron/ansible-mongodb.git`.  Another option is to 
[download the zip](https://github.com/kurron/ansible-mongodb/archive/master.zip) directly from GitHub.

Once you have the file available to you, you are going to have to edit the `hosts` file with a text editor.  The 
file is documented and should be easily understood. **The `dbPath` entry must be adjusted to point to the instance's
XFS partition.** Failure to do this will prevent MongoDB from being properly installed.

#Tips and Tricks

#Troubleshooting

#License and Credits

*List of Changes*
