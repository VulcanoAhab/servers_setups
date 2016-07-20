# ============================================== #

basic_screen="
screen -t first_screen 
altscreen on
term screen-256color
escape ^Gg
defscrollback 10000

hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W}%c %{g}]'
"

SCREEN_FILE=".screenrc"

IPV4="ipv4_only_ssh"

IPV6="ipv6_close"



# ============================================== #
#                   work                         #
# ============================================== #


<<<<<<< HEAD

# ------ set  screenrc
if [ ! -e "$SCREEN_FILE"] ; then
    echo "ScreenRc does not exist. Creating File"
    touch "$SCREEN_FILE"
    echo $basic_screen > .screenrc
fi

if [ $? -ne ]; then 
	echo "Fail to set screenrc configuration"
	exit
fi

# ---- create sudoer user
echo "Creating user..."
groupadd --system webapps
useradd --system --gid webapps --shell /bin/bash --home /webapps/django_delphi delphi
if [ $? -ne ]; then 
	echo "Fail to create user"
	exist
fi


# --- change to user
echo "Changing  user"
su -u delphi


# -------- update apt-get
echo "[•] Updating apt-get. Sudo password will be necessary"
sudo apt-get update

#install git
echo "[•]  Git instalation is next"
sudo apt-get install git

#python
echo "[•] Installing python"
sudo apt-get install python3 libpq-dev python3-dev
sudo apt-get install python3-pip

pip install python3-virtualenv

#prepare for virtual env
sudo mkdir -p /webapps/django_delphi/
sudo chown delphi /webapps/django_delphi/

#create virtual env
cd /webapps/django_delphi/
virtualenv .

#django and gunicorn
pip install gunicorn

#clone project
git clone https://github.com/VulcanoAhab/delphi.git

#pip requirements and start gunicorn
cd delphi
pip install -r requirements.txt
gunicorn delphi.wsgi:application --bind 127.0.0.1:8000



