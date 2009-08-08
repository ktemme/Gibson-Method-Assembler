def molar_concentration(args={})
  (args[:conc].to_i*1e6/660/args[:size].to_i).round
end

def mix_ratios(input)
  result = []
  input.each do |m|
    data = input.reduce(0.to_f) do |sum, value|
      sum + m.to_f/value.to_f
    end
    result << data
  end
  result
end

def volumes(input)
  input.map{|x| (50/x).round.to_f/10}
end

def final_molarities(volumes,molarities)
  volumes.enum_with_index.map{|x,i| x*molarities[i]}
end