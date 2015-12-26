**IPKG ON WD MY CLOUD / MIRROR INSTALL**

***Note: it maybe a lot to read but it is worth it in the end ;)***

What is IPKG?

IPKG also known as Optware is a lightweight package management system designed for embedded devices that resembles Debian's dpkg.


**First thing first here is what you will need:**

1. A USB stick i recommend a 8GB but if you have something around 2GB and above you should be fine
2. An active internet connection
3. Virtual Machine (Virtual Box)
4. GParted
5. SSH Client (Putty if using Windows. Mac use Terminal same for linux users)
6. Time

***Note: i am doing this on a Macintosh but the setup / preparation is the same***

**USB Preparation:**

In order to run IPKG we need to format our usb to a "linux" partition via ext3

To do this we will need to get and run GParted to make the partitions 

Download Virtual Box for what ever system you have at: https://www.virtualbox.org/wiki/Downloads and install it.

Download GParted Live CD/USB/HD/PXE Bootable Image .iso file from http://gparted.sourceforge.net/download.php

Plug-in your USB and at this time Virtual Box should be installed and GParted should be done downloading.

Open Virtual Box and make a new VM by clicking NEW 

Make the Type Linux, Version other 64bit and Name it whatever you want

<img src="http://i.imgur.com/H0cz18d.png" />

Give it 1GB ram (1024MB), HDD 8GB create now with type VDI allocated, name the HDD whatever you want it should bring up the name you put in the first place in my case i called it "GParted"

<img src="http://i.imgur.com/wrogpmK.png" />

<img src="http://i.imgur.com/4vqeZtc.png" />

<img src="http://i.imgur.com/W3DxFoq.png" />

<img src="http://i.imgur.com/arMCiXK.png" />

<img src="http://i.imgur.com/Y1rik84.png" />

Now your VM setup is almost complete, right click on the VM you just made and go to Settings and click on the Storage.
Then click on the Empty disk and click on Live CD / DVD. 
From there next to IDE Secondary click the disk icon and click on Choose a virtial CD/DVD disk file and when the window opens go to the location where
the .iso is contained with GParted and hit okay

<img src="http://i.imgur.com/GAtC8rb.png" />

<img src="http://i.imgur.com/xfQX8zp.png" />

<img src="http://i.imgur.com/kKKXGSj.png" />

<img src="http://i.imgur.com/M7zFgDq.png" />


Now start the VM and choose the first option

<img src="http://i.imgur.com/yYHgoS6.png" />

Once GParted loads, select your language. Sit back and wait for it to load.

Hit enter on:
<img src="http://i.imgur.com/friy959.png" />

Type 33 and press enter

<img src="http://i.imgur.com/o18WaKU.png" />

Then enter 0 and preas enter for it to start up

<img src="http://i.imgur.com/t5ZSqhZ.png" />

Your USB should be plugged in, on the menu outside the VM click Devices then USB Devices and choose your usb drive that you are going to format

Once in GParted, connect the drive you wish to Format and Partition. 

Click GParted and refresh devices or CTRL + R and on the far right where you see /dev/ click that and choose the last one should be /dev/sdb

Right-Click the drive icon and select "Unmount."

Now you will need to prepare the usb drive and format/partition it. The following images illustrate the procedure (provided by DDWRT)

***NOTE: JFFS IS NOT IMPORTANT ONLY DATA, OPTWARE AND SWAP ARE SO SKIP MAKING A JFFS PARTITION***

Click Device and select Create Partition Table

<img src="http://i.imgur.com/RGgyAt4.jpg" />

Right click the "Unallocated Space and select New. Continue this procedure for each Partition you create

<img src="http://i.imgur.com/hbGg0RG.jpg" />

<img src="http://i.imgur.com/rUJQ8k5.jpg" /> 

The partition size value for the following Data partition should be left alone, as this is the remaining space on the disk:

<img src="http://i.imgur.com/1V5g73D.jpg" /> 
<img src="http://i.imgur.com/Vubvhjt.jpg" /> 
<img src="http://i.imgur.com/nVeUDU0.jpg" /> 

You're finished! Now all that's left to do is plug the usb drive into your WD My Cloud / Mirror NAS.

SSH into your WD My Cloud / Mirror since i am using a Mac 

Type in `ssh sshd@192.168.1.120` then your password you setup when enabling SSH in the WD Dashboard 

If you haven't enabled SSH and configured it, go to your WD Dashboard, login and go to settings, click the network tab, scroll down to SSH and turn it on
From there you should see a configure link next to it, click it and type in a password you want


<img src="http://i.imgur.com/CLgQ59l.png" />

Now to install OPTWARE with a script i wrote for WD My Cloud / Mirror Users

type 

`cd /tmp`

 and run command

`wget https://raw.githubusercontent.com/BarakaAka1Only/OptWDMyCloud/master/My%20Cloud%20Mirror/Optware/optware-install.sh --no-check-certificate`


<img src="http://i.imgur.com/thEAw5z.png" />

Make permissions

type 

`chmod 0777 optware-install.sh`

Now we have to mount and bind our usb to /opt

type in 

`mount`


 hit enter and you should see all the mounted drives since this we are focused on our usb we will mount /opt on

`/dev/sdc1 on /mnt/USB/USB2_c1 type ext3 (rw)`

type in 

`mount -o bind /mnt/USB/USB2_c1 /opt`

then run 

`./optware-install.sh`

<img src="http://i.imgur.com/pxHDfgr.png" />

if you type in ipkg you will notice that it is not found we have to export the bin paths from /opt with this command

`export PATH=/opt/bin:/opt/sbin:/bin:/sbin:/usr/bin:/usr/sbin`

now type `ipkg` and you should see all the commands

<img src="http://i.imgur.com/NYLoQ7n.png" />

To install and run PlexPy

Update ipkg with command

`ipkg update`

<img src="http://i.imgur.com/73OBSYH.png" />

We need to install a few things git,which,python27

run command

`ipkg install git which python27`

from this point it will install all the dependencies needed for what we are installing 

<img src="http://i.imgur.com/ccrTxRY.png" />

<img src="http://i.imgur.com/plJ6mYw.png" />

cd into /opt with

`cd /opt`

and run 

`git clone https://github.com/drzoidberg33/plexpy.git`

<img src="http://i.imgur.com/uggpiiC.png" />

now to run PlexPy

Type 

`cd plexpy`

and since we installed python2.7 we have to run the script to its binary path to the path of the script like so

`/opt/bin/python2.7 /opt/plexpy/PlexPy.py`

if you get the following error "Failed to start on port: 8181. Is something else running?"
you will have to edit two files __init__.py and config.py to change the port


<img src="http://i.imgur.com/tXGU2HF.png" />

to do this type in

`cd /opt/plexpy/plexpy`

then

`vi __init__.py`


<img src="http://i.imgur.com/NzzqaBo.png" />

with your arrow keys, go down to line "96/721 13%" you will see CONFIG.HTTP_PORT = 8181


<img src="http://i.imgur.com/v1VwuLP.png" />


on your keyboard press "i" this will put it in "edit mode" 
now remove 8181 and type what ever four numbers you want
like so


<img src="http://i.imgur.com/B6l6qHg.png" />

press esc on your keyboard to exit out of "edit mode"
and press shift + : and type w  (this will write to the file)

then press shift + : and type q and hit enter to exit

<img src="http://i.imgur.com/1AsroXo.png" />

now do the same for the config.py file

`vi config.py`

with your arrow keys, go down to line "118/450 26%" you will see 'HTTP_PORT': (init, 'General', 8181),

change the 8181 to the same port you used in the __init__.py like so

<img src="http://i.imgur.com/geDwWMv.png" />

press esc on your keyboard to exit out of "edit mode"
and press shift + : and type w  (this will write to the file)

then press shift + : and type q and hit enter to exit


now you can run the PlexPy script with

`/opt/bin/python2.7 /opt/plexpy/PlexPy.py`

if you still get the following error "Failed to start on port: 8181. Is something else running?"

reboot your NAS and SSH into your NAS once booted fully

run the commands

`mount -o bind /mnt/USB/USB2_c1 /opt`

`export PATH=/opt/bin:/opt/sbin:/bin:/sbin:/usr/bin:/usr/sbin`

`cd /opt/plexpy/`

and

`/opt/bin/python2.7 /opt/plexpy/PlexPy.py`

If there is still an error "Failed to start on port: 8181. Is something else running?" this means that the config is already stored with 8181 we need to remove it 

type 

`cd /opt/plexpy/`

after that type 

`ls`

you will see config.ini lets remove it

then 

`rm -rf config.ini`

same with plexpy.db (if it exists `rm -rf plexpy.db`)


now run 

`/opt/bin/python2.7 /opt/plexpy/PlexPy.py`


you should now see this output which ensures that PlexPy is running

<img src="http://i.imgur.com/vuf1jSC.png" />

Go to your browser and type your WD My Cloud / Mirror NAS's ip with your port 8181 (if you changed the port then use your custom port in my case port 5366) mine is http://192.168.1.120:5366

you should see this

<img src="http://i.imgur.com/BlhVthM.png" />

That is it, you now have PlexPy running on your WD My Cloud / Mirror NAS :)

**Keep note that everytime you reboot you will have to mount / bind and export for /opt**

**I haven't found a way to do this automatically but i will keep you guys updated once i do**

**it is because /etc/fstab isn't writable so an application should possibly fix this if i decide to make one**

Hope this helps enjoy!

- Baraka
