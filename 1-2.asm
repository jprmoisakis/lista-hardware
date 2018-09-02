.data #variaveis
x: .word 5
y: .word 2
z: .word 2
w: .word 1

.text
#carrego as variaveis
lw $s1,x
lw $s2,y
lw $s3,z

#somo as variaveis x e y  , x e z, y e z
add $s4,$s1,$s2  
add $s5,$s1,$s3
add $s6,$s2,$s3


#subtraio a soma dos outros dois para ver se é maior que o outro lado, sendo assim, triangulo, se nao, nao eh triangulo, faco o mesmo com as outras combinacoes
sub $s5,$s4,$s3
bgtz $s7,verif1
beqz $s7,naot
bltz $s7,naot

verif1:
sub $s6,$s5,$s2
bgtz $s7,verif2
beqz $s7,naot
bltz $s7,naot

verif2:
sub $s7,$6,$s1
bgtz $s7,verif2
beqz $s7,naot
bltz $s7,naot



#se nao for triangulo, salvo 1 em $5
naot:lw $5,w
j exit
#verifico se x=y, se sim, vou ver se x=z, EQUILATERO, se x!=y, vejamos se x=z, se sim, isosceles, se nao, vejamos se y=z, se sim, isosceles, se nao, escaleno.
O: beq $s1,$s2,iso
bne $s1,$s2,veryz
veryz: beq $s2,$s3, isosc
bne $s2,$s3,isoxz
isoxz: beq $s1,$s3,isosc
bne $s1,$s3, esca
iso:beq $s1,$s3,equila
bne $s1,$s3, isosc
isoz: beq $s1,$s3,isosc
bne $s1,$s2,esca
esca: lw $4,w
j exit
bne $s1,$s2,isosc
isosc: lw $3,w
j exit
equila:lw $2,w
j exit

exit:
