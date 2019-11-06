# Method to create neo4j-KEGG

Start from 

1. Make data/KEGG_download and data/import folders

2. Download compound, reaction and glycan objects:

   ```
   ./get_KEGG.R
   ```

3. Download glycan-to-compound links:

   ```
   wget http://rest.kegg.jp/link/cpd/gl -O "data/KEGG_dowload/gl-to-cpd-api.txt"
   ```

4. Download BRITE hierachy:
   ```
   wget "https://www.genome.jp/kegg-bin/download_htext?htext=br08001.keg&format=json" -O "data/KEGG_dowload/br08001.json"
   ```

5. Start up a linked `docker-compose` with `neo4j` and `Jupyter`. 
    ```
    docker-compose up
    ```

6. Use `work/parse_data_KEGG.ipynb` to parse and format raw KEGG data

7. Use `work/import_neo4j_kegg.ipynb` to import data into neo4j graph. 

8. Shut down docker-compose  `Ctrl+C`

9. Start just the neo4j container to download the database:

    Based on https://serverfault.com/questions/835092/how-do-you-perform-a-dump-of-a-neo4j-database-within-a-docker-container

    Start up a container with neo4j, without starting the neo4j database:

    ```
    docker run \
    --publish=7474:7474 \
    --publish=7473:7473 \
    --publish=7687:7687 \
    --volume=$HOME/neo4j/data/kegg:/data \
    --ulimit=nofile=40000:40000 \
    --name=keggdump61119 \
    -it \
    neo4j:latest \
    bash
    ```

    Use `neo4j-admin` to dumb the graph:
    ```
    ./bin/neo4j-admin dump --database=graph.db --to=data/kegg61119.dump
    ```
    
    Ctrl+d to exit. 

10.  Copy the dumped graph to current folder: 
    ```
    cp ~/neo4j/data/kegg/kegg61119.dump .
    ```




