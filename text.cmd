#!/data/data/com.termux/files/usr/bin/bash -e
#color
red='\033[1;31m'
yellow='\033[1;33m'
blue='\033[1;34m'
reset='\033[0m'

#添加国内源
echo -e "#中科大 \ndeb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib\ndeb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib" >  "/data/data/com.termux/files/home/kali-arm64/etc/apt/sources.list"
echo -e "#阿里云\n#deb https://mirrors.aliyun.com/kali kali-rolling main non-free contrib\n#deb-src https://mirrors.aliyun.com/kali kali-rolling main non-free contrib" >> "/data/data/com.termux/files/home/kali-arm64/etc/apt/sources.list"
echo -e "#清华大学\n#deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free\n#deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free" >> "/data/data/com.termux/files/home/kali-arm64/etc/apt/sources.list"

echo -e "#官方源\n#deb http://http.kali.org/kali kali-rolling main non-free contrib\n#deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >>  "/data/data/com.termux/files/home/kali-arm64/etc/apt/sources.list"

createloginfile() {
	bin=${PREFIX}/bin/startkali
	cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash -e
red='\033[1;31m'
blue='\033[1;34m'
printf "\n\n$blue [!!!]注意\n\n"
printf "$red [!!!]自测开启中文字体时不能用谷歌拼音\n\n"
#printf "$red [!!!]kali内还没有实现播放声音\n\n"
printf "\n\n$blue [*]快捷命令\n\n"
printf "$blue [*]使用中文字体：AsChinese\n\n"
printf "$blue [*]使用英文字体：AsUS\n\n"
printf "$blue [*]安装谷歌浏览器：GetChromium\n\n"
printf "$blue [*]安装谷歌拼音输入法：GetGooglePinyin\n\n"
printf "$blue [*]修改~/.vimrc来配置vim：FixVim\n\n"
printf "$blue [*]清除VNC服务在/tmp生成的文件：CleanVNC\n\n"
printf "\n\n$blue [*]常用命令提示\n\n"
printf "$blue [*]检查更新：apt update\n\n"
printf "$blue [*]更新软件：apt upgrade\n\n"
printf "$blue [*]修改密码 sudo passwd\n\n"
printf "$blue [*]启动vnc服务：startvnc\n"
printf "$blue [*]关闭vnc服务：stopvnc\n"
printf "$blue [*]了解更多vnc服务命令"
printf "$blue tigervncserver --help\n\n"


printf "$red 养成不用就关掉的习惯，不然每次都要改vnc连接器的端口号，或者需要运行CleanVNC\n\n"

unset LD_PRELOAD
if [ ! -f /data/data/com.termux/files/home/kali-arm64/root/.version ]; then
    touch /data/data/com.termux/files/home/kali-arm64/root/.version
fi
user=kali
home="/home/\$user"
LOGIN="sudo -u \$user /bin/bash"
if [[ ("\$#" != "0" && ("\$1" == "-r")) ]]; then
    user=root
    home=/\$user
    LOGIN="/bin/bash --login"
    shift
fi

cmd="proot \\
    --link2symlink \\
    -0 \\
    -r /data/data/com.termux/files/home/kali-arm64 \\
    -b /dev \\
    -b /proc \\
    -b /data/data/com.termux/files/home/kali-arm64/home/kali:/dev/shm \\
    -b /sdcard \\
    -b $HOME \\
    -w /home/kali \\
    /usr/bin/env -i \\
    HOME=/home/kali TERM="\$TERM" \\
    LANG=\$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin \\
    \$LOGIN"
#ToExSdcard="ln -s /storage/sdcard1 /data/data/com.termux/files/home/kali-arm64/外置SD卡"

args="\$@"
if [ "\$#" == 0 ]; then
    exec \$cmd

else
    \$cmd -c "\$args"
fi
EOM
	chmod 700 $bin
}


	chroot=full

createloginfile


createPersonCmd1() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/GetGooglePinyin
	cat > $bin <<- EOM
	echo "正在安装谷歌拼音"&&echo "sudo apt update"&&sudo apt update&&echo "sudo apt install fcitx"&&sudo apt install fcitx&&echo "sudo apt install fcitx-googlepinyin"&&sudo apt install fcitx-googlepinyin
	if [ -f "/usr/share/applications/fcitx.desktop" ];then
	  cp /usr/share/applications/fcitx.desktop /home/kali/.config/autostart/fcitx.desktop
	  echo "OnlyShowIn=XFCE" >> /home/kali/.config/autostart/fcitx.desktop
echo "StartupNotify=false" >> /home/kali/.config/autostart/fcitx.desktop
echo "Terminal=false" >> /home/kali/.config/autostart/fcitx.desktop
echo "Hidden=false" >> /home/kali/.config/autostart/fcitx.desktop
	fi
EOM
	chmod 700 $bin
}
createPersonCmd2() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/startvnc
	cat > $bin <<- EOM
	echo "只允许localhost进行连接"&&echo "正在执行命令tigervncserver -xstartup /usr/bin/xfce4-session"echo "想允许其他用户连接请使用 startvnc0"&&tigervncserver -xstartup /usr/bin/xfce4-session
EOM
	chmod 700 $bin
}
createPersonCmd3() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/startvnc0
	cat > $bin <<- EOM
	echo "正在执行命令 tigervncserver -xstartup /usr/bin/xfce4-session -localhost 0"&&tigervncserver  -xstartup /usr/bin/xfce4-session -localhost 0
EOM
	chmod 700 $bin
}

#英文
createPersonCmd33() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/stopvnc
	cat > $bin <<- EOM
	echo "正在执行命令 tigervncserver -kill和CleanVNC"&&tigervncserver -kill&&echo "关闭指定vnc任务使用以下命令"&&echo "tigervncserver -kill :数字"&&CleanVNC
EOM
	chmod 700 $bin
}
createPersonCmd4() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/GetChromium
	cat > $bin <<- EOM
	echo "正在安装Chromium"&&sudo apt install chromium&&sed -i '/.*Exec=*/c\Exec=/usr/bin/chromium --no-sandbox' /usr/share/applications/chromium.desktop
EOM
	chmod 700 $bin
}
#汉化
createPersonCmd5() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/AsChinese
	cat > $bin <<- EOM
	if [ -d "/usr/share/doc/fonts-wqy-zenhei/" ];then
	  echo "正在启用中文字体"&&sed -i '/.*export LANG=*/c\' ~/.bashrc&&echo "export LANG=zh_CN.UTF-8" >> ~/.bashrc&&echo "需要重新启动kali，设置才能生效"&&exit
	else
	  echo "正在启用中文字体"&&sudo apt update&&sudo apt-get install ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy&&sed -i '/.*export LANG=*/c\' ~/.bashrc&&echo "export LANG=zh_CN.UTF-8" >> ~/.bashrc&&echo "需要重新启动kali，设置才能生效"&&exit
	fi
EOM
	chmod 700 $bin
}
#英文
createPersonCmd6() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/AsUS
	cat > $bin <<- EOM
	echo "正在启用英文字体"&&sed -i '/.*export LANG=*/c\' ~/.bashrc&&echo "export LANG=en_US.UTF-8" >> ~/.bashrc&&echo "需要重新启动kali，设置才能生效"&&exit
EOM
	chmod 700 $bin
}
createPersonCmd7() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/FixVim
	cat > $bin <<- EOM
	
	echo "syntax on" >> ~/.vimrc&&echo "set smarttab" >> ~/.vimrc&&echo "set termguicolors" ~/.vimrc&&echo "set title" >> ~/.vimrc&&echo "set relativenumber" >> ~/.vimrc

EOM
	chmod 700 $bin
}
createPersonCmd8() {
	bin=/data/data/com.termux/files/home/kali-arm64/bin/CleanVNC
	cat > $bin <<- EOM
find /tmp -name ".X*-lock" -exec rm -rf {} \; 2>/dev/null
find /tmp -name "*-lock0001*" -exec rm -rf {} \; 2>/dev/null

find /tmp -name "ssh-*" -exec rm -rf {} \; 2>/dev/null

find /tmp -name "pulse-*" -exec rm -rf {} \; 2>/dev/null

find /tmp -name ".xfsm-ICE-*" -exec rm -rf {} \; 2>/dev/null

find /tmp/.ICE-unix/ -name "*.*" -exec rm -rf {} \; 2>/dev/null

find /tmp/.X11-unix/ -name "*.*" -exec rm -rf {} \; 2>/dev/null

find /tmp -name "fcitx-socket-\:*" -exec rm -rf {} \; 2>/dev/null
#rm -rf /tmp/null

#echo "不用管find：报错"
echo "清理完成"

EOM
	chmod 700 $bin
}


createPersonCmd1
createPersonCmd2
createPersonCmd3
createPersonCmd33
createPersonCmd4
createPersonCmd5
createPersonCmd6
createPersonCmd7
createPersonCmd8


#/data/data/com.termux/files/home/kali-arm64
