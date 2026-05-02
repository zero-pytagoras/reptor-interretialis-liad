#!/usr/bin/env bash
#####################################
# Purpose: Nginx subdomain docker task
# Created by: Liad Binyamin
# Date: 02/05/2026 
# Version: 0.0.1
set -o errexit
set -o nounset
set -o pipefail
#####################################

# Define variables
SUBDOMAINS=("test" "dev" "beta" "stage")
CONF_FILE="./nginx-conf/custom_site.conf"
MAIN_DOMAIN=""

get_domain() {
    if [ -z "$1" ]; then
        echo "Error: domain argument is required"
        exit 1
    fi
    MAIN_DOMAIN="$1"
}

generate_nginx_config() {
    echo "Configuring for main domain: $MAIN_DOMAIN"
    echo "Subdomains: ${SUBDOMAINS[*]}"
    echo "Generating Nginx config at $CONF_FILE..."

    # Start upstream block
    cat <<EOF > $CONF_FILE
upstream available_servers {
EOF

    # Add upstream servers
    for SUB in "${SUBDOMAINS[@]}";
    do
        echo "    server $SUB.$MAIN_DOMAIN;" >> $CONF_FILE
    done

    # Close upstream and add main server block
    cat <<EOF >> $CONF_FILE
}

server {
    listen 80;
    server_name $MAIN_DOMAIN;

    location / {
        proxy_pass http://available_servers;
    }
}
EOF

    # Add subdomain server blocks
    for SUB in "${SUBDOMAINS[@]}";
    do
cat <<EOF >> $CONF_FILE
server { 
    listen 80; 
    server_name $SUB.$MAIN_DOMAIN; 
    root /var/www/html/$SUB; 
    index index.html; 
}
EOF
    done

    echo "Configuration generated successfully!"
}

check_docker_permission(){
    if groups $USER | grep docker || [ "$EUID" -eq 0 ]
    then
        echo "User has permission to run Docker commands."
    else
        echo "User does not have permission to run Docker commands. Please add your user to the docker group or run the script as root."
        exit 1
    fi
}

restart_nginx() {
    echo "Testing Nginx configuration..."
    if docker exec ubuntu-nginx nginx -t; then
        echo "Reloading Nginx service inside the container..."
        docker exec ubuntu-nginx nginx -s reload
    else
        echo "Nginx configuration test failed. Skipping reload."
    fi
}

main() {
    check_docker_permission
    get_domain "$1"
    generate_nginx_config
    restart_nginx
}

main "$@"
