# http://codesnippets.joyent.com/posts/show/849
ENV['TEMP'] = Dir.pwd
ENV['TMP'] = Dir.pwd
SCRIPT_ROOT = File.dirname(__FILE__)


# def sortParts(hashedParts)
#   parts = hashedParts.map{|key,value| value}
#   parts.sort{|a,b| a['order'] <=> b['order']}
# end

def sortParts(hashedParts)
  parts = hashedParts.map{|key,value| value}
  parts.each do |part|
    part['sequence'] = part['rc'] == 'on' ? reversecomplement(part['sequence']) : part['sequence']
  end
  parts.sort{|a,b| a['order'] <=> b['order']}
end

def random_hex()
  color = '#'
  lib = "0123456789ABCDEF"
  6.times {
    i = rand(15)
    color += lib[i,1]
  }
  return color
end


def reversecomplement(sequence)
  sequence.reverse.tr('ACGTacgt','TGCAtgca')
end

def fullSequence(parts)
  result = parts.map{|x| x['sequence']}
  # result = parts.map{|x| x['rc'] == 'on' ? reversecomplement(x['sequence']) : x['sequence']}
  result.join
end

def annotatedSequence(parts)
  result = parts.map{|x| x['sequence']}
  result = result.join("</span><span style='background-color: #{random_hex()};'>")
  result = "<span style='background-color: #{random_hex()};'>" + result + "</span>"
end

def forward_primer(partID,parts)
  # p parts
# Expects an integer and an array of hashed parts [{part data},{part data},{part data}]
  prime = parts[partID-1]['fullsequence']
  part = parts[partID]['shortsequence']
  prefix = parts[partID]['fixedprefix'] ||= ''
  # p prime
  # p part
  # p prefix
  primer = prime[prime.size-20..prime.size] + prefix + part[0..39]
end

def reverse_primer(partID,parts)
# Expects an integer and an array of hashed parts [{part data},{part data},{part data}]
  if (partID+2 > parts.size)
     prime = parts[0]['fullsequence']
  else
     prime = parts[partID+1]['fullsequence']
  end
  part = parts[partID]['shortsequence']
  suffix = parts[partID]['fixedsuffix'] ||= ''
  primer = reversecomplement(part[part.size-40..part.size]+suffix+prime[0..19])
end

def findPrimers(parts)
  result = Array.new
  parts.each_with_index do |part,id|
    result << [part['name'],forward_primer(id,parts),reverse_primer(id,parts)]
  end
  result
end

def addLocations(parts)
  total_size = 0
	parts.each_with_index do |part,id| 

		parts[id]['start'] = total_size + 1 
		parts[id]['end'] = total_size + part['fullsequence'].size

		total_size += part['fullsequence'].size
	end
end


def findSequencingPrimers(seq, junctionArray)
  require 'tempfile'
  

  result = Array.new

  junctionArray.each_with_index do |junction, index|
    if index == junctionArray.size - 1
      wrapped_seq = seq[500..seq.size-1]+seq[0..499]
      
      # Need to wrap the sequence around at this point, and then find the last primer pair
      # tmpFil = Tempfile.new('data', File.join(SCRIPT_ROOT,'tmp'))
      tmpFil = File.join(SCRIPT_ROOT,'tmp',Time.now.to_i.to_s)
      # tFile = File.new(tmpFil.path, "w+")
      out = File.open(tmpFil, 'w')
        out.puts "SEQUENCE=#{wrapped_seq}\nTARGET=#{junction-500},100\nPRIMER_PRODUCT_SIZE_RANGE=500-1000\nPRIMER_NUM_RETURN=1\n="
      out.close
      sleep 3
  
      cmdline = "/Users/ktemme/Code/primer3/bin/primer3_core < #{tmpFil}"
      data = `#{cmdline}`.split"\n"  

      result << Hash.new
      data.each do |value|
        b,c = value.split('=')
        if b == "PRIMER_LEFT_SEQUENCE" || b == "PRIMER_RIGHT_SEQUENCE"
          result[index][b] = c
        end
      end
      
      
    else 
      tmpFil = Tempfile.new('data', 'tmp')
      tFile = File.new(tmpFil.path, "w+")
      tFile.puts "SEQUENCE=#{seq}\nTARGET=#{junction},100\nPRIMER_PRODUCT_SIZE_RANGE=500-1000\nPRIMER_NUM_RETURN=1\n="
      tFile.close
      sleep 3
  
      cmdline = "/Users/ktemme/Code/primer3/bin/primer3_core < #{tmpFil.path}"
      data = `#{cmdline}`.split"\n"  

      result << Hash.new
      data.each do |value|
        b,c = value.split('=')
        if b == "PRIMER_LEFT_SEQUENCE" || b == "PRIMER_RIGHT_SEQUENCE"
          result[index][b] = c
        end
      end
    end
  end
  
  result
end


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
