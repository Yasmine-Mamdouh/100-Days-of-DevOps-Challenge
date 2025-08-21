#!/bin/bash

SERVERS_FILE=servers-database.txt

## Ensure .ssh directory and known_hosts file exist
mkdir -p "$HOME/.ssh"
touch "$HOME/.ssh/known_hosts"

## Load servers into arrays

mapfile -t PURPOSES < <(awk '{print $1}' "$SERVERS_FILE")
mapfile -t SERVERS  < <(awk '{print $2}' "$SERVERS_FILE")
mapfile -t PASSWORDS < <(awk '{print $3}' "$SERVERS_FILE")

## List the available servers

echo
echo "Available Servers:"
echo "------------------"
for i in "${!PURPOSES[@]}"; do
	echo "$((i+1))) ${PURPOSES[$i]}"
done

read -p "Enter Server Numbers (comma-separated, e.g. 1,3): " selection
echo

## Check if SSH key exists

if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
	echo "No SSH key found. Generating new SSH key..."
	echo
	ssh-keygen -t rsa -b 4096 -N "" -f "$HOME/.ssh/id_rsa" -q
fi

## Split selection into array

IFS=',' read -ra CHOICES <<< "$selection"

for choice in "${CHOICES[@]}"; do
	index=$((choice-1))
	purpose="${PURPOSES[$index]}"
	server="${SERVERS[$index]}"
	password="${PASSWORDS[$index]}"
	username=$(echo "$server" | cut -d@ -f1)
	hostname=$(echo "$server" | cut -d@ -f2)

	echo "Processing the $purpose Server"
	echo "------------------------------"

	## Send public key (will ask for password manually)
	## Add sudoers NOPASSWD (will ask for password manually)
	if ! ssh-keygen -F "$hostname" > /dev/null; then
		echo
		echo "----------------------------------------------------------------------------"
		echo "Password for first-time login on $purpose server (copy this manually): $password"
		echo "----------------------------------------------------------------------------"
		echo
		ssh-copy-id -o StrictHostKeyChecking=no -i "$HOME/.ssh/id_rsa.pub" "$server"
		echo "----------------------------------------------------------------------------"
		echo "Password for first-time sudo on $purpose server (copy this manually): $password"
		echo "----------------------------------------------------------------------------"
		echo
		ssh -t "$server" "echo '$username ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$username > /dev/null"
	fi

	echo
	echo "----------------------------------------------------------------------"
	echo "Done with $purpose server. You can now connect with: ssh $server"
	echo "----------------------------------------------------------------------"
	echo
done
