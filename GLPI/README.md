as for the docker version, just run docker-compose up -d 🗿

as for the native version:
🧱 Step 1: Update system & install required packages

sudo apt update && sudo apt upgrade -y
sudo apt install apache2 mariadb-server php php-mysql php-gd php-curl php-intl php-xml php-mbstring php-zip php-bz2 php-ldap libapache2-mod-php unzip curl -y

📦 Step 2: Download and extract GLPI

cd /var/www/html
sudo curl -LO https://github.com/glpi-project/glpi/releases/download/10.0.14/glpi-10.0.14.tgz
sudo tar -xzf glpi-10.0.14.tgz
sudo rm glpi-10.0.14.tgz
sudo chown -R www-data:www-data glpi

🛠️ Step 3: Set up MariaDB for GLPI

sudo mysql_secure_installation

Pick a root password if asked and answer prompts (Y, Y, etc.).

Then:

sudo mysql

Inside the MySQL shell:

CREATE DATABASE glpi;
CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';
FLUSH PRIVILEGES;
EXIT;

🔧 Step 4: Enable Apache modules and restart

sudo a2enmod rewrite
sudo systemctl restart apache2

🌐 Step 5: Access it from browser

Open:

http://localhost/glpi

    You'll get the GLPI web installer — just follow the steps:

    Language → OK

    Accept license → OK

    Choose "Install"

    Use:

        Host: localhost

        DB: glpi

        User: glpi

        Pass: glpi
