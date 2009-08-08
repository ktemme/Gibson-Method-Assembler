require 'quantification'

a = molar_concentration({:conc => 95, :size => 9000})
b = molar_concentration({:conc => 85, :size => 300})

molarities = [a,b]
ratios = mix_ratios(molarities)
volumes = volumes(ratios)
final_molarities = final_molarities(volumes,molarities)

p final_molarities