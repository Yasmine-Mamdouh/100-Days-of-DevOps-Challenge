# SSH Setup Script

This Bash script automates SSH key setup and passwordless `sudo` configuration for multiple servers.

## How it works
1. Reads server info from `servers.txt` (Purpose, username@hostname, password).
2. Displays a menu with available servers (based on Purpose).
3. Lets you pick one or more servers to configure.
4. Generates an SSH key if not already present.
5. Copies the key and sets up passwordless `sudo` for the selected servers.

## Files
- `ssh-setup.sh` → Main script
- `servers-database.txt` → List of servers (username, host, password)

## Clone the repository
```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
```

## Usage
```bash
bash ssh-setup.sh
```
Select the servers from the menu and enter their passwords when prompted.

## Example servers-database.txt
```
App1	tony@stapp01	Ir0nM@n
App2	steve@stapp02	Am3ric@
App3	banner@stapp03	BigGr33n
```

## Background
This script is related to the **KodeKloud Engineer 100 Days of DevOps Challenge and Playground**.    
The server details and infrastructure background are provided by KodeKloud as part of their tasks.  

🔗 Source: [KodeKloud Engineer Infrastructure Details](https://kodekloudhub.github.io/kodekloud-engineer/docs/projects/nautilus#infrastructure-details)
