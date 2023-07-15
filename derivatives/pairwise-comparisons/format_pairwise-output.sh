#!/bin/bash

# Read .csv files
for comp in "doors-mid" "doors-social" "doors-sr" "doors-ugdg" "social-mid" "social-sr" "social-ugdg" "sr-mid" "ugdg-mid" "ugdg-sr"; do
	for hemi in "left" "right"; do
#		for stat in "tstat" "tstat_uncp" "tstat_fwep" "tstat_cfwep"; do
		for stat in "tstat_fwep"; do
#			for con in "1" "2" "3" "4"; do
			for con in "3" "4"; do
				INPUT=${comp}/${hemi}/${comp}_output_dat_${stat}_c${con}.csv
				OLDIFS=$IFS
				IFS=','
				[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
				while read IV V VI CrusI CrusII VIIb VIIIa VIIIb IX X VermisVI VermisVIIIa VermisVIIIb VermisIX
				do
					echo "INPUT : $INPUT"
					#echo "IV : $IV"
					echo "$IV"
					#echo "V : $V"
					echo "$V"
					#echo "VI : $VI"
					echo "$VI"
					#echo "Crus-I : $CrusI"
					echo "$CrusI"
					#echo "Crus-II : $CrusII"
					echo "$CrusII"
					#echo "VIIb : $VIIb"
					echo "$VIIb"
					#echo "VIIIa : $VIIIa"
					echo "$VIIIa"
					#echo "VIIIb : $VIIIb"
					echo "$VIIIb"
					#echo "IX : $IX"
					echo "$IX"
					#echo "X : $X"
					echo "$X"
					#echo "Vermis-VI : $VermisVI"
					echo "$VermisVI"
					#echo "Vermis-VIIIa : $VermisVIIIa"
					echo "$VermisVIIIa"
					#echo "Vermis-VIIIb : $VermisVIIIb"
					echo "$VermisVIIIb"
					#echo "Vermis-IX : $VermisIX"
					echo "$VermisIX"
				done < $INPUT
				IFS=$OLDIFS
			done
		done
	done
done
