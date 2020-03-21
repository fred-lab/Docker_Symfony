# Docker Symfony

Lightweight dev environment for Symfony 4 with Docker.  
It provide :

- **Nginx** - _15.3MB_
- **PHP 7.4-fpm** - _123MB_
- **MariaDB** - _183MB_
- **NodeJS** (latest) - _67.9MB_
- **Maildev** - _67.6MB_

It use Alpine container to reduce the weight

## Requirement

- Docker
- Docker-compose

## How to use

- Clone this repo at the racine of the Symfony's project
- Rename **.env.dist** to **.env**
- Update **.env** with your information (port, database....)..

- **_!! BE CARREFULL !!_** : Now, with **Symfony 4+**, the **.env** file is now committed !! you should either add **.env** to **.gitignore**  
  or rename this file and change is name inside the **env_file** variable of the **docker-compose.yml** file for each services  
  to avoid sensibles informations like password to be expose on your repository

- Inside **docker-compose.yml** Comment useless service or uncomment the one you need
- For the **build** container (nodejs), you must have a valid **package.json** file.  
  In docker-compose.yml **build** section , for **command**, replace the npm command with a command to build the assets (npm run dev, npm run prod, npm run watch...)
- Run `docker-compose up -d`
- Go to **"localhost:80"** in a web browser (replace the port with the nginx port you set)
- Enjoy

## How to use Composer or Symfony console

You must log into the **Engine** container :  
`docker-compose exec engine sh`  
Inside the container, you can use **Composer** or **Symfony console** commands

## How to use NPM

You must log into the **Build** container :

```sh
docker-compose exec build sh
```

Inside the container, you can use **npm** or **node** commands

## How to access to the database

You must log into the **Database** container :  
`docker-compose exec database sh`  
Inside the container, you can log to the databse (with the user information from the docker-compose.yml:
`mysql -uuser -p`  
Outside the container, you can log to the databse (with the user information and the port on the host from the docker-compose.yml:
`mysql -uuser -p --host=127.0.0.1 --port=3306`  
Outside the container, you can export a database like this :
`mysqldump -uuser -p --host=127.0.0.1 --port=3306 --databases database_name > /path/to/export/database_name.sql`  
Outside the container, you can import a database like this :
`mysql -uuser -p --host=127.0.0.1 --port=3306 < /path/to/import/database_name.sql`

_Note_ : the **root** user cannot access to the database container from outside, just from inside. The **root** user must have a password.

#### Import scripts and databases when building the container

You can automatically import scripts and databases when building the database container. Simply put the scripts and/or databases in the **/docker/database/initdb.d/** folder.
Scripts extension must be _.sh and for databases _.sql or \*.sql.gz .

### Symfony

To connect Symfony to the database, you must have an ORM (_Doctrine_) installed and you must update the **.env** file

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

# Debug & Tests

You can run **PHP Unit** test and use **Xdebug** with **Docker** on your IDE (**PHPStorm/Intellij/VSCode**)

## PHPStorm/Intellij

If you use **Intellij**, you have to install 2 plugins : **PHP Remote Interpreter** & **PHP Docker**

### Create a Docker instance

- Go to **File -> Settings -> Build, Execution, Deployment -> Docker**  
  Click on **+** to add a new configuration, and add a **name**. Check **Unix \*Socket**

![alt text](https://user-images.githubusercontent.com/23243372/62820543-e172d100-bb65-11e9-83b3-987f3dc369c9.png "Docker instance")

- Go to the sub menu **Tools**  
  For Linux, you should have something like that :
  ![alt text](https://user-images.githubusercontent.com/23243372/62820573-462e2b80-bb66-11e9-8337-250290777064.png "File -> Settings -> Build, Execution, Deployment -> Docker->Tools")  
  You have to indicate where is located your docker's installation.

### Configure the PHP interpreter

- Go to **File -> Settings -> Langages & Framework -> PHP**
- Define the version of PHP of the container :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62820617-2d724580-bb67-11e9-9b78-26ef36caa91b.png "PHP Language level")

- Click on **...** to choose a CLI interpreter :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62820633-64e0f200-bb67-11e9-837b-5102282900fc.png "PHP CLI Interpreter")

As we use a Docker container to run PHP, we have to tell our IDE to use this container as a CLI Interpreter.

In **CLI Interpreter**, click on **+** to add a new configuration, and choose **From Docker, Vagrant,VM, Remote**:

![alt text](https://user-images.githubusercontent.com/23243372/62820708-3adbff80-bb68-11e9-99ed-961863338993.png "From Docker, Vagrant,VM, Remote")

Check **Docker**. In **Image name**, the IDE should find automatically the PHP's container. If not, you can add it manually (Your PHP container is something like _Your_Project_\_**engine**)  
And click **ok**

You can test if everything is ok by clicking on the refresh button:  
![alt text](https://user-images.githubusercontent.com/23243372/62821102-98c01580-bb6f-11e9-9112-d4624a70e4cc.png "PHP CLI Interpreter")

### Configure PHP Unit

**!! Your project must have an installation of PHP Unit!!**

A PHP interpreter must be installed, because your IDE use it to run the tests.

If you are using Symfony 4, you can install **PHPUnit Bridge** :

- Connect to your PHP container : `docker-compose exec engine sh`
- Install **PHPUnit Bridge** : `composer require --dev symfony/phpunit-bridge`
- **Important** Configure **PHPUnit Bridge** : `php bin/console`

- Go to **File -> Settings -> Languages & Frameworks -> PHP -> Test Framework**

Click on **+** and choose **PHPUnit by Remote Interpreter**:  
![alt text](https://user-images.githubusercontent.com/23243372/62820792-c99d4c00-bb69-11e9-94bf-045bca2421a2.png "php CLI Interpreter")

Choose your php CLI Interpreter

- In the new configuration window, in **PHPUnit Library**, you have to tell to your IDE where is located the **PHPUnit** script to run the test :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62821136-2a2f8780-bb70-11e9-82ee-c7c0109a4d4a.png "Choose the path to PHPUnit script")

If you are using **PHPUnit Bridge**, check **Path to PHPUnit.phar**. The path is something like **/opt/project/bin/.phpunit/phpunit-(major).(minor)/phpunit** (replace **phpunit-(major).(minor)** by the current version of PHPUnit, like **phpunit-7.5**)

If you have installed **PHPUNit** without **PHPUnit Bridge**, check **Use Composer Autoload** and tells where the autload.php is located (**/opt/project/vendor/autoload.php**)

- In **Test Runner**, you have to specify where is located the PHPUnit configuration's file :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62821196-69120d00-bb71-11e9-8ee6-d5920c15e6d5.png "Choose the path to phpunit.xmlm.dist")

Now, you should have something like this :  
![alt text](https://user-images.githubusercontent.com/23243372/62821208-ad9da880-bb71-11e9-8bac-3552664c6146.png "PHP Unit configuration")

Note : **/opt/project** is the root project for Docker volume. It's equivalent to **/home/docker**

#### Add a Test Runner

- Go to **Run -> Edit Configuration**, click on **+** and choose **PHPUnit**  
  ![alt text](https://user-images.githubusercontent.com/23243372/62821342-9069d980-bb73-11e9-8bdc-a86a367dd9ea.png "PHP Unit Test Runner configuration")

Choose a **name** and check **Defined in the configuration file**.

#### Run the test

To run the test, choose your **Test runner** and click on the green arrow :  
![alt text](https://user-images.githubusercontent.com/23243372/62821372-e9397200-bb73-11e9-8d74-2ddf034f351a.png "Run the test !")

_Note_ : there is a lazy way to run the test :

- Go to your PHP container : `docker-compose exec engine sh`
- And run the test manually : `php bin/phpunit`  
  ![alt text](https://user-images.githubusercontent.com/23243372/62832726-6ed02700-bc33-11e9-9383-6ceb5232e49c.png "Run the test manually")

### Configure Xdebug

To use Xdebug with Intellij/PHPStorm, we need to have 2 environments variables which are defined in **docker-compose.yml**:

```yaml
environment:
  XDEBUG_CONFIG: "xdebug.idekey='xdebug'"
  PHP_IDE_CONFIG: "serverName=xdebug"
```

We gonna use them to parameter Intellij/PHPStorm.

- Go to **Run -> Edit Configuration**, click on **+** and choose **PHP Remote Debug**

![alt text](https://user-images.githubusercontent.com/23243372/62832510-e2703500-bc2f-11e9-963c-84ec614d1cfc.png "PHP Remote Debug")

Add a **name** and for **IDE key(session id)** you must indicate the same value as the env variable **XDEBUG_CONFIG: "xdebug.idekey='xdebug'"** so **xdebug** (if the value don't match, it won't work)  
For **Server** click on **...** to add a new xdebug server.

Click on **+** to add a new configuration:  
![alt text](https://user-images.githubusercontent.com/23243372/62832567-f2d4df80-bc30-11e9-9064-ddf97f1cce53.png "xDebug configuration")

**Name** must be equal to the value of the env variable **PHP_IDE_CONFIG: "serverName=xdebug"** so **xdebug** (if the value don't match, it won't work)  
**Host** : I indicate my local ip (`hostname -i`) I think **localhost** should work fine.  
Check **Use path mapping** and map your local root path of the project to the container root path (**/home/docker**)  
Click **OK**

#### How to use Xdebug with Intellij/PHPStorm

- In a php file, put some breakpoint :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62832645-059be400-bc32-11e9-998a-ef49d2353cd1.png "Left click on the left side to put a breakpoint")

- In the top right menu, click to **start listenning for PHP debug connection**  
  ![alt text](https://user-images.githubusercontent.com/23243372/62832662-4ac01600-bc32-11e9-91db-c5fadc9e9182.png "Start listenning for PHP debug connection")

- Go to your **web browser** and refresh the page

- In **Intellij/PHPStorm**, you should see now the **variables** :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62832678-88bd3a00-bc32-11e9-8cb8-c727d6d995cc.png "Variables")

And a menu to navigate into your php's script :  
![alt text](https://user-images.githubusercontent.com/23243372/62832684-bb673280-bc32-11e9-9a75-795d4bb704e0.png "Menu")

## VS CODE

### Configure Xdebug

#### Install extension

First, you have to install **PHP Debug** by Felix Becker.

#### Edit configuration

Once it's down, open **launch.json** and replace **port** by the value of **xdebug.remote_port** in **docker/engine/php.ini**  
(**9000** was already in use on my computer, so i use **10000** instead, but the default 9000's port is fine if it's free on your computer. Just match the value in **php.ini** and **launch.json**)  
You have to edit **pathMappings** to map the root project's path (**/home/docker**) to **\${workspaceFolder}**.

```json
{
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 10000,
            "log": true,
            "pathMappings": {
                "/home/docker": "${workspaceFolder}",
              }
        },
```

in this example, I enable **log** but it's up to you. You can find others options in the plugin's documentation.

#### How to use Xdebug with VS Code

- In your php's file, put some breakpoint :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62820250-f2b9de80-bb61-11e9-87f3-04d204d60856.png "Left click on the left side to put a breakpoint")

- Go to **Debug** : ![alt text](https://user-images.githubusercontent.com/23243372/62820288-7d024280-bb62-11e9-8bcc-972a6830fd3f.png "Debug menu")

- Start listenning for Xdebug : ![alt text](https://user-images.githubusercontent.com/23243372/62820309-b76bdf80-bb62-11e9-97d3-c75d51ceac87.png "Click on the green arrow")  
  You should see that at the bottom :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62820336-234e4800-bb63-11e9-973f-db7a330caaf9.png "Click on the green arrow")

* Go to your **web browser** and refresh the page

* In **VS Code**, you should see now the **variables** :  
  ![alt text](https://user-images.githubusercontent.com/23243372/62820359-8809a280-bb63-11e9-80fd-d1bf3c74cd35.png "Variables")

And a menu to navigate into your php's script :  
![alt text](https://user-images.githubusercontent.com/23243372/62820371-c901b700-bb63-11e9-847b-09a59b1f6298.png "Menu")

## Annex

### Usefull command

`docker-compose up -d` : Create and start containers. Each time the docker-compose.yml is modified, run this command.

`docker-compose build` : Build or rebuild containers. Each time a Dockerfile is modified, run this command.

`docker-compose down` : Stop and remove containers, networks, images and volumes. Usefull to restart with a clean state

`docker-compose ps` : Display the list of containers and their status.

`docker-compose logs`: Display the logs

`docker-compose exec service_name sh` : Connect to a running container with a shell terminal. Usefull to test the container

`docker-compose run --rm service_name sh` : Run a container and log into it with a shell terminal. This container is removed when it is stop. Usefull for debug

`docker images` : Display all the image and their size

`docker rmi $(docker images -q) -f` : Force to remove every unused images. Usefull to optimize the size

`docker rm $(docker images -q) -f` : Force to remove every unused containers. Usefull to optimize the size

`docker system prune --volumes -f` : Force to remove all stopped containers, all dangling images, and all unused networks, all volumes

`docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';|` : List all docker container name and their respective IPs.
