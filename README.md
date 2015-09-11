#Overview
This is an [Ansible](http://www.ansible.com/) playbook designed to greatly simplify the installation 
of [MongoDB](https://www.mongodb.org/) into an [Ubuntu 14.04](http://www.ubuntu.com/) instance.  The playbook is:

* quick -- normally taking only a few seconds to execute
* configurable -- some of the more useful MongoDB settings are exposed as a convenient, single configuration file
* convenient -- the default settings enable the most advanced storage engine MongoDB supports and are suitable for
many projects

#Prerequisites

* an Ubuntu 14.04 Server instance with [SSH](http://www.openssh.com/) enabled and working
* the instance must have an [XFS](https://en.wikipedia.org/wiki/XFS) partition large enough to store MongoDB's data files
* the instance must have a user that has `sudo` privledges
* the instance should have 4GB of RAM -- the default configuration allows MongoDB to claim 3GB of it
* a box with the most current Ansible installed -- all testing was done using Ansible 1.9.3 on an Ubuntu 14.04 desktop
 
#Building
Since this project is just a collection of configuration and data files for Ansible to consume, no building is necessary.

#Installation
Thee first step is to get the files onto your Ansible box.  A great way is to use [Git](https://git-scm.com/) and
simply clone this project via `git clone https://github.com/kurron/ansible-mongodb.git`.  Another option is to 
[download the zip](https://github.com/kurron/ansible-mongodb/archive/master.zip) directly from GitHub.

Once you have the files available to you, you are going to have to edit the `hosts` file with a text editor.  The 
file is documented and should be easily understood. **The `dbPath` entry must be adjusted to point to the instance's
XFS partition.** Failure to do this will prevent MongoDB from being properly installed. **You must also edit the 
`ansible.cfg` file, specifically the `remote_user` property.**  Failure to do this will prevent Ansible from 
SSH'ing into the instance.

To install MongoDB all you have to do is issue `./playbook.yml` from the command line.  Ansible will ask you for the password 
of the SSH account being used as well as the password to use for `sudo` (which is normally the same as the SSH account). In a few
seconds your instance should have the most current MongoDB installed and running.  **Please note that you must reboot the instance 
into for some of the optimizations to take affect.** 

#Tips and Tricks

#Troubleshooting

A normal installation should look something like this:

```bash
./playbook.yml 
SSH password: 
SUDO password[defaults to SSH password]: 

PLAY [Gather prerequisites] *************************************************** 

GATHERING FACTS *************************************************************** 
ok: [targetserver]

TASK: [create groups based on distribution] *********************************** 
changed: [targetserver]

TASK: [debug msg="dbPath = {{ dbPath }}"] ************************************* 
ok: [targetserver] => {
    "msg": "dbPath = /var/ronbo"
}

TASK: [debug msg="engine = {{ engine }}"] ************************************* 
ok: [targetserver] => {
    "msg": "engine = wiredTiger"
}

TASK: [debug msg="cacheSizeGB = {{ cacheSizeGB }}"] *************************** 
ok: [targetserver] => {
    "msg": "cacheSizeGB = 3"
}

TASK: [debug msg="notablescan = {{ notablescan }}"] *************************** 
ok: [targetserver] => {
    "msg": "notablescan = 1"
}

PLAY [Install MongoDB] ******************************************************** 

GATHERING FACTS *************************************************************** 
ok: [targetserver]

TASK: [Install Repository keys] *********************************************** 
changed: [targetserver]

TASK: [Install MongoDB repository] ******************************************** 
changed: [targetserver]

TASK: [Install MongoDB] ******************************************************* 
changed: [targetserver]

TASK: [Copy the custom configuration file into /etc] ************************** 
changed: [targetserver]

TASK: [Set the permissions on the specified data directory] ******************* 
changed: [targetserver]

TASK: [Copy the huge pages disablement script] ******************************** 
changed: [targetserver]

TASK: [Make sure the script runs at boot time] ******************************** 
changed: [targetserver]

TASK: [Restart MongoDB] ******************************************************* 
changed: [targetserver]

PLAY RECAP ******************************************************************** 
targetserver               : ok=15   changed=9    unreachable=0    failed=0   
```

#License and Credits

*List of Changes*
