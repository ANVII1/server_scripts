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

# ///////////////////////////// input data

print_sigure
echo "please write server adress: "
read adress

print_sigure
echo "please write machine code: "
read machine_code

print_sigure
echo "please write machine purpose: "
read machine_purpose

# ///////////////////////////// ssh config

print_sigure
ssh-keygen 
ssh-copy-id root@$adress

print_sigure
ssh root@$adress << EOF
useradd anvie --create-home
passwd anvie
EOF

print_sigure
ssh-copy-id anvie@$adress 

print_sigure
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



EOF

# ///////////////////////////// setup issue.net and mtod

# issue.net
print_sigure
tmp_file=issue.net
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
tmp_file=motd
cat << EOF > $tmp_file
${PINK}Hello Master!!!${DEFAULT}
EOF
scp $tmp_file root@$adress:/etc/motd 

rm -rf $tmp_file

# ///////////////////////////// end of setup 
ssh root@$adress "rm -rf /root/.ssh ; systemctl restart ssh"

print_sigure
echo "Server is setting up!"