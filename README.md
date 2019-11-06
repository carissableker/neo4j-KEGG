# neo4j-kegg

## Description

Docker container based on [neo4j:3.5.12](https://github.com/neo4j/docker-neo4j-publish/tree/master/3.5.12/community) containing KEGG reactions and compounds. 

Last updated 6.11.2019. 


## Docker

### Docker Hub address: 

https://hub.docker.com/r/cbleker/neo4j-kegg

### Docker pull command 

    docker pull cbleker/neo4j-kegg

### To run container:

    docker run -it  -p 7474:7474 -p 1337:1337 -p 7687:7687 cbleker/neo4j-kegg

Then open your browser at [http://localhost:7474/](http://localhost:7474/). 
