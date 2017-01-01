#!/bin/bash


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

# ♭ ♯

makepdf() {
    local label=$1
    local dotfile="${label}_chords.dot"
    local pdffile="${label}_chords.pdf"

    makedotfile $2 $3 $4 $5 $6 $7 $8    > $dotfile
    dot -Tpdf $dotfile -o $pdffile


}

# The basic scales we're working with

makepdf  C  C  d  e   F  G   a  h
makepdf  F  F  g  a   B♭ C   d  e
makepdf  G  G  a  h   C  D   e  f♯
makepdf  Hb H♭ c  d   E♭ F   g  a
makepdf  A  A  h  c♯  D  E   f♯ g♯
makepdf  E  E  f♯ g♯  A  B♭  c♯ d♯
