programa
{
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> t
	inclua biblioteca Util --> u
	inclua biblioteca Mouse --> m
	inclua biblioteca Sons--> s
	inclua biblioteca Arquivos --> a
	inclua biblioteca Tipos --> tp
	inclua biblioteca Texto --> tx

	//Declaração de variáveis, matrizes e vetores, responsáveis por controlar o estado do sistema, interação do jogador e armazenar informações relevantes para o quiz
	
	logico 
		arquivoCarregado = falso, telaTemas = falso, telaJogo = falso, ImagensCarregadas = falso    
	inteiro 
		refImagem = 0, botao[4], posAlternativas[4], temasCarregados = 0, perguntasEscolhidas, posVertical = 0, refArquivo, numLinhas = 0, perguntasCarregadas = 0, acertos = 0, perguntaAtual = 0
	cadeia 
		arquivo_extensao [] = {"Arquivos de texto|txt"}, arquivo_endereco, temaEscolhido = "", Arquivo[100][7], respostas[10], perguntasNomes [10][6], temasNomes [10]
	
	//se(m.ler_botao() == m.BOTAO_MEIO)
	//escreva("X: ", m.posicao_x(), " Y: ", m.posicao_y(), "\n")   --> Comando para verificar a posição dos objetos em cena, usado na criação de botões
	
	//Início do programa
	funcao inicio()
	{

		//Reproduz a música e define o volume
		s.reproduzir_som(s.carregar_som("./Música.mp3"), verdadeiro)
		s.definir_volume(50)

		//Inicializa o sistema gráfico
		inicializar()

		//Loop principal do jogo, verificando e controlando a tela atual
		enquanto(verdadeiro)
		{
			//Apresenta a tela de menu
			se ( telaTemas == falso e telaJogo == falso )
			{
				desenhar_menu()
				controles_menu()
			}
			
			//Apresenta a tela de seleção de temas
			se ( telaTemas == verdadeiro e telaJogo == falso )
			{
				desenhar_telaTemas()
				controles_temas()
			}
			
			//Apresenta a tela de seleção de número de questões a serem respondidas
			se ( telaTemas == verdadeiro e telaJogo == verdadeiro )
			{
				desenhar_perguntasNum()
			}
			
			//Apresenta a tela de jogo
			se (telaTemas == falso e telaJogo == verdadeiro)
			{
				desenhar_telaJogo()
			}

		//Renderiza as imagens na tela.
		g.renderizar()
		}
	}
	
	//Função responsável por controlar as interações do menu
	funcao controles_menu()
	{	
		//Verifica se a tecla ESC foi pressionada ou se o botão esquerdo do mouse foi clicado na área do botão sair
		se(t.tecla_pressionada(t.TECLA_ESC) ou mouse(674, 843, 530, 122) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			g.fechar_janela()
		}

		//Verifica se o arquivo não foi carregado e se o botão esquerdo do mouse foi clicado na área do botão procurar
		se(arquivoCarregado == falso e mouse(674, 643, 530, 122) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			//Seleciona um arquivo através de uma janela
			arquivo_endereco = a.selecionar_arquivo(arquivo_extensao, falso)

			//Verifica se nenhum arquivo tiver sido carregado
			se(arquivo_endereco != "")
			{
				// Abre o arquivo, lê seu conteúdo e armazena na matriz Arquivo
				refArquivo = a.abrir_arquivo(arquivo_endereco, a.MODO_LEITURA)
				ler_arquivo(Arquivo)
			}
		}

		//Verifica se o arquivo já foi carregado e está na tela menu, para assim poder ir para a próxima tela
		se(arquivoCarregado == verdadeiro e mouse(674, 643, 530, 122) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			telaTemas = verdadeiro
		}
	}

	//Função responsável por controlar as interações da tela de temas
	funcao controles_temas()
	{
		//Interação do mouse para escolher um tema
		selecionar_tema()

		//Verifica se a tecla ESC foi pressionada ou se o botão esquerdo do mouse foi clicado na área do botão voltar
		se(mouse(141, 894, 300, 137) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou t.tecla_pressionada(t.TECLA_ESC))
		{	
			//Libera a memória das imagens utilizadas
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			//Carrega novamente as imagens e retorna a tela menu
			carregar_menu()
			g.limpar()
			telaTemas = falso
			ImagensCarregadas = falso
		}	
	}
	
	//Função responsável por ler um arquivo de texto e armazenar as informações em uma matriz
	funcao ler_arquivo(cadeia &dado[][])
	{
		cadeia linha, coluna
		inteiro temaCategoria = 0, posicaoInicial = 0, posicaoFinal = 0

		//Enquanto não atingir o final do arquivo, ler cada linha
		enquanto (nao a.fim_arquivo(refArquivo))
		{
			//Se o número de perguntas for maior que 100 ou o número de temas maior do que 10, o sistema não aceitará o arquivo
			se(numLinhas > 100 ou temasCarregados > 9)
			{
				g.definir_tamanho_texto(40.0)
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(300, 550, "Arquivo de Texto ultrapassa 100 perguntas ou 10 temas, escolha novamente!")
				g.renderizar()
				u.aguarde(2500)
				arquivoCarregado = falso
				pare
			}
			senao
				arquivoCarregado = verdadeiro
			
			linha = a.ler_linha(refArquivo)
			
			se(linha != "")
			{
				//Extrai e armazena a pergunta
				posicaoFinal = tx.posicao_texto(" | ", linha, 0)
				dado[numLinhas][0] =  tx.extrair_subtexto(linha, posicaoInicial, posicaoFinal)		//PERGUNTA

				//Atualiza as posições inicial e final para a próxima extração
				posicaoInicial = posicaoFinal+1
				posicaoFinal = tx.posicao_texto(" | ", linha, posicaoInicial)

				//Extrai e armazena o tema
				dado[numLinhas][1] =  tx.extrair_subtexto(linha, posicaoInicial+2, posicaoFinal)	//TEMA

				//Verifica para armazenar cada tema uma única vez
				se(numLinhas == 0 )
				{
					temasCarregados = temasCarregados + 1
					temasNomes[temasCarregados-1] = dado[numLinhas][1]
				}
				senao se(dado[numLinhas][1] != dado[numLinhas-1][1])
				{
					temasCarregados = temasCarregados + 1
					temasNomes[temasCarregados-1] = dado[numLinhas][1]
				}

				//Extrai e armazena a resposta da pergunta
				posicaoInicial = posicaoFinal+1
				posicaoFinal = tx.posicao_texto(" | ", linha, posicaoInicial)
				dado[numLinhas][2] =  tx.extrair_subtexto(linha, posicaoInicial+2, posicaoFinal)	//RESPOSTA

				//Extrai e armazena as alternativas da pergunta
				posicaoInicial = posicaoFinal+1
				posicaoFinal = tx.posicao_texto(" | ", linha, posicaoInicial)
				dado[numLinhas][3] =  tx.extrair_subtexto(linha, posicaoInicial+2, posicaoFinal)	//ALTERNATIVA 1
		
				posicaoInicial = posicaoFinal+1
				posicaoFinal = tx.posicao_texto(" | ", linha, posicaoInicial)
				dado[numLinhas][4] =  tx.extrair_subtexto(linha, posicaoInicial+2, posicaoFinal)	//ALTERNATIVA 2
		
				posicaoInicial = posicaoFinal+1
				posicaoFinal = tx.posicao_texto(" | ", linha, posicaoInicial)
				dado[numLinhas][5] =  tx.extrair_subtexto(linha, posicaoInicial+2, posicaoFinal)	//ALTERNATIVA 3
	
				posicaoInicial = posicaoFinal+1
				dado[numLinhas][6] =  tx.extrair_subtexto(linha, posicaoInicial+2, tx.numero_caracteres(linha))	//ALTERNATIVA 4
				
				//Reinicia as posições inicial e final para a próxima linha
				posicaoInicial = 0
				posicaoFinal = 0
				//Incremento no número de linhas lidas
				numLinhas = numLinhas+1
			}
		}
		a.fechar_arquivo(refArquivo)
	}
	
	//Função que verifica se o cursor do mouse está dentro de uma determinada área retangular
	funcao logico mouse(inteiro x, inteiro y, inteiro largura, inteiro altura)
	{
		se(m.posicao_x() >= x e m.posicao_y() >= y e m.posicao_x() <= x+largura e m.posicao_y() <= y+altura)
		{
			retorne verdadeiro
		}
		senao
		{
			retorne falso
		}
	}

	//Função que inicia o sistema gráfico
	funcao inicializar()
	{
		g.iniciar_modo_grafico(verdadeiro)
		g.entrar_modo_tela_cheia()
		g.definir_titulo_janela("Será que sabe?")
		g.limpar()		
		carregar_menu()
		g.renderizar()

	}

	//Função que carrega as imagens usadas no menu
	funcao carregar_menu()
	{
		g.carregar_fonte("./Raleway.ttf")
		refImagem = g.carregar_imagem("./Menu.jpeg")
		botao[0] = g.carregar_imagem("./botao_sair.png")	
		botao[1]  = g.carregar_imagem("./botao_procurar.png")
		botao[2] = g.carregar_imagem("./botao_jogar.png")
	}

	//Função que desenha as imagens usadas no menu
	funcao desenhar_menu()
	{	
		g.desenhar_imagem(0, 0, refImagem) 	//Imagem de Fundo
		g.desenhar_imagem(625, 800, botao[0]) 	//Botão Sair
		
		se(arquivoCarregado == falso)
		{
			g.desenhar_imagem(625, 600, botao[1])  //Botão Procurar Arquivo
		}
		senao
		{
			g.desenhar_imagem(625, 600, botao[2]) //Botão Jogar
		}
	}

	//Função que desenha as imagens usadas na tela de seleção de temas
	funcao desenhar_telaTemas()
	{
		se(ImagensCarregadas == falso)
		{
			g.liberar_imagem(botao[0])	//botão "Sair"
			g.liberar_imagem(botao[1])	//botão "Procurar Arquivo"
			g.liberar_imagem(botao[2])	//botão "Jogar"
			
			botao[0] = g.carregar_imagem("./botao_tema.png")
			botao[3] = g.carregar_imagem("./botao_voltar.png")
			refImagem = g.carregar_imagem("./telaTemas.jpg")	
	
			ImagensCarregadas = verdadeiro
		}

		g.desenhar_imagem(0, 0, refImagem)
		g.desenhar_imagem(100,850, botao[3])
		escrever_temas()
	}

	//Função que escreve os nomes dos temas nos botões
	funcao escrever_temas()
	{
		inteiro posicao_x = 460, posicao_y = 190
		inteiro contador = 0
		g.definir_fonte_texto("")

		//Loop para percorrer os temas carregados
		para(contador = 0; contador < temasCarregados; contador++)
		{
			g.desenhar_imagem(posicao_x, posicao_y, botao[0])
			g.definir_cor(g.COR_BRANCO)
			g.definir_tamanho_texto(30.0)
			
			// Verifica o tamanho do nome do tema e ajusta o tamanho do texto para o primeiro botão
			se(tx.numero_caracteres(temasNomes[contador]) > 22)
			{
				g.definir_tamanho_texto(28.0)
				g.desenhar_texto(posicao_x+65, posicao_y+67, temasNomes[contador])
			}
			senao
				g.desenhar_texto(posicao_x+103, posicao_y+67, temasNomes[contador])
				
			//Atualiza a posição x para desenhar o próximo botão e aumenta o contador
			posicao_x = posicao_x + 470
			contador++
			se(contador == temasCarregados)
				pare
			g.desenhar_imagem(posicao_x, posicao_y, botao[0])
			g.definir_cor(g.COR_BRANCO)
			
			//Verifica o tamanho do nome do tema e ajusta o tamanho do texto para o segundo botão
			se(tx.numero_caracteres(temasNomes[contador]) > 22)
			{
				g.definir_tamanho_texto(28.0)
				g.desenhar_texto(posicao_x+65, posicao_y+67, temasNomes[contador])
			}
			senao
				g.desenhar_texto(posicao_x+103, posicao_y+67, temasNomes[contador])

			//Desce a posição Y para baixo e retorna a posição X para a posição inicial	
			posicao_y = posicao_y + 140
			posicao_x = 460
		}
	}

	//Função que desenha a tela de número de perguntas a serem escolhidas pelo jogador
	funcao desenhar_perguntasNum()
	{
		//Carrega recursos de imagem e texto
		se(ImagensCarregadas == falso)
		{
			botao[3] = g.carregar_imagem("./botao_voltar.png")
			refImagem = g.carregar_imagem("./PerguntasNum.jpg")
			g.definir_cor(g.COR_PRETO)
			g.definir_fonte_texto("Raleway Thin")
			ImagensCarregadas = verdadeiro
		}
		
		g.desenhar_imagem(0, 0, refImagem)
		g.definir_tamanho_texto(54.0)
		
		//Verifica o tamanho do nome do tema e quebra em várias linhas se necessário
		se(tx.numero_caracteres(temaEscolhido) > 14)
			quebra_linha(temaEscolhido, 14, 700, 120, 70 ,45.0, 38.0)
		senao
			g.desenhar_texto(710, 180, temaEscolhido)

		g.definir_tamanho_texto(54.0)
		g.desenhar_texto(1118, 180, tp.inteiro_para_cadeia((perguntasCarregadas), 10))
		g.desenhar_imagem(100,850, botao[3])
		
		//Função de interação do mouse para selecionar a quantidade de perguntas
		selecionar_perguntas()	
	}

	//Função que carrega todas as perguntas de um determinado tema, junto das respostas e alternativas
	funcao carregar_perguntas(cadeia tema)
	{
		para(inteiro contador = 0; contador < numLinhas; contador++)
		{
			//Se o tema selecionado for igual ao valor da matrix
			se(tema == Arquivo[contador][1])
			{
				//Se o número de perguntas carregadas for maior do que 10, o sistema não carregará as outras
				se(perguntasCarregadas > 9)
				{
					g.definir_tamanho_texto(40.0)
					g.definir_fonte_texto("Raleway Thin")
					g.definir_cor(g.COR_PRETO)
					g.desenhar_texto(250, 150, "Esse tema possui mais perguntas do que o permitido, apenas 10 serão carregadas!")
					g.renderizar()
					u.aguarde(2500)
					arquivoCarregado = falso
					pare
				}
				perguntasNomes[perguntasCarregadas][0] = Arquivo[contador][0]
				perguntasNomes[perguntasCarregadas][1] = Arquivo[contador][2]
				perguntasNomes[perguntasCarregadas][2] = Arquivo[contador][3]
				perguntasNomes[perguntasCarregadas][3] = Arquivo[contador][4]
				perguntasNomes[perguntasCarregadas][4] = Arquivo[contador][5]
				perguntasNomes[perguntasCarregadas][5] = Arquivo[contador][6]
				perguntasCarregadas = perguntasCarregadas + 1
			}
		}
	}
	
	//Função que seleciona o tema quando o jogador clica em um botão de tema
	funcao selecionar_tema()
	{
		se(mouse(497, 223, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > -1)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[0]
			carregar_perguntas(temasNomes[0])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(967, 223, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 0)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[1]
			carregar_perguntas(temasNomes[1])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(497, 373, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 2)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[2]
			carregar_perguntas(temasNomes[2])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(967, 373, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 3)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[3]
			carregar_perguntas(temasNomes[3])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}
		
		se(mouse(497, 513, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 4)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[4]
			carregar_perguntas(temasNomes[4])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(967, 513, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 5)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[5]
			carregar_perguntas(temasNomes[5])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(497, 653, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 6)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[6]
			carregar_perguntas(temasNomes[6])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(967, 653, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 7)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[7]
			carregar_perguntas(temasNomes[7])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(497, 793, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 8)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[8]
			carregar_perguntas(temasNomes[8])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}

		se(mouse(967, 793, 408, 95) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) e temasCarregados > 9)
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			temaEscolhido = temasNomes[9]
			carregar_perguntas(temasNomes[9])
			sorteio_perguntas(perguntasNomes, perguntasCarregadas, 6)
			telaJogo = verdadeiro
			ImagensCarregadas = falso
		}
	}

	//Função que seleciona a quantidade de perguntas a serem respondidas quando o jogador clica em um botão de número
	funcao selecionar_perguntas()
	{
		//Voltar para a tela de temas
		se(mouse(141, 894, 300, 137) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou t.tecla_pressionada(t.TECLA_ESC))
		{
			g.liberar_imagem(refImagem)
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])
			g.liberar_imagem(botao[2])
			g.liberar_imagem(botao[3])
			telaTemas = verdadeiro
			telaJogo = falso
			ImagensCarregadas = falso
			perguntasCarregadas = 0
			limpar_matriz(perguntasNomes)
		}	
	
		//Verificação se o número de perguntas escolhidas corresponde ao número de perguntas carregadas, lógica que se aplica a todos os botões	
		se(mouse(511, 454, 105, 105) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			se (perguntasCarregadas > 4)
			{
				perguntasEscolhidas = 5
				telaTemas = falso
				ImagensCarregadas = falso
			}
				
			senao
			{
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(600, 700, "Número de perguntas inválido!")
				g.renderizar()
				u.aguarde(1000)
			}
		}

		
		se(mouse(657, 454, 105, 105) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			
			se (perguntasCarregadas > 5)
			{
				perguntasEscolhidas = 6
				telaTemas = falso
				ImagensCarregadas = falso
			}
			
			senao
			{
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(600, 700, "Número de perguntas inválido!")
				g.renderizar()
				u.aguarde(1000)
			}
		}

		se(mouse(815, 454, 105, 105) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			se (perguntasCarregadas > 6)
			{
				perguntasEscolhidas = 7
				telaTemas = falso
				ImagensCarregadas = falso
			}
			senao
			{
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(600, 700, "Número de perguntas inválido!")
				g.renderizar()
				u.aguarde(1000)
			}
		}

		se(mouse(975, 454, 105, 105) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{	
			se (perguntasCarregadas > 7)
			{
				perguntasEscolhidas = 8
				telaTemas = falso
				ImagensCarregadas = falso
			}
			senao
			{
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(600, 700, "Número de perguntas inválido!")
				g.renderizar()
				u.aguarde(1000)
			}
		}
		
		se(mouse(1132, 454, 105, 105) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			se (perguntasCarregadas > 8)
			{
				perguntasEscolhidas = 9
				telaTemas = falso
				ImagensCarregadas = falso
			}
			senao
			{
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(600, 700, "Número de perguntas inválido!")
				g.renderizar()
				u.aguarde(1000)
			}
		}

		se(mouse(1287, 454, 105, 105) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			se (perguntasCarregadas > 9)
			{
				perguntasEscolhidas = 10
				telaTemas = falso
				ImagensCarregadas = falso
			}
			senao
			{
				g.definir_fonte_texto("Raleway Thin")
				g.desenhar_texto(600, 700, "Número de perguntas inválido!")
				g.renderizar()
				u.aguarde(1000)
			}
		}
	}

	//Função para quebrar um texto em ambiente gráfico, além de permitir a escolha do tamanho da fonte, da posição do texto, etc.
	funcao quebra_linha(cadeia texto, inteiro letrasPorLinha, inteiro posicaoX, inteiro posicaoY,inteiro pos_proximaLinha,real fonte, real fonte2) 	
	{
    		g.definir_tamanho_texto(fonte)
    		inteiro posicaoInicial = 0
    		inteiro posicaoFinal = letrasPorLinha

    		se(tx.numero_caracteres(texto) >= letrasPorLinha)
    		{
	    		enquanto (posicaoInicial < tx.numero_caracteres(texto))
	    		{
		        	//Verifica se há um espaço em 5 caracteres antes da posição final
		        	inteiro posEspaco = posicaoFinal - 5
		        	se (posEspaco > posicaoInicial)
		        	{
		            	posEspaco = tx.posicao_texto(" ", texto, posEspaco)
		            	se (posEspaco >= posicaoInicial)
		            	{
		                	posicaoFinal = posEspaco
		            	}
		        	}

				// Verifica se a posição final ultrapassou o tamanho do texto
				se (posicaoFinal >= tx.numero_caracteres(texto))
		       	{
		          	posicaoFinal = tx.numero_caracteres(texto)
		        	}
		        	
		        	//Extrai a parte do texto até a posição final
		        	cadeia linhaTexto = tx.extrair_subtexto(texto, posicaoInicial, posicaoFinal)
		
		    	    	//Desenha a linha de texto
		      	g.desenhar_texto(posicaoX, posicaoY, linhaTexto)
		
		        	//Atualiza as posições para a escrita na tela da próxima linha
		        	posicaoY = posicaoY + pos_proximaLinha
		        	posVertical = posVertical + pos_proximaLinha -2  //Variável usada para ajustar a posição dos textos na tela pós jogo
		
		        	//Atualiza as posições para a extração da próxima linha
		        	posicaoInicial = posicaoFinal + 1
		        	posicaoFinal = posicaoInicial + letrasPorLinha - 1
	    		}
    		}
    		//Se o texto for menor do que o número de caracteres permitidos por linha:
    		senao
    		{
			posVertical = posVertical + pos_proximaLinha -2
    			g.definir_tamanho_texto(fonte2)
    			g.desenhar_texto(posicaoX, posicaoY, texto)
    		}
	}

	//Função para sortear a ordem de apresentação das perguntas
	funcao sorteio_perguntas(cadeia matriz[][], inteiro tamanho, inteiro colunas)
	{
		//Vetor temporário para armazenar os valores durante a troca
    		cadeia temp[6]

	    	para (inteiro i = 0; i < tamanho - 1; i++)
	    	{
	     	//Sorteia um índice aleatório para realizar a troca
	     	inteiro indice = sorteia(0, tamanho - 1)
	
	        	para (inteiro j = 0; j < colunas; j++)
	        	{
	          	temp[j] = matriz[i][j] 	//Armazena o valor atual na posição 'temp'
	            	matriz[i][j] = matriz[indice][j] 	//Realiza a troca dos valores
	            	matriz[indice][j] = temp[j]	//Atribui o valor armazenado em 'temp' para a posição de destino
	        	}
	    	}
	}

	//Função para limpar os valores de uma matriz
	funcao limpar_matriz(cadeia matriz[][])
	{
    		para (inteiro i = 0; i < u.numero_colunas(matriz); i++)
    		{
        		para (inteiro j = 0; j < u.numero_linhas(matriz); j++)
        		{
        			matriz[j][i] = "" //Atribui valor vazio a todos os espaços da matriz
        		}
    		}
	}

	//Função que realiza o funcionamento do quiz
	funcao desenhar_telaJogo()
	{	
		//Carrega as imagens dos botões e define a fonte do texto		
		se(ImagensCarregadas == falso)
		{
			botao[0] = g.carregar_imagem("./botao_aceitar2.png")
			botao[1] = g.carregar_imagem("./botao_rejeitar2.png")
			g.definir_fonte_texto("Raleway Thin")
			ImagensCarregadas = verdadeiro
		}
		
		//Loop principal do jogo, enquanto a pergunta atual for menor que o número de perguntas escolhidas
		enquanto (perguntaAtual < perguntasEscolhidas)
		{	
			posVertical = 600
			g.definir_cor(g.COR_BRANCO)
			g.limpar()
			g.definir_cor(g.COR_PRETO)
			g.definir_tamanho_texto(54.0)
			
			// Desenha o número da pergunta
			g.desenhar_texto(110, 180, "Pergunta "+(perguntaAtual+1)+".")

			//Loop para desenhar as alternativas da pergunta
			para(inteiro contador = 2; contador < 6; contador++)
			{
				g.definir_cor(g.COR_PRETO)

				//Se o mouse estiver sobre a alternativa, ela mudará de cor para azul
				se(mouse(185, 600, g.largura_texto(perguntasNomes[perguntaAtual][contador]), 37) == verdadeiro e contador == 2)
				{
					g.definir_cor(g.COR_AZUL)
					g.desenhar_texto(140, posVertical, (contador-1) + ". " + perguntasNomes[perguntaAtual][contador])	
				}
				senao se (mouse(185, 700, g.largura_texto(perguntasNomes[perguntaAtual][contador]), 37) == verdadeiro e contador == 3)
				{
					g.definir_cor(g.COR_AZUL)
					g.desenhar_texto(140, posVertical, (contador-1) + ". " + perguntasNomes[perguntaAtual][contador])	
				}
				
				senao se(mouse(185, 800, g.largura_texto(perguntasNomes[perguntaAtual][contador]), 37) == verdadeiro e contador == 4)
				{
					g.definir_cor(g.COR_AZUL)
					g.desenhar_texto(140, posVertical, (contador-1) + ". " + perguntasNomes[perguntaAtual][contador])
				}
				
				senao se(mouse(185, 900, g.largura_texto(perguntasNomes[perguntaAtual][contador]), 37) == verdadeiro e contador == 5)
				{
					g.definir_cor(g.COR_AZUL)
					g.desenhar_texto(140, posVertical, (contador-1) + ". " + perguntasNomes[perguntaAtual][contador])
				}
				//Caso não esteja sobre nenhuma delas, desenha a alternativa em cor preta
				senao
					g.desenhar_texto(140, posVertical, (contador-1) + ". " + perguntasNomes[perguntaAtual][contador])

				//Armazena o tamanho de cada texto para realizar a verificação da posição do mouse sobre eles
				posAlternativas[0] = g.largura_texto(perguntasNomes[perguntaAtual][2])
				posAlternativas[1] = g.largura_texto(perguntasNomes[perguntaAtual][3])
				posAlternativas[2] = g.largura_texto(perguntasNomes[perguntaAtual][4])
				posAlternativas[3] = g.largura_texto(perguntasNomes[perguntaAtual][5])
				
				posVertical = posVertical + 100
			}

			//Desenha o texto da pergunta atual
			g.definir_cor(g.COR_PRETO)
			quebra_linha(perguntasNomes[perguntaAtual][0], 102, 110, 250, 70, 36.0, 38.0)
			g.renderizar()

			//Função que controla a interação do usuário com o jogo
			controles_telaJogo()
		}
		//Função que apresenta a tela de conclusão após o fim do jogo
		fim_de_jogo()
	}

	//Função que apresenta a tela de conclusão de jogo, verificando quais perguntaso jogador acertou e se ele quer jogar novamente ou fechar o jogo
	funcao fim_de_jogo()
	{
		g.definir_cor(g.COR_BRANCO)
		g.limpar()
		posVertical = 50

		//Loop para exibir as perguntas e respostas
		para(inteiro contador = 0; contador < perguntasEscolhidas; contador++)
		{	
			
			//Escreve o texto da pergunta
			g.definir_cor(g.COR_PRETO)
			quebra_linha(contador + 1 + ". " + perguntasNomes[contador][0], 92, 90, posVertical-10, 30 , 26.0, 26.0)

			//Verifica se a resposta está correta baseado no número da coluna resposta + 1
			se(respostas[contador] == perguntasNomes[contador][1+tp.cadeia_para_inteiro((perguntasNomes[contador][1]), 10)])
			{	
				g.definir_cor(g.COR_VERDE)
				quebra_linha(" R: "+respostas[contador], 70, 92, posVertical-2, 65, 20.0, 20.0)
			}
			
			senao
			{
				g.definir_cor(g.COR_VERMELHO)
				quebra_linha(" R: "+respostas[contador], 70, 92, posVertical-2, 65, 20.0, 20.0)
				g.definir_cor(g.COR_VERDE)
				quebra_linha(perguntasNomes[contador][1+tp.cadeia_para_inteiro((perguntasNomes[contador][1]), 10)], 70, 720, posVertical-65, 0, 20.0, 20.0)
			}	
		}
		//Exibe o número de acertos e erros
		g.definir_tamanho_texto(45.0)
		g.definir_cor(g.COR_VERDE)
		g.desenhar_texto(1500, 100, "Acertos: " + acertos)
		g.definir_cor(g.COR_VERMELHO)
		g.desenhar_texto(1500, 150, "Erros: " + (perguntasEscolhidas-acertos))

		//Calcula e exibe a porcentagem de acertos
		g.definir_cor(g.COR_PRETO)
		quebra_linha("Porcentagem de Acertos: " + acertos*100/perguntasEscolhidas+ ".00 %", 12, 1500, 300, 50, 45.0, 45.0)

		//Desenha os botões de aceitar ou recusar jogar noamente
		g.definir_tamanho_texto(40.0)
		g.desenhar_texto(1400, 550, "Deseja jogar novamente?")
		g.desenhar_imagem(1490, 650, botao[0])
		g.desenhar_imagem(1490, 800, botao[1])

		//Verifica se o botão "Aceitar" foi pressionado
		se(mouse(1493, 611, 272, 100) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			//Libera a memória das imagens dos botões
			g.liberar_imagem(botao[0])
			g.liberar_imagem(botao[1])

			//Reinicia as variáveis para um novo jogo
			perguntasCarregadas = 0
			perguntaAtual = 0
			acertos = 0

			//Carrega as imagens do menu inicial
			carregar_menu()
			
			g.limpar()
			telaTemas = falso
			telaJogo = falso
			ImagensCarregadas = falso
		}

		// Verifica se o botão "Rejeitar" foi pressionado ou se a tecla Esc foi pressionada, fechando o programa
		se(mouse(1493, 807, 272, 97) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou t.tecla_pressionada(t.TECLA_ESC))
		{
			g.fechar_janela()
		}
	}
	
	//Função que realiza a interação do jogador com o quiz	
	funcao controles_telaJogo()
	{
		//Verifica se a pergunta atual é menor que 10 (para garantir que ainda há perguntas restantes)
		se(perguntaAtual < 10)
		{
			//Verifica se uma alternativa foi selecionada pelo mouse ou pelo tecla numérica correspodente, além de verificara se a resposta está correta, incrementando o contador de acertos
			se(mouse(185, 600, posAlternativas[0], 37) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou  t.tecla_pressionada(t.TECLA_1) ou  t.tecla_pressionada(t.TECLA_1_NUM))
			{
				perguntaAtual = perguntaAtual + 1
				u.aguarde(500)
				respostas[perguntaAtual-1] = perguntasNomes[perguntaAtual-1][2]

				se(respostas[perguntaAtual-1] == perguntasNomes[perguntaAtual-1][1+tp.cadeia_para_inteiro((perguntasNomes[perguntaAtual-1][1]), 10)])
					acertos = acertos + 1
			}
			
			senao se(mouse(185, 700, posAlternativas[1], 37) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou  t.tecla_pressionada(t.TECLA_2) ou  t.tecla_pressionada(t.TECLA_2_NUM))
			{
				perguntaAtual = perguntaAtual + 1
				u.aguarde(500)
				respostas[perguntaAtual-1] = perguntasNomes[perguntaAtual-1][3]
				
				se(respostas[perguntaAtual-1] == perguntasNomes[perguntaAtual-1][1+tp.cadeia_para_inteiro((perguntasNomes[perguntaAtual-1][1]), 10)])
					acertos = acertos + 1
			}	
			
			senao se(mouse(185, 800, posAlternativas[2], 37) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou  t.tecla_pressionada(t.TECLA_3) ou  t.tecla_pressionada(t.TECLA_3_NUM))
			{
				perguntaAtual = perguntaAtual + 1
				u.aguarde(500)
				respostas[perguntaAtual-1] = perguntasNomes[perguntaAtual-1][4]

				se(respostas[perguntaAtual-1] == perguntasNomes[perguntaAtual-1][1+tp.cadeia_para_inteiro((perguntasNomes[perguntaAtual-1][1]), 10)])
					acertos = acertos + 1
			}	
			
			senao se(mouse(185, 900, posAlternativas[3], 37) == verdadeiro e m.botao_pressionado(m.BOTAO_ESQUERDO) ou  t.tecla_pressionada(t.TECLA_4) ou  t.tecla_pressionada(t.TECLA_4_NUM))
			{
				perguntaAtual = perguntaAtual + 1
				u.aguarde(400)
				respostas[perguntaAtual-1] = perguntasNomes[perguntaAtual-1][5]

				se(respostas[perguntaAtual-1] == perguntasNomes[perguntaAtual-1][1+tp.cadeia_para_inteiro((perguntasNomes[perguntaAtual-1][1]), 10)])
					acertos = acertos + 1
			}	
		}
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 4144; 
 * @DOBRAMENTO-CODIGO = [24, 69, 100, 123, 204, 217, 229, 239, 255, 276, 322, 352, 383, 527, 653, 705, 725, 737, 814, 889];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */