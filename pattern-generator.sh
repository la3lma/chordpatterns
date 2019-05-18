#!/bin/bash


## Copyright 2019 Bjørn Remseth (la3lma@gmail.com)
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.


##
## Generate graphs that represents plausible chord structures
## with various starting chords.  Chords are generated
## by first generating a .dot file for graphviz to interpret,
## then graphviz parses these files and generate .pdf files.
##

##
## based on a graph I found in the book "Making music, 74 strategies
## for electronic music producers" by Dennis DeSantis.
##

##
## Preliminaries (run before anythign else)
##

# Check for depenencies (in this case only one)


for DEP in dot; do
    echo "Checkcking dependency on $DEP"
    if [[ -z $(which $DEP) ]] ; then
	echo "Couldn't find dependency $DEP"
	exit 1
    fi
done


##
##  Prodcedures (used by the main program to do its job)
##


#
# output to the standard output a grapviz (dot) file
# generating a chord schema.
#
makedotfile() {
    local I=$1
    local ii=$2
    local iii=$3
    local IV=$4
    local V=$5
    local vi=$6
    local vii=$7

cat <<EOF


digraph G {

  compound=true;
  forcelabels=true;

  iii[label="iii: $iii"];
  vi[label="vi: $vi"];
  V[label="V: $V"];
  I[label="I: $I"];
  IV[label="IV: $IV"];
  vii[label="vii: $vii"];
  ii[label="ii: $ii"];



   subgraph cluster1 {
      IV  -> ii;
      color=blue
   }
   subgraph cluster2 {
      vii;
      V;
   }
   V -> vi [ltail=cluster2];
   ii-> vii [ltail=cluster1, lhead=cluster2];
   V   -> I [ltail=cluster2];
   IV  -> I [ltail=cluster1];
   iii -> vi;
   vi  -> ii [lhead=cluster1];
}
EOF
}


#
# Generate a dotfile for a particular label and put it in a file
# with the label used to generate the filename.
#
makedot() {
    local label=$1
    local dotfile=dot/"${label}_chords.dot"

    makedotfile $2 $3 $4 $5 $6 $7 $8    > $dotfile
}

##
##  Main program
##

RESULT_DIRECTORIES="pdf png dot"

# Empty or create result directories
echo "Clear or generate result directories"
for RESULT_DIR in $RESULT_DIRECTORIES ; do
    if [[ -d "$RESULT_DIR" ]] ; then
	echo "   .. clearing directory $RESULT_DIR"
	rm -f "$RESULT_DIR/*"
    else
	echo "   .. generating directory $RESULT_DIR"	
	mkdir -p "$RESULT_DIR"
    fi
done



# The basic scales we're working with.  Uppercase
# characters designate major chords, lowercase characters
# designate minor chords.
echo "Generating the chord schema dotfiles"
makedot  C  C  d  e   F  G   a  h
makedot  F  F  g  a   B♭ C   d  e
makedot  G  G  a  h   C  D   e  f♯
makedot  Hb H♭ c  d   E♭ F   g  a
makedot  A  A  h  c♯  D  E   f♯ g♯
makedot  E  E  f♯ g♯  A  B♭  c♯ d♯

#
# and the abstract schema it's all based on
#
makedot abtract I ii iii IV V vi vii


#
# Finally generate the pdf and  png files based on the
# dot files generated above.

echo "Generating output files "
for outFormat in pdf png ; do
    echo "... for $outFormat."
    for dotfile in dot/* ; do
	label=$(basename $dotfile .dot)
	outFile="${outFormat}/${label}_chords.${outFormat}"
	echo "   Converting $dotfile"
	echo " .. to $outFile"
	dot -T${outFormat} $dotfile -o $outFile
    done
done

echo "done"
