#! /bin/bash

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

# ------ helpes
function test_sucess() {

        test_name=$1
        if [ $? -ne 0 ] ; then
                echo "[-] Fail $test_name"
        exit
        fi
}


# ------ set  screenrc
if [ ! -e "$SCREEN_FILE" ] ; then
        echo "[+] ScreenRc does not exist. Creating File"
        touch "$SCREEN_FILE"
        echo "$basic_screen" > .screenrc
        echo "[+] ScreenRc has being created."
fi

test_sucess "to set screenrc configuration"

echo -n "[+] Creating user. Please insert  a username: "
read USER

# -- test user
id $USER
id_result=$?

# --- test for users
if [ $id_result -eq 0 ]
        then
        echo -n "User $USER already exists. Do you want to continue?[y|n]: "
        read want
        if [ $want == "n" ]
                then exit
        fi
# --- create new user
else
        # -- create user
        groupadd --system $USER
        useradd --system --gid $USER --shell /bin/bash --home /$USER/django_delphi $USER
        test_sucess "to create user"
        passwd $USER
        test_sucess "to set password"

fi

# -------- update apt-get
echo "[•] Updating apt-get. Sudo password will be necessary"
apt-get update

#python
echo "[•] Installing python"
apt-get install python3 libpq-dev python3-dev libxml2-dev libxslt1-dev
apt-get install python3-pip libxml2 build-essential autoconf libtool

#virtual env
pip3 install virtualenv

#prepare for virtual env
mkdir -p /webapps/django_delphi/
chown $USER /webapps/django_delphi/

#create virtual env
cd /webapps/django_delphi/
virtualenv .

#django and gunicorn
pip3 install gunicorn

#clone project
git clone https://github.com/VulcanoAhab/delphi.git

#pip requirements and migrate / sync db
cd /webapps/django_delphi/
source bin/activate
cd /webapps/django_delphi/delphi
pip3 install -r requirements.txt
python manage.py migrate
deactivate

