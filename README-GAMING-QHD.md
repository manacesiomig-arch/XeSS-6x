# Veyra — QHD / Gaming (base original 2.2.1)

Esta revisao parte do ZIP original fornecido, nao da versao RIFE experimental.
O FSR 3.1 e o fluxo optico permanecem intactos. O XeSS original 2X/3X/4X permanece
como modo normal; ha um experimento opt-in 5X/6X descrito abaixo. O RIFE original permanece
opcional e nao e instalado pelo build.

## Primeiro teste: sem compilar nada

- No Windows, confirme 2560 x 1440 e a maior frequencia efetivamente negociada (175 Hz se disponivel; a captura anterior mostrava 170 Hz).
- Na versao oficial que funciona: entrada 1920 x 1080 60 Hz SDR, tela cheia, fluxo optico, XeSS 4X para jogo de 30 FPS reais. Remova duplicatas somente se o conteudo for realmente 30 FPS. O redimensionamento final original usa amostragem de alta qualidade por padrao; FG nao precisa receber uma textura de SR QHD adicional. XeSS ainda usa seu swapchain de apresentacao e seu custo pode aumentar em tela cheia.
- Se o jogo tiver 60 FPS reais, desative a remocao 60->30 e teste XeSS 3X (180 FPS teoricos), ou FSR 3.1 2X (120 FPS teoricos). Se a fonte tiver apenas 30 FPS reais, XeSS 4X chega a 120, FSR 2X chega a 60. Repeticoes nao contam como quadros novos.
- Para testar QHD de processamento (maior custo): Qualidade > Super-resolucao > NVIDIA NIS > alvo 2K/1440p. Desative SR dupla. Compare com SR desligada em tela cheia; mantenha a opcao mais estavel.
- Para FSR: Tela > limite de saida > Personalizado > 172. O cap original descarta oportunidades atrasadas; nao aumenta a taxa gerada. O XeSS nao usa esse cap, pois o SDK controla as chamadas Present geradas.
- Para XeSS: teste no Painel de Controle NVIDIA > Gerenciar configuracoes 3D > Configuracoes de programa > veyra_qml_ui.exe > Taxa maxima de quadros = 172. Nao e garantia de limitar os Presents internos do XeSS. Confirme a taxa de saida e estabilidade, nao so a taxa de entrada. Se cair a taxa real ou aumentar a latencia, desative e compare. Nao altere configuracoes globais.

## O que muda nesta revisao

- Botao NIS QHD configura o algoritmo e o alvo 2560x1440 numa unica transacao, desativa SR dupla e conserva o estado do interruptor de SR. Ative SR manualmente se quiser processar em QHD.
- Atalhos 120/172 usam o limitador original, em uma transacao. Bloqueados quando FG XeSS esta selecionado/ativo. Sem promessa de cap interno XeSS.
- Rotulo 1440p no lugar de 2K; esclarecimento do limite nativo de cada motor.
- Corrigidos o identificador antigo no stub VFG e o empacotamento OpenSSL, problemas comprovados nos builds anteriores. Camera virtual e outros recursos originais foram preservados.
- Importador local dos runtimes oficiais que ja funcionam, com verificacao de arquivos e SHA256; nenhum download de DLL avulsa. O build nao distribui DLLs proprietarias dos provedores.

## Compilar (GitHub Actions)

Crie um repositorio novo a partir deste ZIP limpo, sem sobrepor os FIX antigos.
Envie os arquivos, incluindo .github, e execute Windows build (reproducible).
Baixe o artefato veyra-windows-ci-no-gpu-runtimes, extraia os dois ZIPs se necessario
em uma pasta nova. Rode Importar-Runtimes-Gaming.cmd ao lado do EXE. Informe a
pasta original oficial que possui runtime_local/intel/experimental e
runtime_local/amd/fidelityfx. Abra veyra_qml_ui.exe. Nao altere a instalacao original.

## Limites e validacao

FSR 3.1: um quadro intermediario por par, sem alteracoes. XeSS: 2X nativo e
3X/4X experimentais com identidade do DLL auditado no projeto original.

## Experimento XeSS 5X/6X (somente para teste)

O Veyra passa 4 ou 5 como numero de intermediarios ao desbloqueio existente,
consulta o provedor, configura a swapchain e chama SetNumInterpolatedFrames
com a quantidade solicitada. O controle de pacing original ja aceita ate cinco
intermediarios. Verificacoes de identidade, bytes esperados e rollback originais
permanecem. Para 5X/6X o modo tambem exige o hook de pacing instalado e rejeita
propriedades insuficientes. A Intel documenta ate 4X; os patches alteram inclusive
o teto informado pelo DLL. O retorno positivo dessas APIs NAO prova que o modelo
consegue gerar cinco quadros diferentes; estruturas internas podem limitar o
modelo ou causar falhas, artefatos, travamento ou reinicio do driver. Nao ha
validacao em Windows/GPU nesta entrega. Nao use este modo em sessao importante.

1. Compile e extraia em pasta nova. Importe os runtimes da instalacao oficial
   com Importar-Runtimes-Gaming.cmd. Nao altere a instalacao oficial.
2. Execute Iniciar-XeSS-6X-Experimental.cmd (variavel apenas neste processo).
3. Desative a selecao automatica de multiplicador. Escolha Intel XeSS e fluxo
   optico. Compare 4X, 5X EXP e 6X EXP em jogo de 30 FPS reais, SDR 1080p.
4. Confira FPS, 1% low, latencia e GPU; nos logs xess-fg, procure
   framesPresented e generatedTotal. Para 6X espera-se seis quadros por par
   em regime estavel, mas contadores do SDK nao sao medicao da tela.
5. Se houver erro, artefatos ou desempenho ruim, feche e abra o EXE normalmente
   (sem o CMD); o maximo normal continua 4X. Se necessario, escolha 4X manualmente.
   Guarde o log completo e mantenha a instalacao original para jogar.

O modo 5X/6X nao e escolhido pelo modo automatico. Nao promete 180 FPS nem
limite real de 172 FPS. O cap interno do Veyra continua inaplicavel ao XeSS.
O limite interno 172 nao opera no XeSS. O driver externo e um teste, nao uma
promessa de cap. 1.2/3.0 ms observados sao medidas do programa, nao latencia total.
O build completo Windows, o script PowerShell e desempenho GPU ainda precisam
ser testados em ambiente Windows; verificacoes locais de fonte e YAML nao
substituem esses testes.
