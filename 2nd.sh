#!/bin/bash

#setup sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get -y install sublime-text

#setup default apps
apt-get -y install copyq
apt-get -y install filezilla
apt-get -y install gnome-screenshot

#Setup Tmux
cd 
git clone https://github.com/tnory56/.tmux.git
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
gnome-terminal -- tmux new -s tmux-setup
echo "Press prefix + r to reload the tmux config"
echo "Press prefix + I to install the plugins"
read -p "Press enter when done with TMUX setup"

# VPN Picker
[ -d ~/tools ] || mkdir ~/tools
cd ~/tools && git clone https://github.com/tnory56/vpn-picker/ 
cd ~/tools/vpn-picker
chmod +x setup.sh && ./setup.sh

#Make Base Directory
basedir="/root/scans/"
mkdir $basedir

#Application to be tested
echo What is the name of the test?
read test_name

#Make Directorys
mkdir -p $basedir/$test_name/screenshots
mkdir $basedir/$test_name/tmuxlogs

#Edit tmux to point to new logs
tmuxchange="$basedir$test_name/tmuxlogs"
sed -i "/my_home_path=/c\my_home_path=\"${tmuxchange}\"" ~/.tmux/plugins/tmux-logging/scripts/variables.sh

#Mount Share Drive
clear
echo "Remember to setup your share Drive in VMWARE"
read -p "Press enter to continue script"

mount -t fuse.vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other

echo "mount -t fuse.vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other" > ~/Desktop/share.sh
chmod +x ~/Desktop/share.sh

echo "#!/bin/bash" > ~/Desktop/backup.sh
echo "cp $basedir /mnt/hgfs/Google_Drive/Engagements/ -r " >> ~/Desktop/backup.sh
chmod +x ~/Desktop/backup.sh

echo "*/10 * * * * /root/Desktop/backup.sh" > /var/spool/cron/crontabs/root
echo "@reboot sleep 60 && /root/Desktop/share.sh" >> /var/spool/cron/crontabs/root

#Install java and burp suite
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
sudo apt-get update
sudo apt-get install oracle-java8-installer

java -jar ./tools/burp.jar

apt autoremove -y
subl ~/kali-setup/ManualSetup.txt
