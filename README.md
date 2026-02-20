# iManager
Mount, Backup Photos and Videos, Unmount iPhone on linux


## Usage
Mount the iPhone to `/mnt/iPhone`
```
sudo ./iManager.sh

---- iManager ----
1) Mount iPhone
2) Back-up Photos/Videos
3) Unmount iPhone
4) Install Dependencies
0) Exit
------------------

Choice: 1
[!] Success: iPhone mounted.
```

Back-up photos and videos to a user defined directory with today's date `mmddyy`
```
---- iManager ----
1) Mount iPhone
2) Back-up Photos/Videos
3) Unmount iPhone
4) Install Dependencies
0) Exit
------------------

Choice: 2
Where would you like to save your photos? (ex: /tmp/) : /tmp/iphotos
[+] Indexing files...
[+] Creating backup: /tmp/iphotos/190226 (3 files)
[########################################] 100% (3 of 3) - IMG_0961.HEIC
[!] Backup Complete!
```

Unmount the iPhone
```
---- iManager ----
1) Mount iPhone
2) Back-up Photos/Videos
3) Unmount iPhone
4) Install Dependencies
0) Exit
------------------

Choice: 3
[*] It's safe to disconnect your iPhone.
```

Exit the iManager.sh
```
---- iManager ----
1) Mount iPhone
2) Back-up Photos/Videos
3) Unmount iPhone
4) Install Dependencies
0) Exit
------------------

Choice: 0
[!] Exiting
```
