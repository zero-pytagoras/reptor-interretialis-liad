# Nginx Upstream Redirect

This project runs Nginx in an Ubuntu Docker container, acting as a load balancer that redirects traffic from a main domain to several specific subdomain environments (`test`, `dev`, `beta`, `stage`).

## Prerequisites
- Docker and Docker Compose
- Permissions to execute Docker commands

## How to Run

1. **Start the container:**
   ```bash
   docker compose up -d --build
   ```

2. **Generate the configuration:**
   Run the script with your desired main domain to generate the Nginx config and reload the server:
   ```bash
   ./setup_domain.sh mydomain.com
   ```

## Testing Locally

If testing locally, map the domains to `127.0.0.1` in your machine's `/etc/hosts` file:
```text
127.0.0.1 mydomain.com test.mydomain.com dev.mydomain.com beta.mydomain.com stage.mydomain.com
```
Visit `http://mydomain.com` to see the Nginx upstream proxy in action.
