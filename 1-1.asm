.data   
  x : .word 7
  y : .word 11
  z : .word 0
  
.text
lw $s1,x
lw $s2,y
lw $s3,z
sub  $s0,$s1,$s2    #subtraio x de y
bgtz $s0,sety2      #se x-y>0 entao vamos shift right 2x o y e salvar em z
bltz $s0,setzy      #se x-y<0 entao vamos colocar y no z	
beqz $s0,setzy

sety2: srl $s3,$s2,2 #shift right 2x o y e salvar em z

setzy: lw $s3,y  #colocar y no z


