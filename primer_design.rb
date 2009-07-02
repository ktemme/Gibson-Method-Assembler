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
# Expects an integer and an array of hashed parts [{part data},{part data},{part data}]
  prime = parts[partID-1]['sequence']
  part = parts[partID]['sequence']
  primer = prime[prime.size-20..prime.size] + part[0..39]
end

def reverse_primer(partID,parts)
# Expects an integer and an array of hashed parts [{part data},{part data},{part data}]
  if (partID+2 > parts.size)
     prime = parts[0]['sequence']
  else
     prime = parts[partID+1]['sequence']
  end
  part = parts[partID]['sequence']
  primer = reversecomplement(part[part.size-40..part.size]+prime[0..19])
end

def findPrimers(parts)
  result = Array.new
  parts.each_with_index do |part,id|
    result << [forward_primer(id,parts),reverse_primer(id,parts)]
  end
  result
end