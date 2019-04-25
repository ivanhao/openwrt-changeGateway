#!/bin/ash
gateway1='192.168.199.1' #网关1
gateway2='192.168.199.2' #网关2

conf=`grep "3,$gateway2" /etc/config/dhcp | wc -L`  #check dhcp's config
ping -c 1 -w 1 $gateway2 &>/dev/null  #check gateway2 is online

if [ $? = 0 ];then
        if [ $conf -eq 0 ];then
                sed -i "s/'3,$gateway1'/'3,$gateway2'/g" /etc/config/dhcp
                echo `date`
                echo "$gateway2 offline change gateway to: "
                echo `grep "3,$gateway2" /etc/config/dhcp`  #check dhcp's config
                echo "now reload network..."
                /etc/init.d/network reload
                ifdown lan && ifup lan
                echo "network reloaded."
        fi
else
        if [ $conf -gt 0 ];then
                sed -i "s/'3,$gateway2'/'3,$gateway1'/g" /etc/config/dhcp
                echo `date`
                echo "$gateway2 online change gateway to: "
                echo `grep "3,$gateway1" /etc/config/dhcp`  #check dhcp's config
                echo "now reload network..."
                /etc/init.d/network reload
                ifdown lan && ifup lan
                echo "network reloaded."
        fi
fi
exit
