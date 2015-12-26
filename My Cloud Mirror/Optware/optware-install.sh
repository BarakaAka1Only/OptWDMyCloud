#!/bin/sh
# Optware pre-installation script, Leon Kos 2006-2008
# ARMv7 Processor rev 1 (v7l)
# CPU: Marvell Armada 370/XP
# Baraka Aka 1Only

echo "Optware install by Baraka Aka 1Only for WD MY CLOUD / MIRROR"
echo ""

REPOSITORY=http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/stable/
TMP=/tmp

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/opt/bin:/opt/sbin
unset LD_PRELOAD
unset LD_LIBRARY_PATH

_check_config()
{
    echo "Checking system config ..."
    GATEWAY=$(netstat -rn |
	sed -n 's/^0.0.0.0[ \t]\{1,\}\([0-9.]\{8,\}\).*/\1/p' )
    if [ -n "${GATEWAY}" ]; then
	echo "Using ${GATEWAY} as default gateway."
    else
	echo "Error: No default gateway set!"
	exit 2
    fi
    if [ -s /etc/resolv.conf ]; then
	echo "Using the following nameserver(s):"
	if grep nameserver /etc/resolv.conf ; then
            GATEWAY_SUBNET=$(echo "${GATEWAY}" |
		sed 's/\.[0-9]\{1,3\}\.[0-9]\{1,3\}$//')
	    if [ "${GATEWAY_SUBNET}" = "192.168" ]; then
		if grep -q ${GATEWAY} /etc/resolv.conf ; then
		    echo "Gateway ${GATEWAY} is also nameserver."
		else
		    echo "Warning: local nameserver is different than gateway!"
		    echo "Check config or enter:"
		    if test -L /etc/resolv.conf ; then 
		      echo "  sed -i s/192.168.*/${GATEWAY}/ /tmp/resolv.conf"
		    else
		      echo "  sed -i s/192.168.*/${GATEWAY}/ /etc/resolv.conf"
		    fi
		    echo "to correct this."
		fi
	    fi
	else
	    echo "Error: No nameserver specified in /etc/resolv.conf"
	    exit 5
	fi
    else
	echo "Error: Empty or nonexistent /etc/resolv.conf"
	exit 3
    fi

    if mount | grep -q /opt ; then
	[ -d /opt/etc ] && echo "Warning: /opt partition not empty! or no rw?"
    else
	echo "Error: /opt partition not mounted."
	echo "Place in a USB partitioned with ext3"
	echo "  mount -o bind /mnt/USB/USB2_c1 /opt"
	echo "to correct this."
	exit 4
    fi
}


_install_package()
{
    PACKAGE=$1
    echo "Installing package ${PACKAGE} ..."
    wget -O ${TMP}/${PACKAGE} ${REPOSITORY}/${PACKAGE}
    cd  ${TMP} 
    tar xzf ${TMP}/${PACKAGE} 
    tar xzf ${TMP}/control.tar.gz
    cd /
    if [ -f ${TMP}/preinst ] ; then
	sh ${TMP}/preinst
	rm -f ${TMP}/preints
    fi
    tar xzf ${TMP}/data.tar.gz
    if [ -f ${TMP}/postinst ] ; then
	sh ${TMP}/postinst
	rm -f ${TMP}/postinst
    fi
    rm -f ${TMP}/data.tar.gz
    rm -f ${TMP}/control.tar.gz
    rm -f ${TMP}/control
    rm -f ${TMP}/${PACKAGE}
}

_check_config
_install_package ipkg-opt_0.99.163-10_arm.ipk

/opt/bin/ipkg update
/opt/bin/ipkg install -force-reinstall ipkg-opt

##ipkg.conf
echo "src seagateplug-stable http://ipkg.nslu2-linux.org/feeds/optware/cs08q1armel/cross/stable" > /opt/etc/ipkg.conf
echo "dest /opt/ /" >> /opt/etc/ipkg.conf
/opt/bin/ipkg update
