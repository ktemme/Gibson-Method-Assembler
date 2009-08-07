def format_sequence(sequence,opts={})
  size = opts['size'] || 80
  delimiter = opts['delimiter'] || '<br/>'

  a = 0
  b = size-1
  result = ''

  while b < sequence.size
    result += sequence[a..b] + delimiter
    a += size 
    b += size
  end
  
  result += sequence[a..b]
  
  result
end


# Second option: send an object that contains an array of annotations.
# Add an attribute that includes the delimiter.

def format_annotated_sequence(object,args={})
  size = args['size'] || 80
  delimiter = args['delimiter'] || '<br/>'
  
  # We expect sequence to be an object that contains an array of annotations
  # Each annotation is a hash with a 'sequence' attribute
  # This method adds a 'delimited_sequence' attribute to each annotation
  
  a = 0
  b = size - 1
  carry = 0
  
  object['annotations'].each do |annotation|
    seq = annotation[:sequence]
    annotation[:delimited_sequence] = ''
        
    while b < seq.size
      annotation[:delimited_sequence] += seq[a..b] + delimiter
      a = b + 1 
      b += size
    end

    annotation[:delimited_sequence] += seq[a..b]
    tail = seq[a..b].size

    if tail == seq.size  # Everything fit onto the current line
      carry += tail
    else # Reset the carry flag
      carry = tail
    end

    # p "Tail: #{tail} and Length: #{seq.size}, next part on this line: #{b-a+1}"
    a = 0
    b = size - carry - 1
    
  end
  
  object
end


seq = "cggcgataatggcctgcttctcgccgaaacgtttggtggcgggaccagtgacgaaggcttgagcgagggcgtgcaagattccgaataccgcaagcgacaggccgatcatcgtcgcgctccagcgaaagcggtcctcgccgaaaatgacccagagcgctgccggcacctgtcctacgagttgcatgataaagaagacagtcataagtgcggcgacgatagtcatgccccgcgcccaccggaaggagctgactgggttgaaggctctcaagggcatcggcggagcttatcgactgcacggtgcaccaatgcttctggcgtcaggcagccatcggaagctgtggtatggctgtgcaggtcgtaaatcactgcataattcgtgtcgctcaaggcgcactcccgttctggataatgttttttgcgccgacatcataacggttctggcaaatattctgaaatgagctgttgacaattaatcatcggctcgtataatgtgtggaattgtgagcggataacaatttactagagattaaagaggagaaattaagcATGAAAACTATGGACGGTAACGCTGCGGCTGCATGGATTAGCTACGCCTTTACCGAAGTGGCTGCGATCTACCCGATTACGCCGAGCACCCCGATGGCGGAAAATGTGGACGAATGGGCTGCGCAGGGCAAGAAGAACCTCTTCGGCCAGCCGGTGCGCCTGATGGAGATGCAGTCGGAAGCGGGTGCAGCAGGTGCTGTGCATGGCGCCTTGCAAGCTGGCGCACTGACGACCACCTACACCGCGTCGCAGGGCCTGTTGCTGATGATCCCAAACATGTACAAAATCGCGGGTGAACTGCTGCCGGGTGTCTTTCATGTTTCGGCACGCGCACTGGCCACCAATAGCCTCAACATCTTTGGCGATCATCAGGATGTAATGGCGGTGCGCCAAACGGGCTGCGCGATGTTGGCCGAGAATAACGTCCAGCAAGTTATGGATTTGTCCGCGGTAGCCCACTTGGCAGCGATCAAAGGTCGCATTCCGTTCGTGAACTTCTTCGATGGCTTTCGCACCAGCCACGAAATCCAGAAGATCGAGGTTCTGGAATATGAACAGCTGGCCACCTTGTTGGATCGTCCGGCCCTGGACAGCTTCCGCCGTAACGCCCTTCACCCGGACCACCCGGTCATCCGTGGCACCGCCCAGAACCCGGACATCTACTTCCAGGAACGTGAGGCCGGTAACCGTTTCTATCAGGCGCTCCCGGATATTGTGGAATCTTACATGACCCAGATTTCTGCCCTGACTGGTCGCGAGTATCACCTGTTTAACTACACTGGTGCTGCGGATGCGGAGCGCGTGATCATCGCGATGGGCTCTGTCTGTGACACCGTCCAAGAGGTGGTTGACACGCTGAATGCAGCGGGTGAGAAAGTTGGTCTGCTCTCCGTTCATCTTTTCCGCCCGTTTTCGTTAGCGCACTTCTTCGCCCAACTGCCGAAAACTGTACAGCGTATCGCAGTATTGGACCGTACGAAAGAGCCAGGTGCTCAAGCAGAGCCGCTGTGCCTCGATGTGAAGAATGCCTTTTACCACCATGACGATGCCCCGTTGATTGTGGGTGGTCGCTATGCCTTGGGCGGTAAGGACGTGTTGCCGAACGATATTGCGGCCGTGTTTGATAACCTGAACAAACCGCTGCCGATGGACGGCTTCACGCTGGGTATCGTGGACGATGTTACCTTCACCTCTCTCCCGCCAGCGCAGCAGACCCTGGCGGTTTCTCACGACGGCATCACGGCATGTAAGTTTTGG"

# formatted = format_sequence(seq, { :size => 80, :delimiter => '<br/>'})



obj = Hash.new
obj['annotations'] = Array.new
obj['annotations'] << {:sequence => 'cggcgataatggcctgcttctcgccgaaacgtttggtggcgggaccagtgacgaaggcttgagcgagggcgtgcaagattccgaataccgcaagcgacaggccgatcatcgtcgcgctccagcgaaagcggtcctcgccgaaaatgacccagagcgctgccggcacctgtcctacgagttgcatgataaagaagacagtcataagtgcggcgacgatagtcatgccccgcgcccaccggaaggagctgactgggttgaaggctctcaagggcatcggcggagcttatcgactgcacggtgcaccaatgcttctggcgtcaggcagccatcggaagctgtggtatggctgtgcaggtcgtaaatcactgcataattcgtgtcgctcaag'}
obj['annotations'] << {:sequence => 'gcgcactcccgttctggataatgttttttgcgccgacatcataacggttctggcaaatattctgaaatgagctgttgacaattaatcatcggctcgtataatgtgtggaattgtgagcggataacaatttactagagattaaagaggagaaattaagcATGAAAACTATGGACGGTAACGCTGCGGCTGCATGGATTAGCTACGCCTTTACCGAAGTGGCTGCGATCTACCCGATTACGCCGAGCACCCCGATGGCGGAAAATGTGGACGAATGGGCTGCGCAGGGCAAGAAGAACCTCTTCGGCCAGCCGGTGCGCCTGATGGAGATGCAGTCGGAAGCGGGTGCAGCAGGTGCTGTGCATGGCGCCTTGCAAGCTGGCGCACTGACGACCACCTACACCGCGTCGCAGGGCCTGTTGCTGATGATCCCAAACATGTACAAAATCGCGGGTGAACTGCTGCCGGGTGTCTTTCATGTTTCGGCACGCGCACTGGCCACCAATAGCCTCAACATCTTTGGCGATCATCAGGATGTAATGGCGGTGCGCCAAACGGGCTGCGCGATGTTGGCCGAGAATAACGTCCAGCAAGTTATGG'}
obj['annotations'] << {:sequence => 'ATTTGTCCGCGGTAGCCCACTTGGCAGCGATCAAAGGTCGCATTCCGTTCGTGAACTTCTTCGATGGCTTTCGCACCAGCCACGAAATCCAGAAGATCGAGGTTCTGGAATATGAACAGCTGGCCACCTTGTTGGATCGTCCGGCCCTGGACAGCTTCCGCCGTAACGCCCTTCACCCGGACCACCCGGTCATCCGTGGCACCGCCCAGAACCCGGACATCTACT'}
obj['annotations'] << {:sequence => 'TCCAGGAACGTGAGG'}
obj['annotations'] << {:sequence => 'CCGGTA'}
obj['annotations'] << {:sequence => 'ACCGTTTCTATCAGGCGCTCCCGGATATTGTGGAATCTTACATGACCCAGATTTCTGCCCTGACTGGTCGCGAGTATCACCTGTTTAACTACACTGGTGCTGCGGATGCGGAGCGCGTGATCATCGCGATGGGCTCTGTCTGTGACACCGTCCAAGAGGTGGTTGACACGCTGAATGCAGCGGGTGAGAAAGTTGGTCTGCTCTCCGTTCATCTTTTCCGCCCGTTTTCGTTAGCGCACTTCTTCGCCCAACTGCCGAAAACTGTACAGCGTATCGCAGTATTGGACCGTACGAAAGAGCCAGGTGCTCAAGCAGAGCCGCTGTGCCTCGATGTGAAGAATGCCTTTTACCACCATGACGATGCCCCGTTGATTGTGGGTGGTCGCTATGCCTTGGGCGGTAAGGACGTGTTGCCGAACGATATTGCGGCCGTGTTTGATAACCTGAACAAACCGCTGCCGATGGACGGCTTCACGCTGGGTATCGTGGACGATGTTACCTTCACCTCTCTCCCGCCAGCGCAGCAGACCCTGGCGGTTTCTCACGACGGCATCACGGCATGTAAGTTTTGG'}

formatted_obj = format_annotated_sequence(obj,{ :size => 80, :delimiter => '<br/>'})
p formatted_obj['annotations'].map{|x| x[:delimited_sequence]}.join

