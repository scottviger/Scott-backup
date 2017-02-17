#!/bin/bash
#Auto-Backup
#Made by Scottviger
#./backup.sh Mysqluser Mysqlpassword SQL Source-dir Destination-dir
#
time=`date +%F`	#Way the time is displayed
dirname=$time-Backup	#Name of the save dir
mysqluser=$1	#Input capture
mysqlpass=$2	#Input capture
mysql_sql=$3	#Input capture
src_dir=$4	#Input capture DON'T FINISH WITH /
des_dir=$5	#Input capture DON'T FINISH WITH /

echo "Mounting" #Mount backup dir (Optional)
mount /dev/sda1 /backup
cd /

echo "Saving." #start saving process
sudo mkdir $des_dir/$dirname && echo "."
mysqldump --opt -u $mysqluser -p$mysqlpass $mysql_sql > $des_dir/$dirname/$mysql_sql.sql && echo "."
sudo XZ_OPT=-9 tar -cpJf $des_dir/$dirname/data.tar.xz $src_dir && echo ".Done!"

echo "Creating Restoration script"
echo """
#!/bin/bash
#Auto-Backup
#Made by Scottviger
#Restoration
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"

cd /
mysql -u $mysqluser -p$mysqlpass $mysql_sql < \$DIR/$mysql_sql.sql
sudo rm -R $src_dir
sudo tar -Jxvf \$DIR/data.tar.xz
""" >> $des_dir/$dirname/restore.sh

echo "Unmounting"
umount /backup
echo "Don't forget,"
echo "Stay safe!"
