//Modulo principal
/*
Ação:
00 Write-Miss
01 Read-Miss
10 Write-Hit
11 Read-Hit

Estado: 
00 Uncached
01 Compartilhado
10 Modificado

MensagemIn:
000 Nada
001 Write-Miss
010 Read-Miss
011 Invalidate
100 Fetch
101 Reply
110 Write-Back
111 ______

Ouvinte:
0 Diretorio
1 Processador
*/

module Diretorio(MensagemOut,EstadoFinal,EstadoInicial,Acao,MensagemIn,Ouvinte,Clock,HEX0,HEX4,HEX5,HEX6,HEX7,KEY,LEDR,LEDG);

	input [1:0] Acao;
	input Clock;
	output reg [1:0] EstadoFinal;
	input [1:0] EstadoInicial;
	input [2:0] MensagemIn;
	output reg [2:0] MensagemOut;
	input Ouvinte;
	
	parameter AcaoWriteMiss=0;
	parameter AcaoReadMiss=1;
	parameter AcaoWriteHit=2;
	parameter AcaoReadHit=3;
	
	parameter Invalidate = 0;
	parameter WriteBack = 1;
	parameter Fetch = 2;
	parameter FetchInvalidate = 3;
	
	parameter MensagemNada = 0;
	parameter MensagemWriteMiss = 1;
	parameter MensagemReadMiss = 2;
	parameter MensagemInvalidate = 3;
	parameter MensagemFetch = 4;
	parameter MensagemReply = 5;
	parameter MensagemFetchInvalidate = 6;
	
	parameter EstadoUncached = 0;
	parameter EstadoCompartilhado = 1;
	parameter EstadoModificado = 2;
	
	output[6:0]HEX0,HEX4,HEX5,HEX6,HEX7;
	input [4:0] KEY;
	output [17:0] LEDR;
	output [7:0] LEDG;
	
	assign LEDG[0] = Clock;
	assign LEDR[2] = Ouvinte;
	
	display_7seg H7(EstadoInicial,HEX7);
	display_7seg H6(EstadoFinal,HEX6);
	display_7seg H5(MensagemIn,HEX5);
	display_7seg H4(MensagemOut,HEX4);
	display_7seg H0(Acao,HEX0);
	
	initial begin
		EstadoFinal = 0;
		MensagemOut = 0;
	end
	
	
	always@(posedge Clock)begin
		if(Ouvinte)
			case(EstadoInicial)
				EstadoUncached:begin//00 Uncached
					case(Acao)
						AcaoWriteMiss:begin
							EstadoFinal = EstadoModificado;
							MensagemOut = MensagemWriteMiss;
						end
						AcaoReadMiss:begin
							EstadoFinal = EstadoCompartilhado;
							MensagemOut = MensagemReadMiss;
						end
						AcaoWriteHit:begin
							//Não ocorre
						end
						AcaoReadHit:begin
							//Não ocorre
						end
					endcase
				end
				EstadoCompartilhado:begin//01 Compartilhado
					case(Acao)
						AcaoWriteMiss:begin
							EstadoFinal = EstadoModificado;
							MensagemOut = MensagemWriteMiss;
						end
						AcaoReadMiss:begin
							EstadoFinal = EstadoCompartilhado;
							MensagemOut = MensagemReadMiss;
						end
						AcaoWriteHit:begin
							EstadoFinal = EstadoModificado;
							MensagemOut = MensagemInvalidate;
						end
						AcaoReadHit:begin
							EstadoFinal = EstadoCompartilhado;
							MensagemOut = MensagemNada;
						end
					endcase
				end
				EstadoModificado:begin//10 Modificado
					case(Acao)
						AcaoWriteMiss:begin
							EstadoFinal = EstadoModificado;
							MensagemOut = MensagemFetchInvalidate;
						end
						AcaoReadMiss:begin
							EstadoFinal = EstadoCompartilhado;
							MensagemOut = MensagemReadMiss;
						end
						AcaoWriteHit:begin
							EstadoFinal = EstadoModificado;
							MensagemOut = MensagemNada;
						end
						AcaoReadHit:begin
							EstadoFinal = EstadoModificado;
							MensagemOut = MensagemNada;
						end
					endcase
				end
			endcase
		else
			case(EstadoInicial)
				EstadoUncached:begin//00 Uncached
					//nada
				end
				EstadoCompartilhado:begin//01 Compartilhado
					case(MensagemIn)
						MensagemInvalidate:begin
							EstadoFinal = EstadoUncached;
						end
						MensagemFetch:begin
							//Não ocorre
						end
						MensagemFetchInvalidate:begin
							//Não ocorre
						end
					endcase
				end
				EstadoModificado:begin//10 Modificado
					case(MensagemIn)
						MensagemInvalidate:begin
							//Não ocorre
						end
						MensagemFetch:begin
							EstadoFinal = EstadoCompartilhado;
						end
						MensagemFetchInvalidate:begin
							EstadoFinal = EstadoUncached;
						end
					endcase
				end
			endcase
		end
endmodule
