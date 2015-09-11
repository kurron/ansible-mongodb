#Overview
This is an [Ansible](http://www.ansible.com/) playbook designed to greatly simplify the installation 
of [MongoDB](https://www.mongodb.org/) into an [Ubuntu 14.04](http://www.ubuntu.com/) instance.  The playbook is:

* quick -- normally taking only a few seconds to execute
* configurable -- some of the more useful MongoDB settings are exposed as a single configuration file
* convenient -- the default settings enable the most advanced storage engine MongoDB supports and are suitable for
many projects

#Prerequisites

* an Ubuntu 14.04 Server instance with [SSH](http://www.openssh.com/) enabled and working
* the instance must have an [XFS](https://en.wikipedia.org/wiki/XFS) partition large enough to store MongoDB's data files
* the instance must have a user that has `sudo` privledges
* the instance should have 4GB of RAM -- the default configuration allows MongoDB to claim 3GB of it
* a box with the most current Ansible installed -- all testing was done using Ansible 1.9.3 on an Ubuntu 14.04 desktop talking 
to an Ubuntu 14.04 server
 
#Building
Since this project is just a collection of configuration and data files for Ansible to consume, no building is necessary.

#Installation
The first step is to get the files onto your Ansible box.  A great way is to use [Git](https://git-scm.com/) and
simply clone this project via `git clone https://github.com/kurron/ansible-mongodb.git`.  Another option is to 
[download the zip](https://github.com/kurron/ansible-mongodb/archive/master.zip) directly from GitHub.

Once you have the files available to you, you are going to have to edit the `hosts` file with a text editor.  The 
file is documented and should be easily understood. **The `dbPath` entry must be adjusted to point to the instance's
XFS partition.** Failure to do this will prevent MongoDB from being properly installed. **You must also edit the 
`ansible.cfg` file, specifically the `remote_user` property.**  Failure to do this will prevent Ansible from 
SSH'ing into the instance.

To install MongoDB all you have to do is issue `./playbook.yml` from the command line.  Ansible will ask you for the password 
of the SSH account being used as well as the password to use for `sudo` (normally, you can just hit `Enter` here). In a few
seconds your instance should have the most current MongoDB installed and running.  **Please note that you must reboot the instance 
in order for some of the optimizations to take affect.** 

#Tips and Tricks

##Verifying The Setup
Before trying the actual installation, it is often helpful to verify that all of your Ansible and SSH ducks are in a row.  We 
have provided a convenience script that has Ansible execute a simple `ping` command against your instance.  Try running 
`bin/ping-server.sh` to verify things are correctly set up.  If things are proper, you should see something similar to this:

```bash
bin/ping-server.sh 
SSH password: 
SUDO password[defaults to SSH password]: 
targetserver | success >> {
    "changed": false, 
    "ping": "pong"
}
```

##Verifying The MongoDB Installation
The simplest way to validate the MongoDB installation is to SSH into the instance and run the MongoDB cli: `mongo`.  If MongoDB is alive and
listening, you should see something like this:

```
MongoDB shell version: 3.0.6
connecting to: test
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	http://docs.mongodb.org/
Questions? Try the support group
	http://groups.google.com/group/mongodb-user
> 
```

If you see warnings about `hugepage` settings that probably means you have not rebooted the instance and the optimization script 
hasn't been run yet.  Once you are in the shell, you can examine the MongoDB settings by executing `db.serverStatus()`.  That will 
produce a large JSON document detailing all of MongoDB's current settings.  If you see that the `storageEngine` is using
 `wiredTiger`, then things probably went well:

```json
	"storageEngine" : {
		"name" : "wiredTiger"
	},
	"wiredTiger" : {
		"uri" : "statistics:",
		"LSM" : {
			"sleep for LSM checkpoint throttle" : 0,
			"sleep for LSM merge throttle" : 0,
			"rows merged in an LSM tree" : 0,
			"application work units currently queued" : 0,
			"merge work units currently queued" : 0,
			"tree queue hit maximum" : 0,
			"switch work units currently queued" : 0,
			"tree maintenance operations scheduled" : 0,
			"tree maintenance operations discarded" : 0,
			"tree maintenance operations executed" : 0
		},
```

##Double Check the Production Checklist
The MongoDB folks have provided a [Production Checklist](http://docs.mongodb.org/manual/administration/production-checklist/) that 
should be checked to verify that your instance is running with optimal settings.  Some settings, such as disabling hugepage, is 
done by the playbook but many of them require a human to examine the environment and determine the proper settings.

##Installing Ubuntu As A Virtual Machine
When installing Ubuntu, make sure to hit the `F4` key and select `Minimal virtual machine`.  This will improve the performance 
of the VM as well as enable some optimizations that MongoDB can take advantage of.  For example,  the `Use the noop disk scheduler 
for virtualized drives in guest VMs` tip in the Production Checklist is already enabled.

#Troubleshooting

##An Example Run
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

##Only Works On Ubuntu
When Ansible runs, it gathers up information about the target machine and will refuse to provision machine if 
it isn't an Ubuntu box.

#License and Credits
This project is licensed under the [Apache License Version 2.0, January 2004](http://www.apache.org/licenses/).

#List of Changes
