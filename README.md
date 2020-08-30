# Diretorio verilog
Este repositório contém a implementação do protocolo de coerência de caches diretório

Com o avanço da tecnologia digital e o surgimento de processadores multicore tornou-se necessário aprimorar os protocolos de coerência de caches. Para analisar e compreender o funcionamento desse sistema desenvolvemos um processador de dois núcleos que utiliza o protocolo de coerência diretório na cache L2 e o protocolo snooping nas caches L1. O processador acompanha uma memória principal de 8 blocos.

O módulo principal (Diretorio) implementa dois módulos de cache L1 com 2 blocos de 8 bits, um módulo de cache L2 com 4 blocos de 8 bits e uma memória principal com 8 blocos de 8 bits. As caches L1 possuem a máquina de estados de protocolo MSI e a máquina de estados de diretório na cache L2. O processo de leitura e escrita de dados foi dividida em passos para facilitar a implementação. O primeiro passo consiste em enviar um comando de um dos núcleos para sua respectiva cache L1 e receber a resposta da cache ao comando. Durante o segundo passo as máquinas de estado das caches são atualizadas e, caso necessário, é realizado o write back de um dado. No terceiro passo as caches são atualizadas com os dados corretos dependendo do comando desejado.  

As máquinas de estados implementadas são representadas pelas figuras 1 (protocolo snooping) e 2 (protocolo diretório). Os dados de entrada para o programa são o comando desejado, qual núcleo que deve realizar o comando e um clock.

<img src="https://media.cheggcdn.com/media%2Fbad%2Fbad5ab11-6a94-473e-855e-16f03579eadf%2Fphp0bLywp.png" alt="Snooping" width="300" style="layout: inline-block"/>
<img src="https://slideplayer.com/slide/5868851/19/images/11/Write-Invalidate+Write-Back+Cache+Coherence+Protocol.jpg" alt="Diretório" width="300" style="layout: inline-block"/>

Como saída o módulo fornece o que ocorreu no bloco (hit ou miss) e a mensagem descrevendo o que deve ser comunicado às caches.

A representação de cada informação é ilustrado na tabela.

| Dado | Instrução | Núcleo | Estado        | Mensagem    |
|------|-----------|--------|---------------|-------------|
| 0    | Read      | P1     | Invalidate    | Nada        |
| 1    | Write     | P2     | Compartilhado | Write\-Miss |
| 2    | \-        | \-     | Modificado    | Read\-Miss  |
| 3    | \-        | \-     | \-            | Invalidate  |
