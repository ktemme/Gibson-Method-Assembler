def render_ape(parts)
  sequence = fullSequence(parts)
  
  # return a string containing the ApE file
  ape = format("LOCUS       %s %+11s bp ds-DNA     %-8s %-3s %-11s\n", 
          "", 
          sequence.size.to_s, 
          "circular", 
          "", 
          Date.today)
          
  ape += "DEFINITION\nACCESSION\nVERSION\nSOURCE\n  ORGANISM\nCOMMENT\n"
  ape += "COMMENT     Platypus:ID:#{plasmid.id}\n"
  ape += "COMMENT     ApEinfo:methylated:1\nFEATURES             Location/Qualifiers\n"


  # this sections needs reworking <= features could be "join"
  parts.each do |part|
  
    if annotation.start > annotation.end then
      loc = "complement(" + annotation.end.to_s + ".." + annotation.start.to_s + ")"
    else
      loc = annotation.start.to_s + ".." + annotation.end.to_s
    end

    ape += format("     %-16s%s\n", annotation.part.kind.name, loc)
    ape += "                     /label=" + annotation.part.name + "\n"
    ape += "                     /ApEinfo_fwdcolor=" + annotation.forward_color + "\n"
    ape += "                     /ApEinfo_revcolor=" + annotation.reverse_color + "\n"
  
  end # annotations.each
  
  ape += "ORIGIN\n"
  
  # sequence output
  i = 0
  while i < sequence
    ape += format("%+9s %s %s %s %s %s %s\n", 
              i+1,
              sequence[i..i+9], 
              sequence[i+10..i+19], 
              sequence[i+20..i+29], 
              sequence[i+30..i+39], 
              sequence[i+40..i+49], 
              sequence[i+50..i+59])
    i += 60
  end
  
  ape += "//"
  
  ape
  
end # download_ape