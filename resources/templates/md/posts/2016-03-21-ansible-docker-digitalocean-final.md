{:title "When Ansible & Docker in Digital Ocean - Final"
 :layout :post
 :tags ["docker" "git" "hook" "digital ocean" "cloud computing"]}

Finally we got our infrastructure ready!

## Put the docker container in ocean

The container use the official nginx images, and use the customized nginx.conf file, and use /var/www as the root folder instead of /usr/share/nginx/html.

Docker compose will help to set the container name, export ports and mount the host path, make it be accessible to docker engine, which will make publish new contents much easier without rebuild the container.

The structure in the container [repository](https://github.com/sniperliu/blog.lambdaliu.com/tree/master/infra/container) is like below
```
.
+-- docker-compose.yml
+-- config
|   +-- Dockerfile
|   +-- nginx.conf
+-- content
|   +-- www
|   	+-- index.html
|	+-- blog
|	    ⋮
+-- data
```
Note:
* data folder is kept for future use to store the data file which need backup, if there is database or CMS added etc.

### For manual setup

Download all the configuration files to the host, like /opt/site

```shell
root@HOSTNAME:~#cd /opt/site/
root@HOSTNAME:~#docker-compose up -d
```

I choose to compile the static page in local and rsync to publish the blogs to the host.

```shell
# go to my blog project direcory and trigger compilation
$ lein ring server
# edit blogs in markdown format
# the compilation should happen real time
$ rsync -avz ./resources/public/ username@HOSTNAME:/opt/site/content/www/blog
```
### For automate

rsync provide us a very easy way to publish the contents, but not good enough.
I manage my blogs with git, and it need several commands to commit/push the changes and then rsync.

I did some search and find git hooks. It is so cool to push your change to remote repository (like github etc.) and do a automated publish at the some time.



## Reference

[My blog repository](https://github.com/sniperliu/blog.lambdaliu.com)

[A Server With Docker](http://blog.th4t.net/category/a-server-with-docker.html)

[An advanced setup of Ghost and Docker made simple](http://coderunner.io/hello-blog-an-advanced-setup-of-ghost-and-docker-made-simple/)

[Using Ansible with Docker Machine to Bootstrap Host Nodes](http://nathanleclaire.com/blog/2015/11/10/using-ansible-with-docker-machine-to-bootstrap-host-nodes/) form Nathan Leclarire

