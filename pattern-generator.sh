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


makedotfile C  d e F  G a h    > c_chords.dot
dot -Tpdf c_chords.dot -o c_chords.pdf

makedotfile F  g a B♭ C d e    > f_chords.dot
dot -Tpdf f_chords.dot -o f_chords.pdf

makedotfile G  a h C  D e f♯   > g_chords.dot
dot -Tpdf g_chords.dot -o g_chords.pdf

makedotfile B♭ c d E♭ F g a    > Bb_chords.dot
dot -Tpdf Bb_chords.dot -o Bb_chords.pdf


