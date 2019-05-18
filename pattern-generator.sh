#!/bin/bash

##
## Generate graphs that represents plausible chord structures
## with various starting chords.  Chords are generated
## by first generating a .dot file for graphviz to interpret,
## then graphviz parses these files and generate .pdf files.
##

##
## based on a graph I found in the book "Making music, 74 strategies
## for electronic music producers".
##


# Check for depenencies (in this case only one)

DEPENDENCIDES=dot
for DEP in $DEPENDENCIES ; do
    if [[ -z $(which $DEP) ]] ; then
	echo "Couldn't find dependency $DEP"
	exit 1
    fi
done



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
# Based no a label, find the corresponding dotfile and
# generate a pdf file.
#
makepdf() {
    local label=$1
    local dotfile="${label}_chords.dot"
    local pdffile="${label}_chords.pdf"

    makedotfile $2 $3 $4 $5 $6 $7 $8    > $dotfile
    dot -Tpdf $dotfile -o $pdffile
}

# The basic scales we're working with.  Uppercase
# characters designate major chords, lowercase characters
# designate minor chords.

makepdf  C  C  d  e   F  G   a  h
makepdf  F  F  g  a   B♭ C   d  e
makepdf  G  G  a  h   C  D   e  f♯
makepdf  Hb H♭ c  d   E♭ F   g  a
makepdf  A  A  h  c♯  D  E   f♯ g♯
makepdf  E  E  f♯ g♯  A  B♭  c♯ d♯

#
# and the abstract schema it's all based on
#
makepdf abtract I ii iii IV V vi vii
