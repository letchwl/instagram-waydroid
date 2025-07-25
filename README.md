# waydroid-instagram

Automated Instagram installation script on WayDroid for Linux.
Functional only for Arch Linux or Pacman-based distributions (e.g., Manjaro, EndeavourOS).

---

## How to Install

### 1. Clone this repository  
```bash
git clone https://github.com/letchwl/instagram-waydroid.git ~/instagram-waydroid
cd ~/instagram-waydroid
```

---

### 2. Download the APK
Download Instagram APK:
```bash
https://www.apkmirror.com/apk/instagram/instagram-instagram/instagram-instagram-250-0-0-21-109-release/instagram-250-0-0-21-109-14-android-apk-download/
```
Place the Instagram APK inside the `~/Dowloads` folder and rename it to:  
`com.instagram.android.apk`

---

### 3. Give permission to execute the script
```bash
chmod +x instagram-install.sh
```

---

### 4. Run the script 
```bash
./instagram-install.sh
```

The script will install Waydroid (if not already installed), start the container, install Instagram inside it, and create a shortcut to open the app.

---

### 5. Open Instagram
Find the **Instagram** shortcut in the system menu and run it.

---

### 6. Useful commands
Start Waydroid:  
```bash
sudo systemctl start waydroid-container
waydroid session start
```

Stop Waydroid:  
```bash
waydroid session stop
```

---
That's it! Now just use Instagram running on Waydroid inside your Linux.
