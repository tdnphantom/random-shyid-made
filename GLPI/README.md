# 🧠 GLPI Setup Notes

setup guide for GLPI — both Docker and native version.

---

## 🐳 Docker Version

To run GLPI with Docker Compose, just do:

```bash
docker-compose up -d
```
🗿

as for the native version:
## Step 1: Update System & Install Required Packages
```
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 mariadb-server php php-mysql php-gd php-curl php-intl php-xml php-mbstring php-zip php-bz2 php-ldap libapache2-mod-php unzip curl -y
```
## Step 2: Download and Extract GLPI
```
cd /var/www/html
sudo curl -LO https://github.com/glpi-project/glpi/releases/download/10.0.14/glpi-10.0.14.tgz
sudo tar -xzf glpi-10.0.14.tgz
sudo rm glpi-10.0.14.tgz
sudo chown -R www-data:www-data glpi
```
## Step 3: Set Up MariaDB for GLPI

# Secure your MariaDB installation:
```
sudo mysql_secure_installation
```
# Then access MySQL:
```
sudo mysql
```
# And inside the MySQL shell, run:
```
CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```
## Step 4: Enable Apache modules and restart

sudo a2enmod rewrite
sudo systemctl restart apache2

🌐 Step 5: Access it from browser

Open:
```
http://localhost/glpi
```
You'll get the GLPI web installer — just follow the steps:

Language → OK
Accept license → OK
Choose "Install"

Use:
```
        Host: localhost
        DB: glpi
        User: glpi
        Pass: glpi
```

And for the Databse, just use the current existing which is the glpi itself
wait for a few and voila
