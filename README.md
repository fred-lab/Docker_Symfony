# Docker Symfony

Lightweight dev environment for Symfony 4 with Docker.  
It provide :
- **Nginx** - _15.3MB_
- **PHP 7.3.1-fpm** - _123MB_
- **MariaDB** - _151MB_
- **NodeJS** (latest) - _67.9MB_
- **Maildev** - _67.6MB_

It use Alpine container to reduce the weight

## Requirement
- Docker
- Docker-compose

## How to use
- Clone this repo at the racine of the Symfony's project
- Rename **docker-compose.yml.dist** to **docker-compose.yml**
- Update **docker-compose.yml** with your information (port, database id....) Comment useless service or uncomment the one you need  
- For the **build** container (nodejs), you must have a valid **package.json** file.  
In docker-compose.yml **build** section , for **command**, replace the npm command with a command to build the assets (npm run dev, npm run prod, npm run watch...)
- Run ```docker-compose up -d```
- Go to **"localhost:80"** in a web browser (replace the port with the nginx port you set)
- Enjoy

## How to use Composer or Symfony console
You must log into the **Engine** container :  
```docker-compose exec engine sh```  
Inside the container, you can use **Composer** or **Symfony console** commands  

## How to use NPM
You must log into the **Build** container :  
```docker-compose exec build sh```  
Inside the container, you can use **npm** or **node** commands  

## How to access to the database
You must log into the **Database** container :  
```docker-compose exec database sh```  
Inside the container, you can log to the databse (with the user information from the docker-compose.yml:
```mysql -uuser -p```  

### Symfony
To connect Symfony to the database, you must have an ORM installed and you must update the **.env** file  

In the ORM section, you must update this url :
**DATABASE_URL=mysql://db_user:db_password@database:3306/db_name**

Replace from the docker-compose.yml:
- **db_user** with the MYSQL_USER value
- **db_password** with the MYSQL_PASSWORD value
- **db_name** with the MYSQL_DATABASE value

It should look like this with the default docker-compose.yml file :
**DATABASE_URL=mysql://user:pwd@database:3306/database**

### PHPstorm
Go to **database**, in **Data Source**, select **MariaDB**  
In **Port**, indicate the port of the **database** service from the host (not the container : -**3307**:3306 -> **3307** is the host port)  
In **User**,indicate the username  
In **Password**,indicate the password  
In **Database**,indicate the database name  

Click on **Check connection** to test and save with **Ok**.

## Maildev
MailDev allow to test your projects' emails during development
If you use **SwiftMailer** with **Symfony**, in the **.env** file, replace the **Mailer_URL** with :  
**MAILER_URL=smtp://maildev:25**  


## Annex
### Usefull command

```docker-compose up -d``` : Create and start containers. Each time the docker-compose.yml is modified, run this command.

```docker-compose build``` : Build or rebuild containers. Each time a Dockerfile is modified, run this command.

```docker-compose down``` : Stop and remove containers, networks, images and volumes. Usefull to restart with a clean state

```docker-compose ps``` : Display the list of containers and their status.

```docker-compose logs```: Display the logs

```docker-compose exec service_name sh``` : Connect to a running container with a shell terminal. Usefull to  test the container

```docker-compose run --rm service_name sh``` : Run a container and log into it with a shell terminal. This container is removed when it is stop. Usefull for debug

```docker images``` : Display all the image and their size

```docker rmi $(docker images -q) -f ``` : Force to remove every  unused images. Usefull to optimize the size

```docker rm $(docker images -q) -f ``` : Force to remove every  unused containers. Usefull to optimize the size