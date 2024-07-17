#! /bin/bash

BLUE="$(printf '\033[34m')"
RED="$(printf '\033[31m')"
DEFAULT="$(printf '\033[0m')"
PINK=$(printf '\033[35;1;3m')

print_sigure () {
    clear
    echo "
${BLUE}  ██████  ██▓  ▄████  █    ██  ██▀███  ▓█████ 
▒██    ▒ ▓██▒ ██▒ ▀█▒ ██  ▓██▒▓██ ▒ ██▒▓█   ▀ 
░ ▓██▄   ▒██▒▒██░▄▄▄░▓██  ▒██░▓██ ░▄█ ▒▒███   
  ▒   ██▒░██░░▓█  ██▓▓▓█  ░██░▒██▀▀█▄  ▒▓█  ▄ 
▒██████▒▒░██░░▒▓███▀▒▒▒█████▓ ░██▓ ▒██▒░▒████▒
▒ ▒▓▒ ▒ ░░▓   ░▒   ▒ ░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░░ ▒░ ░
░ ░▒  ░ ░ ▒ ░  ░   ░ ░░▒░ ░ ░   ░▒ ░ ▒░ ░ ░  ░
░  ░  ░   ▒ ░░ ░   ░  ░░░ ░ ░   ░░   ░    ░   
      ░   ░        ░    ░        ░        ░  ░
${RED}                  Server setup script by Anvie
${DEFAULT}
"
}

print_sigure
echo "please write server adress: "
read adress

print_sigure
echo "please write machine code: "
read machine_code

print_sigure
echo "please write machine purpose: "
read machine_purpose

# setup issue.net and mtod
tmp_file=tmp_text.txt
cat << EOF > $tmp_file 
    ░░█▒▒█▀███▌▒▒▒▒▐▒▒▒▒▒▒▒▒▒░▒░░█          Name: Sigure
    ░▐▒▒█▌▐▌▀▀▒░▒░▒▌▌▒░▒░▒▒█▒░░░░░▌         Code: $machine_code
    ░▐▒▒▀▒▐█░░░░░░█░▄▀░░░░▐░█▒▒▒▒▒▐         Adress : $adress
    ░▌░░░▒░▒▌▒░▒░▐░▀▐▒▒░▒░▌░░█▒▒▌▒▐▄        Purpose: $machine_purpose
    ░▌▒░▒░░▐▒▒▒▒▒▌░░░▌▒▐▐▐▄▀▀▀▌▒▌▒▌▌▀
    ▐▒▒▒▒▒▒▐▒▌▒▒▐▄▀▀▐▐▒▌▒▌▒▌▒▄▒▌▌▒█▐
    ▐▒▒▒▒▒▒▌▒▐▒▒▌▌▒█▄░▀░░░░▀▀▀▀▐▐▐░▌
    ▌▒▒▒▒▒▐▒▒▒▀▄░▀▀░░░░░░░░░░░░▐▒▌
    ▀▐▒▄▒▒▌▐▐▒▒▒▌▄░░░░░▀▄▀░░░▄▀▒▌▌
    ░░▐░▀▀░▐▒▌▒▒▐▒▀▄▄▄▄▄▄▄▄▀▐▒▒▐░▐
EOF

scp $tmp_file root@$adress:/etc/issue.net 

#mtod
cat << EOF > $tmp_file
echo "${PINK}Hello Master!!!"
EOF
scp $tmp_file root@$adress:/etc/mtod 

rm -rf $tmp_file


# setup ssh
ssh-keygen

ssh root@$adress << EOF
useradd anvie --create-home
passwd anvie

cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
EOF

ssh-copy-id anvie@$adress 

ssh root@$adress << EOF

echo "
# SIGURE SSH CONFIG
Port 7777
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key    
#HostKey /etc/ssh/ssh_host_ed25519_key

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
PermitRootLogin no
#StrictModes yes
#MaxAuthTries 6
MaxSessions 1

PubkeyAuthentication yes
PasswordAuthentication no
#PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yesuser
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
Banner /etc/issue.net

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server" > /etc/ssh/sshd_config

systemctl restart ssh

EOF