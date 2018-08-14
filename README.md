# neo4j-kegg

## Description

Docker container based on [neo4j:3.3.2](https://github.com/neo4j/docker-neo4j-publish/tree/d2ac73d32328f299d14aad08bb82e7daefe1e575/3.3.2/community) containing KEGG reactions and compounds. 

## Docker

### Docker Hub address: 

https://hub.docker.com/r/cbleker/neo4j-kegg

### Docker pull command 

    docker pull cbleker/neo4j-kegg

### To run container:

    docker run -it  -p 7474:7474 -p 1337:1337 -p 7687:7687 cbleker/neo4j-kegg

Then open your browser at [http://localhost:7474/](http://localhost:7474/). 
