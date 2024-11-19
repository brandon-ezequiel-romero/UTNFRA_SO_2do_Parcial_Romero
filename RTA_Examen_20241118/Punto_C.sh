echo "FROM nginx:latest" >> /home/vagrant/UTN-FRA_SO_Examenes/202406/docker/Dockerfile
echo "COPY index.html /usr/share/nginx/html/index.html" >> /home/vagrant/UTN-FRA_SO_Examenes/202406/docker/Dockerfile
echo "EXPOSE 80" >> /home/vagrant/UTN-FRA_SO_Examenes/202406/docker/Dockerfile

cd /home/vagrant/UTN-FRA_SO_Examenes/202406/docker/
sudo docker build -t web1-romero .

echo "docker run -d -p 8080:80 --name web1-container web1-romero" > /home/vagrant/UTN-FRA_SO_Examenes/202406/docker/run.sh

docker tag web1-romero bbrandoneze/web1-romero
docker push bbrandoneze/web1-romero

