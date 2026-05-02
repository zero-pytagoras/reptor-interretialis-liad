# Nginx config class task

As part of devops team you are required to setup http service that knows how to redirect url. Dev Team leader reuqires you to use only docker and nginx.

- Create repository under your user name in github named: reptor-interretialis
    - Create docker file that installs and runs nginx
    - Create docker compose file that runs created image and mount existing nginx config file
    - Create nginx config file that enables upstream redirect of existing urls to available servers
    - Add script that requires user to provide main url that streams to sub-url.(e.g input: mydomain.com -> test.mydomain.com , beta.mydomain.com)
        - Use all popular sub-domain url streams.

