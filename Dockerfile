FROM nginx:alpine

COPY ./myapp /usr/share/nginx/html

EXPOSE 80