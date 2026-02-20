#!/bin/bash

# --- Configuration ---
MOUNT_POINT="/mnt/iPhone"
DATE=$(date +%d%m%y)

if [[ $EUID -ne 0 ]]; then
   echo "[!] Please run $0 with sudo."
   exit 1
fi

mkdir -p "$MOUNT_POINT"

while true; do
    echo -e "\n---- iManager ----"
    echo "1) Mount iPhone"
    echo "2) Back-up Photos/Videos"
    echo "3) Unmount iPhone"
    echo "4) Install Dependencies"
    echo "0) Exit"
    echo -e "------------------\n"
    echo -n "Choice: "
    read -r CHOICE

    case $CHOICE in
        1)
            if mountpoint -q "$MOUNT_POINT"; then
                echo "[!] iPhone already mounted."
            else
                ifuse "$MOUNT_POINT" && echo "[!] Success: iPhone mounted." || echo "[X] Error: Check cable/Trust."
            fi
            ;;

        2)
            if ! mountpoint -q "$MOUNT_POINT"; then
                echo "[X] Error: iPhone is not mounted."
                continue
            fi

            echo -n "Where would you like to save your photos? (ex: /tmp/) : "
            read -r DEST
            FINAL_DEST="${DEST%/}/$DATE"
            mkdir -p "$FINAL_DEST"

            # 1. Gather files into an array
            echo "[+] Indexing files..."
            mapfile -t FILES < <(find "$MOUNT_POINT/DCIM" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.heic" -o -iname "*.mov" \))
            
            TOTAL=${#FILES[@]}
            if [ "$TOTAL" -eq 0 ]; then
                echo "[!] No photos found."
                continue
            fi

            echo "[+] Creating backup: $FINAL_DEST ($TOTAL files)"

            # 2. Copy loop with Progress Bar
            COUNT=0
            for FILE in "${FILES[@]}"; do
                ((COUNT++))
                
                # Extract filename
                FILENAME=$(basename "$FILE")
                
                # Copy file
                cp "$FILE" "$FINAL_DEST/"
                
                # Calculate progress percentage
                PERCENT=$(( COUNT * 100 / TOTAL ))
                BAR_WIDTH=40
                DONE=$(( PERCENT * BAR_WIDTH / 100 ))
                LEFT=$(( BAR_WIDTH - DONE ))
                
                # Generate Bar string
                BAR=$(printf "%${DONE}s" | tr ' ' '#')
                EMPTY=$(printf "%${LEFT}s" | tr ' ' '-')
                
                # Print Status Line (\r returns to start of line, -n keeps it on one line)
                printf "\r[%-s%s] %d%% (%d of %d) - %s" "$BAR" "$EMPTY" "$PERCENT" "$COUNT" "$TOTAL" "$FILENAME"
                
                # Clear end of line if filename was long
                printf "\033[K" 
            done

            echo -e "\n[!] Backup Complete!"
            ;;

        3)
            if mountpoint -q "$MOUNT_POINT"; then
                fusermount -u "$MOUNT_POINT" && echo "[*] It's safe to disconnect your iPhone."
            else
                echo "[!] Not mounted."
            fi
            ;;
	4) 
	    echo "[*] Installing dependencies"
            apt install libimobiledevice-utils ifuse ideviceinstaller -y
	    ;;

        0)
            echo "[!] Exiting"; fusermount -u "$MOUNT_POINT" 2>/dev/null; exit 0 ;;
	*)
	    echo "[!] Invalid choice. Please choose something from the menu" ;;
    esac
done
