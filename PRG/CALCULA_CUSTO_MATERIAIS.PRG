xMaterial ='01232416'
xCor_material = '0006'
xCalcula = 0 
xSalva = 1 

***f_select("select material,cor_material,'%' as filial,0 as qtde,0 as valor from materiais_cores where material = ?xMaterial and cor_material = ?xCor_material","curEntMat")					
			
f_select("select distinct material,cor_material,'%' as filial,0 as qtde,0 as valor,0 as custo_calc from estoque_materiais where qtde_estoque>0","curEntMat")	

************INICIO CUSTO MEDIO MATERIAIS*********************

					text to	xselmov1 noshow	
						select a.*,sum(qtde_estoque) as qtde_estoque,0 as custo_calculado
						from 
						(select emissao,documento,material,cor_material,tipo,qtde,saldo,
						(valor) as valor_ent,
						convert(numeric(14,5),((valor)/qtde)) as valor_unit 
					endtext	


					Text to	xupd noshow				 
					   UPDATE Materiais_Cores    
					   set  custo_reposicao = convert(numeric(14,5),?xcustomedio),    
					   custo_a_vista = convert(numeric(14,5),?xcustomedio)    
					   WHERE Material=?curEntMat.material   
					   AND Cor_Material=?curEntMat.cor_material  
					Endtext		
					
					
					Sele curEntMat	
					go top	

					scan	
						
					f_prog_bar('Atualizando Pre�o Medio de Entrada do Material: '+allt(curEntMat.material)+'\'+allt(curEntMat.cor_material),recno(),reccount()) 
						
			
						xselmov2 = " from FX_ANM_Monta_Cardex_01 ('" +allt(curEntMat.material)+"' , '"+ ; 
	 		                                                allt(curEntMat.cor_material)+"' , '%' , NULL, 0) " + ;
						"where tipo='ENTRADA DE N.F.' and valor is not null  ) a " + ;
						"join estoque_materiais b  " + ;
						"on a.material=b.material and a.cor_material=b.cor_material " +;
						"group by emissao,documento,a.material,a.cor_material,tipo,qtde,saldo,valor_ent,valor_unit  "  
						

						if !f_select(xselmov1+xselmov2,"curCardex")
							messagebox('N�o foi p�ss�vel selecionar movimenta��o dos materiais !',32,'Aten��o_3 !!!')
							retu .f.
						endif		
						sele curCardex	
							xsaldoant		= 0
							xvalorant		= 0
							xvalorestapos	= 0
							xcustomedio	= 0
							xcustoant	= 0 
							xseq_calc                = 0  
						scan	
							xsaldoant		= iif( (curCardex.saldo-curCardex.qtde)<0,0,(curCardex.saldo-curCardex.qtde) )
							xvalorant		= xsaldoant * iif( (xseq_calc=0 and xsaldoant>0), curCardex.valor_unit , xcustoant )
							xvalorestapos	= curCardex.valor_ent+xvalorant
							xcustomedio	= xvalorestapos/iif(curCardex.saldo<=curCardex.qtde,curCardex.qtde,curCardex.saldo) 
							xcustoant	= xcustomedio 
							xseq_calc                = xseq_calc + 1 

						endscan							
						
						sele curEntMat	

						if xCalcula > 0
                                                                                                      if !f_update(xupd)	 
							messagebox('N�o foi p�ss�vel atualizar os custo medio dos materiais !',32,'Aten��o_4 !!!')
							retu .f.
						      endif	
						endif
                                                                              
                                                                                if xSalva > 0
                                                                                     Text to	xupd noshow				 
					            UPDATE temp_estoque_mat_calc    
					            set  custo_reposicao = convert(numeric(14,5),?xcustomedio)   
					            WHERE Material=?curEntMat.material   
					            AND Cor_Material=?curEntMat.cor_material  
					      Endtext	
                                                                                      f_update(xupd)
                                                                               endif
						sele curEntMat	

					endscan	
					f_prog_bar()	

				************FIM CUSTO MEDIO MATERIAIS*********************

Messagebox('Custo Atualizado com Sucesso!')