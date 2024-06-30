#!/bin/bash

sudo su
# Expose env vars
## MARIADB
export MARIADB_ROOT_PASSWORD=${mariadb_root_password}
export MARIADB_DATABASE=${mariadb_database}
export MARIADB_USER=${mariadb_user}
export MARIADB_PASSWORD=${mariadb_password}

## KOALA
export BOT_OWNER=${bot_owner}
export DISCORD_TOKEN=${discord_token}
export ENCRYPTED=${encrypted}
export GMAIL_EMAIL=${gmail_email}
export GMAIL_PASSWORD=${gmail_password}
export SQLITE_KEY=${sqlite_key}
export TWITCH_SECRET=${twitch_secret}
export TWITCH_TOKEN=${twitch_token}
export DB_URL=mariadb+pymysql://$MARIADB_USER:$MARIADB_PASSWORD@$(curl -s ifconfig.io)/$MARIADB_DATABASE?charset=utf8mb4


# Mount Drive
if [ "$(lsblk /dev/sdb -fno FSTYPE)" ]
then
  echo Block store is already formatted
else
  echo Block store is being formatted
  sudo mkfs -t ext4 /dev/sdb
fi

if [ "$(lsblk /dev/sdb -fno MOUNTPOINTS)" ]
then
  echo Block store is already mounted
else
  echo Block store is being mounted
  mkdir /mnt/kb
  sudo mount /dev/sdb /mnt/kb
fi

# Update Packages
sudo apt-get update -y
sudo apt-get upgrade -y


# MOTD
cat << EOD | sudo tee /etc/motd
${motd}
EOD

# Install Docker
sudo snap install docker

until sudo docker info; do sleep 1; done

# Docker Run MariaDB
sudo docker run -d --name mariadb -p 3306:3306 \
  -e MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD -e MARIADB_DATABASE=$MARIADB_DATABASE \
  -e MARIADB_USER=$MARIADB_USER -e MARIADB_PASSWORD=$MARIADB_PASSWORD \
  -v /mnt/kb/mariadb:/var/lib/mysql  --restart unless-stopped \
  mariadb

# Docker Run KoalaBot
echo "run_koala = ${run_koala}"
if [ ${run_koala} == "true" ]
then
  echo "Running KoalaBot"
  sudo docker run -d --name koalabot -p 20051:8080 -e BOT_OWNER=$BOT_OWNER -e DISCORD_TOKEN=$DISCORD_TOKEN \
    -e ENCRYPTED=$ENCRYPTED -e GMAIL_EMAIL=$GMAIL_EMAIL -e GMAIL_PASSWORD=$GMAIL_PASSWORD \
    -e SQLITE_KEY=$SQLITE_KEY -e TWITCH_SECRET=$TWITCH_SECRET -e TWITCH_TOKEN=$TWITCH_TOKEN \
    -e DB_URL=$DB_URL \
    -v /mnt/kb/koala:/config --restart unless-stopped \
    jaydwee/koalabot:latest
else
  echo "Skipping KoalaBot"
fi

# Exit su
exit