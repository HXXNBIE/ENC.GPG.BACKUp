# ENC.GPG.BACKUp
*Simple bash script to create encrypted backups with GNU Privacy Guard.*

## Requirements
- Ensure gpg is installed
- Ensure rsync is installed

### How to install pkg's (If you do not have it installed)
On Debian/Ubuntu and derivatives:
```
sudo apt update && sudo apt install gpg rsync -y
```
On Arch Linux/Manjaro
```
sudo pacman -S gpg rsync --noconfirm
```
### Verify installation
```
gpg --version
```
## Basic gpg usage:
Create a public/private key
```
gpg --full-generate-key
```
Check the created keys
```
gpg --list-keys
```
Delete stored keys:
```
gpg --delete-private-key
gpg --delete-key
```
To decrypt a file:
```
gpg -d name_file.tar.gz.gpg > name_file.tar.gz
```
## Project structure:
```
encGpgBackUp/
├── backups/
│   ├── backup_13h07m-25-02-18.tar.gz # temporary file
│   └── backup_13h07m-25-02-18.tar.gz.gpg # Example
├── gpgEncBackup.sh # main script
├── history/
│   ├── data.log # Example
│   └── hist_file # temporary file
├── sources/
│   ├── banner
│   └── header
└── README.md
```
