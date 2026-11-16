docker build  -t kali-custom-ssh:latest --build-arg ROOT_PASSWORD=kali .

docker run -dit --name kali-lab-4 -p 12122:22 -p 8080:8080 --cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=NET_BIND_SERVICE kali-custom-ssh:latest
