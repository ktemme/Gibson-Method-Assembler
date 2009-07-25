require 'rest_client'

RestClient.post '0.0.0.0:4567/upload', 
    :parts => {
      "1"=>{
        "name"=>"test", 
        "sequence"=>"catgtacgtagctagtcagtagctagtcgatcgtagctagctagtacgtagctagctagctagctgtagtacgt", 
        "prefix"=>"ata", 
        "order"=>"1", 
        "suffix"=>"tgc"
        }, 
      "2"=>{
        "name"=>"testst", 
        "sequence"=>"catgtcgtagctagtcgatgcatactatatgctagcgcgctagctagcgcatcgtatacctacatatatgctagcg", 
        "prefix"=>"tag", 
        "order"=>"2", 
        "suffix"=>"cga"
        }
    },
    :partsOrder  => "parts[]=1&parts[]=2"
    

