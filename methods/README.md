# Proteome-Project
Poopomics: Exploring the development of the human gut microbiome by spraying poop into a mass spectrometor, and then interpreting it with a computer. 

## Data
No data is kept in this repo. Files will be available in the Google Drive. Instructions on using rclone to access the data are [here](/docs/rclone.md). 

## Set up

### Neo4j Database

#### To remove
If you need to remove the graph image. 

1. Remve the container: 

       docker-compose down

   Or get the container ID from the first column in:
      
       docker ps -a | grep proteomegraph
       
   And delete it using:

       docker rm <container ID>  

2. Delete the image:
    
       docker rmi proteomegraph

3. Delete the folder with the graph data (if it exists). 

       sudo rm -rf ~/neo4j/data/proteome/

#### To install
To create a copy of the graph on you own computer you will need docker and docker-compose: 

1. Clone this repo to your computer. 
    
       git clone https://github.com/UTKLangstonLab/Proteome-Project.git 

   Or update it:
      
       git pull

2. Download the file called "proteome.dump" from the Google Drive to and save it the same folder. 

3. Build the neo4j container with the graph.  
    
       docker build --tag proteomegraph .

   To run this image: 

       docker run -it  -p 7474:7474 -p 1337:1337 -p 7687:7687 proteomegraph
       
   And visit [http://localhost:7474/](http://localhost:7474/). 

### Link the neo4j database to a Jupyter notebook

4. Start up the neo4j database and linked jupyter notebook with [docker-compose](https://docs.docker.com/compose/). 
   To run the first time, navigate to this folder (containing docker-compose.yml) and type:

       docker-compose up

   Thereafter you can use 

       docker-compose start

   To stop the containers, use:

       docker-compose stop
       
   Or to stop and remove them:
   
       docker-compose down
   
   Open your browser at the http://localhost:8888/?token=... link printed to the terminal. If the logs are not printed, run

       docker-compose logs | grep 'http://localhost:.*/?token' | tail -1 
 
   to find the correct link. 
