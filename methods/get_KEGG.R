#!/usr/bin/env Rscript

# Download and save KEGG compounds, reactions and glycans.
# Depends on KEGGREST (http://bioconductor.org/packages/KEGGREST/). 
# 
# Uses code from RbioRXN, which has been archived.
# 
# This is basically a wrapper around http://restq.kegg.jp/get/<dbentries>[/<option>].
# 
# Takes a while ...

library("KEGGREST")
library("plyr")

parse_reaction_row = function(keggRow){
    if(typeof(keggRow$PATHWAY) == "NULL"){
        keggRow$PATHWAY = "NULL"
    }
    if(typeof(keggRow$NAME) == "NULL"){
        keggRow$NAME = "NULL"
    }
    if(typeof(keggRow$ENZYME) == "NULL"){
        keggRow$ENZYME = "NULL"
    }
    if(typeof(keggRow$DEFINITION) == "NULL"){
        keggRow$DEFINITION = "NULL"
    }

    keggRow = keggRow[c("ENTRY", "NAME", "DEFINITION", "EQUATION", "ENZYME", "PATHWAY")]
    for(j in names(keggRow)) {
        if (j == 'PATHWAY') {
            for(k in 1:length(keggRow$PATHWAY)) {
                keggRow$PATHWAY[k] = paste(names(keggRow$PATHWAY[k]), keggRow$PATHWAY[k], sep=': ')
            }
            keggRow$PATHWAY = paste(keggRow$PATHWAY, collapse=' ')
        }
        else {
            if(length(keggRow[[j]]) > 1) {
                keggRow[[j]] = paste(keggRow[[j]], collapse=' ')
            }
        }
    }
    keggRow = as.data.frame(keggRow, stringsAsFactors=FALSE)
    return(keggRow)
}

parse_compound_row = function(keggRow){
    if(typeof(keggRow$PATHWAY) == "NULL"){
        keggRow$PATHWAY = "NULL"
    }
    if(typeof(keggRow$NAME) == "NULL"){
        keggRow$NAME = "NULL"
    }
    if(typeof(keggRow$FORMULA) == "NULL"){
        keggRow$FORMULA = "NULL"
    }

    keggRow = keggRow[c("ENTRY", "NAME", "PATHWAY", "FORMULA")]
    for(j in names(keggRow)) {
        if (j == 'PATHWAY') {
            for(k in 1:length(keggRow$PATHWAY)) {
                keggRow$PATHWAY[k] = paste(names(keggRow$PATHWAY[k]), keggRow$PATHWAY[k], sep=': ')
            }
            keggRow$PATHWAY = paste(keggRow$PATHWAY, collapse=' ')
        }
        else {
            if(length(keggRow[[j]]) > 1) {
                keggRow[[j]] = paste(keggRow[[j]], collapse=' ')
            }
        }
    }
    keggRow = as.data.frame(keggRow, stringsAsFactors=FALSE)
    return(keggRow)
}

parse_glycan_row = function(keggRow){
    # sometimes missing, but want to keep
    if(typeof(keggRow$PATHWAY) == "NULL"){
        keggRow$PATHWAY = "NULL"
    }
    if(typeof(keggRow$NAME) == "NULL"){
        keggRow$NAME = "NULL"
    }
    if(typeof(keggRow$COMPOSITION) == "NULL"){
        keggRow$COMPOSITION = "NULL"
    }

    keggRow = keggRow[c("ENTRY", "NAME", "PATHWAY", "COMPOSITION")]
    for(j in names(keggRow)) {
        if (j == 'PATHWAY') {
            for(k in 1:length(keggRow$PATHWAY)) {
                keggRow$PATHWAY[k] = paste(names(keggRow$PATHWAY[k]), keggRow$PATHWAY[k], sep=': ')
            }
            keggRow$PATHWAY = paste(keggRow$PATHWAY, collapse=' ')
        }
        else {
            if(length(keggRow[[j]]) > 1) {
                keggRow[[j]] = paste(keggRow[[j]], collapse=' ')
            }
        }
    }
    keggRow = as.data.frame(keggRow, stringsAsFactors=FALSE)
    return(keggRow)
}



kegg_object_from_Ids = function(keggIds, keggtype) {
    server_limit = 10
    parse_function = switch(keggtype, "reaction"=parse_reaction_row,
                                      "compound"=parse_compound_row,
                                      "glycan"  =parse_glycan_row)
    kegg = data.frame()
    i = 1
    while(i <= length(keggIds)) {
        query = KEGGREST::keggGet(keggIds[i:(i+server_limit-1)])
        for(l in 1:length(query)) {
            keggRow = query[[l]]
            keggRow = parse_function(keggRow)
            kegg = rbind.fill(kegg, keggRow)
            kegg[is.na(kegg)] = ''
        }
        i = i + server_limit
    }
    return(kegg)
}

##############################################################################

KEGG_dir = file.path(".data/KEGG_dowload")

# get compounds
#compounds = KEGGREST::keggList("compound")
#compoundIds = names(compounds)
#compoundIds = sub('cpd:', '', compoundIds)
#keggCompound = kegg_object_from_Ids(compoundIds, "compound")
#keggCompound[is.na(keggCompound)] = ""
#write.table(keggCompound,  file.path(KEGG_dir, 'KEGG_compounds.tsv'), quote=FALSE, sep="\t", row.names=FALSE)

# get glycans
#glycans = KEGGREST::keggList("glycan")
#glycanIds = names(glycans)
#glycanIds = sub('gl:', '', glycanIds)
#keggGlycans = kegg_object_from_Ids(glycanIds, "glycan")
#keggGlycans[is.na(keggGlycans)] = ""
#write.table(keggGlycans, file.path(KEGG_dir, 'KEGG_glycans.tsv'), quote=FALSE, sep="\t", row.names=FALSE)

# get reactions
reactions = KEGGREST::keggList("reaction")
reactionIds = names(reactions)
reactionIds = sub('rn:', '', reactionIds)
keggReaction = kegg_object_from_Ids(reactionIds, "reaction")
keggReaction[is.na(keggReaction)] = ""
write.table(keggReaction, file.path(KEGG_dir, 'KEGG_reactions.tsv'), quote=FALSE, sep="\t", row.names=FALSE)

